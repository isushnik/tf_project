variable "count_server" {
  type    = number
  default = 1
}

variable "region" {
  description = "Please Enter AWS Region"
  type        = string
  default     = "us-east-1" # US East (Ohio)us-east-2
}

variable "allow_ports" {
  description = "List of ports to open server"
  type        = list(any)
  default     = ["80", "8080", "443", "22"]
}

variable "common_tags" {
  description = "Common tags to apply to all resource"
  type        = map(any)
  default = {
    Owner       = "isushnik"
    Project     = "Phoenix"
    Environment = "Development"
  }
}
