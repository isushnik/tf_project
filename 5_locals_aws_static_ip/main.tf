
provider "aws" {
  region = var.region
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  reg               = data.aws_region.current.description
  full_project_name = "${var.owner} owner of ${var.project} "
}

locals {
  avz = join(",", data.aws_availability_zones.available.names)
}

resource "aws_eip" "my_static_ip" {
  tags = {
    Name  = "Static IP"
    owner = var.owner
    #region             = local.reg
    #availability_zones = local.avz
    fpn = local.full_project_name

  }

}
