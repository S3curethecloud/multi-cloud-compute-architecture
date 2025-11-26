terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

###############################################
# AZURE PROVIDER
###############################################

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

###############################################
# AZURE NETWORK MODULE
###############################################

module "azure_network" {
  source       = "../../modules/azure-network"

  name         = "stc-azure"
  location     = var.azure_location

  address_space     = ["10.20.0.0/16"]
  subnet_a_prefix   = ["10.20.1.0/24"]
  subnet_b_prefix   = ["10.20.10.0/24"]
}

###############################################
# AZURE LOAD BALANCER (PUBLIC LB)
###############################################

module "azure_lb" {
  source = "../../modules/azure-lb"

  # Same prefix for naming convention
  name     = "stc"
  location = var.azure_location

  # values coming from azure-network module
  resource_group = module.azure_network.resource_group
}

###############################################
# AZURE VM (PRIVATE SUBNET)
###############################################

module "azure_vm" {
  source = "../../modules/azure-vm"

  name            = "stc-azure-vm"
  location        = var.azure_location

  # Required inputs from azure-network module
  resource_group     = module.azure_network.resource_group
  private_subnet_id  = module.azure_network.private_a_id
  nsg_id             = module.azure_network.zero_trust_nsg_id

  # Required input from azure-lb module
  backend_pool_id    = module.azure_lb.backend_pool_id

  # VM settings
  vm_size            = var.azure_vm_size
  admin_username     = var.azure_admin_username
  admin_password     = var.azure_admin_password
  ssh_public_key_path = "~/.ssh/id_rsa.pub"
}

###############################################
# AZURE MONITORING & LOGGING
###############################################

module "azure_monitoring" {
  source = "../../modules/azure-monitoring"

  prefix          = "stc"
  resource_group  = module.azure_network.resource_group
  location        = var.azure_location
  subscription_id = var.azure_subscription_id
  nsg_id          = module.azure_network.zero_trust_nsg_id
}

###############################################
# VPC
###############################################

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "stc-vpc"
  }
}

###############################################
# PRIVATE SUBNETS (EC2)
###############################################

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = { Name = "stc-private-a" }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = { Name = "stc-private-b" }
}

###############################################
# PUBLIC SUBNETS (ALB)
###############################################

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.10.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = { Name = "stc-public-a" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.11.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = { Name = "stc-public-b" }
}

###############################################
# INTERNET GATEWAY + PUBLIC ROUTING
###############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "stc-igw" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

###############################################
# ZERO TRUST NETWORK MODULE
###############################################

module "aws_network" {
  source = "../../modules/aws-network"
  vpc_id = aws_vpc.main.id
}

###############################################
# ALB MODULE
###############################################

module "aws_alb" {
  source = "../../modules/aws-alb"

  name   = "stc-alb"
  vpc_id = aws_vpc.main.id
  sg_id  = module.aws_network.zero_trust_sg_id

  public_subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

###############################################
# EC2 IAM ROLE
###############################################

resource "aws_iam_role" "ec2_role" {
  name = "stc-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "stc-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

###############################################
# EC2 MODULE
###############################################

module "aws_ec2" {
  source = "../../modules/aws-ec2"

  name             = "stc-ec2"
  instance_type    = "t3.micro"
  subnet_id        = aws_subnet.private_a.id
  security_group_id = module.aws_network.zero_trust_sg_id
  kms_key_id       = null
  instance_profile = aws_iam_instance_profile.ec2_profile.name
  target_group_arn = module.aws_alb.tg_arn
}

###############################################
# MONITORING MODULE (Flow Logs + CloudTrail)
###############################################

module "aws_monitoring" {
  source = "../../modules/aws-monitoring"

  prefix = "stc"
  region = var.aws_region

  vpc_id  = aws_vpc.main.id
  alb_arn = module.aws_alb.alb_arn

  flow_logs_bucket  = "stc-flowlogs-${var.aws_region}"
  alb_logs_bucket   = "stc-alb-logs-${var.aws_region}"
  cloudtrail_bucket = "stc-cloudtrail-${var.aws_region}"
}
