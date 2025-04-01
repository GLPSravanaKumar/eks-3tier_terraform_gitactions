data "aws_availability_zones" "az" {
    state= "available"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnets" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnets"{
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8 , count.index + 2)
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.az.names[count.index]

    tags = {
        Name = "private_subnet_${count.index}"
    }
}

resource "aws_subnet" "db_subnets"{
    count = 1
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8 , count.index + 4)
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.az.names[count.index]

    tags = {
        Name = "db_subnet_${count.index}"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "glps_eks_igw"
  }
}

resource "aws_internet_gateway_attachment" "igw_attac" {
  vpc_id = aws_vpc.main.id
  internet_gateway_id = aws_internet_gateway.igw.id
   lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route_table" "rt_custom" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "glps_eks_rt_public"
  }
}

resource "aws_route_table_association" "custom" {
    count = 2
    subnet_id = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.rt_custom.id
}

resource "aws_route_table" "rt_main1" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat.id
    }
    tags ={
      Name = "glps_eks_rt_private"
    }
}

resource "aws_route_table_association" "main1" {
  count = 2
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rt_main1.id
}

resource "aws_route_table" "rt_main2" {
  vpc_id = aws_vpc.main.id

  tags ={
    Name = "glps_eks_rt_db"
  }

}

resource "aws_route_table_association" "main2" {
  count = 1
  subnet_id = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.rt_main2.id
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "glps_eks_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.eip.id  

  tags = {
    Name = "glps_eks_nat"
  }
}