variable "count_server" {
  type    = number
  default = 1
}

provider "aws" {
  region = "us-east-2"
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
  ami           = data.aws_ami.latest_amazon_linux.id
  count         = var.count_server
  instance_type = "t2.micro"
  tags = {
  Name = "serv_amazon_linux" }

  vpc_security_group_ids = [aws_security_group.SG_amazon_linux.id]

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_security_group" "SG_amazon_linux" {
  name        = "SG_amazon_linux"
  description = "SG_amazon_linux"
  #vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #      ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #      ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG_amazon_linux"
  }
}






output "Amazon_Linux_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "Amazon_Linux_id" {
  value = data.aws_ami.latest_amazon_linux.id
}
