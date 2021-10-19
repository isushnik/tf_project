
#variable "vpc_id" {}

provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_vpcs" "current_aws_vpcs" {}
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "Prod"
  }
}


output "aws_availability_zone" {
  value = data.aws_availability_zones.working.names
}


output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.0.0/16"
}

output "aws_vpcs" {
  value = data.aws_vpcs.current_aws_vpcs.ids
}
