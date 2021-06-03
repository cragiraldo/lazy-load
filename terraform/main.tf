provider "aws" {
  region = "us-west-2"
}

variable "ssh_key_path" {}
variable "vpc_id" {}
variable "amivar" {}

data "aws_ami" "amivarb" {
  most_recent = true
  owners = ["422235085863"]
}
data "aws_ami" "amivarf" {
  most_recent = true
  owners = ["422235085863"]
}

resource "aws_key_pair" "terra-key" {
  key_name   = "terra-key"
  public_key = file(var.ssh_key_path)
}

resource "aws_security_group" "allowapp"" {
  name        = "allowapp"
  description = "Permite comunicacion de la aplicacion"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH desde VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
    ingress {
    description = "app"
    from_port   = 0
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allowapp"
  }
}

resource "aws_instance" "backapp" {
  ami = data.aws_ami.amivarb.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [
    aws_security_group.allowapp.id
  ]
  tags = {
    Name = "backend"
  }
}
resource "aws_instance" "fronapp" {
  ami = data.aws_ami.amivarf.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [
    aws_security_group.allowapp.id
  ]
  tags = {
    Name = "fronted"
  }
}