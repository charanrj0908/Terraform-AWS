provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.vpcCIDRblock

tags = {
    Name = "${var.tagname}-vpc"
}
}
# IGW creation

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "${var.tagname}-igw"
}
}

# subnet creation

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
  tags = {
    Name = "${var.tagname}-pblicsbnet"
}
      }

# route table creation

resource "aws_route_table" "rte" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "${var.tagname}-pblcrtr"
}

  
}
# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.rte.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.gw.id
}
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "subnetassociation" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rte.id
}
# nacl creation 
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.example.id
  # allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  # allow egress port 22
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 

  

  tags = {
    Name = "${var.tagname}-nacl"
  }
}

# Create the Security Group
resource "aws_security_group" "sg" {
  vpc_id       = aws_vpc.example.id
  
  
  # allow ingress of port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingressCIDRblock  

  } 
  # allow ingress of port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingressCIDRblock  

  } 
  
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egressCIDRblock
  }
tags = {
   Name = "${var.tagname}-sg"
   
}
}

# instance creation

resource "aws_instance" "ec2instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.ami_key_pair_name
  user_data = "${file("install_apache.sh")}"
  security_groups = ["${aws_security_group.sg.id}"]
  subnet_id = aws_subnet.main.id
tags = {
    Name = "${var.tagname}-instance"
  }
}


