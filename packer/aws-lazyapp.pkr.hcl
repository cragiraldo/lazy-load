
variable "aws_access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY")}"
}

variable "aws_secret_key" {
  type    = string
  default = "${env("AWS_SECRET_KEY")}"
}

# data "amazon-ami" "ubuntu" {
#   access_key  = "${var.aws_access_key}"
#   secret_key  = "${var.aws_secret_key}"
#   most_recent = true
#   owners      = ["099720109477"]
#   region      = "us-west-2"
# }

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "back" {
  access_key                  = "${var.aws_access_key}"
  secret_key                  = "${var.aws_secret_key}"
  ami_name                    = "back${local.timestamp}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  region                      = "us-west-2"
  source_ami                  = "ami-03d5c68bab01f3496"
  ssh_username                = "ubuntu"
}
source "amazon-ebs" "front" {
  access_key                  = "${var.aws_access_key}"
  secret_key                  = "${var.aws_secret_key}"
  ami_name                    = "front${local.timestamp}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  region                      = "us-west-2"
  source_ami                  = "ami-03d5c68bab01f3496"
  ssh_username                = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.back"]

  provisioner "shell" {
    environment_vars = ["DB_HOST=ds029837.mlab.com", "DB_PORT=29837", "DB_NAME=lazy_load_dev", "DB_USER=user", "DB_PASS=tnsPass0"]
    inline           = ["echo \"DB_PORT is $DB_PORT\"", "echo \"DB_PORT is $DB_PORT\"", "echo \"DB_NAME is $DB_NAME\"", "echo \"DB_USER is $DB_USER\"", "echo \"DB_PASS is $DB_PASS\""]
  }

  provisioner "shell" {
    script = "./scripts/backendinstall.sh"
  }

}
build {
  sources = ["source.amazon-ebs.front"]

  provisioner "shell" {
    environment_vars = ["DB_HOST=ds029837.mlab.com", "DB_PORT=29837", "DB_NAME=lazy_load_dev", "DB_USER=user", "DB_PASS=tnsPass0"]
    inline           = ["echo \"DB_PORT is $DB_PORT\"", "echo \"DB_PORT is $DB_PORT\"", "echo \"DB_NAME is $DB_NAME\"", "echo \"DB_USER is $DB_USER\"", "echo \"DB_PASS is $DB_PASS\""]
  }

  provisioner "shell" {
    script = "./scripts/frontendinstall.sh"
  }

}