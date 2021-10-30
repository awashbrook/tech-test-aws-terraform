output "az_names" {
  description = "Available Zones in this Region"
  value       = data.aws_availability_zones.available.names
}
output "vpc_id" {
  description = "The ID of the VPC"
  # value       = module.vpc_application.vpc_id
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  # value       = module.vpc_application.igw_id
}
output "public_subnets_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public
}
output "private_subnets_ids" {
  description = "List of IDs of private subnets"
  # value       = module.vpc_application.private_subnets
}