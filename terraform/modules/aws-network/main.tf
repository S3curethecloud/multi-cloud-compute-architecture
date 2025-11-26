############################################
# SecureTheCloud — AWS Zero Trust SG
############################################

resource "aws_security_group" "zero_trust" {
  name   = "stc-zero-trust-sg"
  vpc_id = var.vpc_id

  # BLOCK ALL inbound
  ingress {
    description = "Block all inbound by default"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = []
    ipv6_cidr_blocks = []
    prefix_list_ids = []
  }

  # ALLOW only outbound HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
  }

  tags = {
    Name = "zero-trust-sg"
  }
}
