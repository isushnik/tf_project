
output "Amazon_Linux_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "Amazon_Linux_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "region" {
  value = var.region
}
