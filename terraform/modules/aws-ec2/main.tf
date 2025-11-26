###############################################
# SecureTheCloud — AWS EC2 Module
###############################################

resource "aws_instance" "vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.instance_profile
  key_name               = null

  root_block_device {
    encrypted  = true
    kms_key_id = var.kms_key_id
  }

  tags = {
    Name = var.name
  }
}

# Attach EC2 → ALB Target Group
resource "aws_lb_target_group_attachment" "tg_attach" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.vm.id
  port             = 80
}

###############################################
# Ubuntu AMI Lookup
###############################################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
