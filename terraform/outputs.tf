#
# Outputs Configuration
#

output "private-cidr" {
  value = var.private_subnets
}

output "private-subnets" {
  value = aws_subnet.main-private[*].id
}

output "public-subnets" {
  value = aws_subnet.main-public[*].id
}

output "vpc" {
  value = aws_vpc.main.id
}
