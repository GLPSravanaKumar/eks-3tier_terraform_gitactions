data "aws_availability_zones" "az" {
    state= "available"
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.cluster_name}/vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name                                        = "${var.cluster_name}-public-subnet-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/alb"                    = "1"
    "kubernetes.io/role/elb" = "1" 
  }
}

resource "aws_subnet" "private_subnets"{
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr[count.index]
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.az.names[count.index]

    tags = {
    Name                                        = "${var.cluster_name}-private-subnet-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-alb"           = "1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "db_subnets"{
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidr[count.index]
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.az.names[count.index]

    tags = {
    Name                                        = "${var.cluster_name}-db-subnet-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-alb"           = "1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}/eip"
  }
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.cluster_name}/igw"
  }
}

resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.eip.id  

  tags = {
    Name = "${var.cluster_name}/nat"
  }
  depends_on = [ aws_eip.eip ]
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.cluster_name}/public_rt"
  }
}

resource "aws_route_table_association" "pub_rt" {
    count = 2
    subnet_id = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.custom.id
}

resource "aws_route_table" "pvt_rt" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat.id
    }
    tags ={
      Name = "${var.cluster_name}/private_rt"
    }
}

resource "aws_route_table_association" "pvt_rt" {
  count = 2
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat.id
    }
  tags ={
    Name = "${var.cluster_name}/db_rt"
  }
}

resource "aws_route_table_association" "db_rt" {
  count = 2
  subnet_id = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.db_rt.id
}


