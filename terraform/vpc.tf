resource "aws_vpc" "own-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true 
    
}
resource "aws_subnet" "public" {
    cidr_block = var.public_cidr
    vpc_id = aws_vpc.own-vpc.id 
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true 
  
}
resource "aws_subnet" "private" {
    cidr_block = var.private_cidr
    vpc_id = aws_vpc.own-vpc.id 
    availability_zone = "us-east-1b"
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.own-vpc.id 
    route {
        cidr_block = var.cidr
        gateway_id = aws_internet_gateway.igw.id

    }
}
resource "aws_route_table_association" "public1" {
    subnet_id = aws_subnet.public.id 
    route_table_id = aws_route_table.public.id 
  
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.own-vpc.id 
    route {
        cidr_block = var.cidr
        nat_gateway_id = aws_nat_gateway.nat.id
    }
  
}
resource "aws_route_table_association" "private1" {
    subnet_id = aws_subnet.private.id 
    route_table_id = aws_route_table.private.id 
  
}
resource "aws_eip" "eip" {
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public.id 
    depends_on = [ aws_internet_gateway.igw ]
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.own-vpc.id 
  
}
resource "aws_security_group" "SG" {
    name = "SG" 
    vpc_id = aws_vpc.own-vpc.id 
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["10.0.0.0/16"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1 
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}