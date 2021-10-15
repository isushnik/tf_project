provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_server" { # "<PROVIDER>_<TYPE>" "<NAME>"
  ami = "ami-02e136e904f3da870"         # CONFIG
  #  count         = 2
  instance_type = "t2.micro"
  tags = {
  Name = "Web_server" }
}
