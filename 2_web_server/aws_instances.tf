variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_server" {    # "<PROVIDER>_<TYPE>" "<NAME>"
  ami           = "ami-09e67e426f25ce0d7" # CONFIG
  instance_type = "t2.micro"
  tags = {
  Name = "Web_server" }

  vpc_security_group_ids = [aws_security_group.my_SG_webserver.id]
  user_data              = <<EOF
#!/bin/bash
myip='curl http://169.254.169.254/latest/meta-data/local-ipv4'
echo "Hello World? IP: $myip " > index.html
nohup busybox httpd -f -p 8080 &
EOF

}

resource "aws_security_group" "my_SG_webserver" {
  name        = "SG_webserver"
  description = "SG_webserver"
  #vpc_id      = aws_vpc.main.id

  ingress {

    #      description      = "TLS from VPC"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #      ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "SG_webserver"
  }
}

output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of the web server"
}

output "web_server_id" {
  value = aws_instance.web_server.id
}

output "security_group_name" {
  value = aws_security_group.my_SG_webserver.name
}

output "web_server_ingress" {
  value = aws_security_group.my_SG_webserver.ingress
}
