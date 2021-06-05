provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "applazy" {
  most_recent = true

  # filter {
  #   name   = "name"
  #   values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  # }

  # filter {
  #   name   = "virtualization-type"
  #   values = ["hvm"]
  # }

  owners = ["099720109477"]
}

variable "ssh_key" {}
variable "vpc_id" {}

resource "aws_key_pair" "deployer" {
  key_name   = "applazy_key"
  public_key = file(var.ssh_key)
}

resource "aws_security_group" "allow_remote_ssh" {
  name        = "allow_remote_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_remote_ssh"
  }
}

resource "aws_instance" "back" {
  ami = "ami-03b9434d33b4f8956"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_remote_ssh.id
  ]
  tags = {
    Name = "backend"
  }
}
resource "aws_instance" "front" {
  ami = "ami-03b9434d33b4f8956"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_remote_ssh.id
  ]
  tags = {
    Name = "frontend"
  }
}
output "ip_instance_front" {
  value = aws_instance.front.public_ip
}
output "ip_instance_back" {
  value = aws_instance.back.public_ip
}

output "ssh_backend" {
  value = "ssh -l ubuntu ${aws_instance.back.public_ip}"
}
output "ssh_fronted" {
  value = "ssh -l ubuntu ${aws_instance.front.public_ip}"
}