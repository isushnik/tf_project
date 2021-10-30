
provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "serv_amazon_linux" {
  #ami = "ami-02e136e904f3da870" # us-east-1
  #ami = "ami-074cce78125f09d61" # us-east-2
  ami                    = data.aws_ami.latest_amazon_linux.id
  count                  = var.count_server
  instance_type          = "t2.micro"
  tags                   = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server_amazon_linux" }) # Development Server_amazon_linux
  vpc_security_group_ids = [aws_security_group.SG_amazon_linux.id]

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_security_group" "SG_amazon_linux" {
  name        = "SG_amazon_linux"
  description = "SG_amazon_linux"
  #vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allow_ports
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
    #      ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.common_tags, { Name = "SG_amazon_linux" })

}
