#
# Outputs Configuration
#

output "private-cidr" {
  value = var.private_subnets
}

output "private-subnets" {
  value = aws_subnet.private[*].id
}

output "public-subnets" {
  value = aws_subnet.public[*].id
}

output "vpc" {
  value = aws_vpc.main.id
}
