#
# Variables Configuration
#

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets for internet-facing applications/services"
  default     = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for internal application/services"
  default     = ["10.10.12.0/22", "10.10.16.0/22", "10.10.20.0/22"]
}

variable "cluster-name" {
  type    = "string"
  default = "demo"
}
