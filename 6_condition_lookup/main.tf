
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

variable "allow_ports" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "22"]

  }
}

variable "count_srv" {
  default = "1"
}

resource "aws_instance" "server1" {
  ami           = "ami-074cce78125f09d61"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
}

resource "aws_security_group" "SG_amazon_linux" {
  name        = "SG_amazon_linux"
  description = "SG_amazon_linux"
  #vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.env == "prod" ? var.allow_ports["prod"] : var.allow_ports["dev"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "SG_amazon_linux" }
}


# ненужный ресурс с произвольным именем
resource "random_string" "random_name_instance" {
  length = 8
  #special = False
  #override_special = "/@£$"
}

resource "aws_instance" "random_name_instance" {
  ami           = "ami-074cce78125f09d61"
  instance_type = "t2.micro"
  count         = var.env == "prod" ? 3 : 1
  tags = {
    Name = "Server Build by Terraform"
    #Name  = random_string.random_name_instance.result
    Owner = "isushnik"
  }
}


# ненужный ресурс с произвольным кол-вом серверов
resource "random_integer" "count_server" {
  min = 1
  max = 5
}

output "random_name_instance" {
  value = random_string.random_name_instance.result
}


output "aws_security_group" {
  value = aws_security_group.SG_amazon_linux.name
}
