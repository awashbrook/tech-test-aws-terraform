output "az_names" {
  description = "Available Zones in this Region"
  value       = data.aws_availability_zones.available.names
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gateway.id
}
output "public_subnets_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}
# output "private_subnets_ids" {
#   description = "List of IDs of private subnets"
#   value       = 
# }

output "elb_dns" {
  description = "Load balancer DNS name"
  value       = aws_elb.my-elb.dns_name
}
output "elb_subnets_ids" {
  description = "List of IDs of public subnets containing load balancer"
  value       = aws_elb.my-elb.subnets
}
