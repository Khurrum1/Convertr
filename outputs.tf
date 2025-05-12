# debugging
output "subnet_cidrs" {
  value = [for i in range(var.subnet_count) : cidrsubnet(var.vpc_cidr, 12, i)]
}
