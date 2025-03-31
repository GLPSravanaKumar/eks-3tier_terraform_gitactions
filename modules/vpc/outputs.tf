output "vpc_id" {
    value = aws_vpc.main.id
}

output "pub_subnet_ids" {
    value = aws_subnet.public_subnets[*].id
}

output "pvt_subnet_ids" {
    value = aws_subnet.private_subnets[*].id
}

output "db_subnet_ids" {
    value = aws_subnet.db_subnets[*].id
}