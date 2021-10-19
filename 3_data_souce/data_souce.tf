
provider "aws" {}

data "aws_availability_zone" "working" {}

#resource "aws_security_group" "my_SG_webserver" {




output "aws_availability_zone" {
  value = data.aws_availability_zone.working.id
}
