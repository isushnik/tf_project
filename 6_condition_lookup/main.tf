
provider "aws" {
  region = "us-east-2"
}

variable "env" {
  default = "dev"
}

variable "ec2_size" {
  default = {
    "prod" = "t3.micro"
    "dev"  = "t2.micro"
  }
}

resource "aws_instance" "server1" {
  ami           = "ami-074cce78125f09d61"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
}
