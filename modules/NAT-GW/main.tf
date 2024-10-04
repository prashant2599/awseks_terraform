resource "aws_eip" "eks-eip-1" {
    vpc = true

    tags = {
      name = "NAT-GW-EIP-1"
    }
  
}

resource "aws_eip" "eks-eip-2" {
    vpc = true

    tags = {
      name = "NAT-GW-EIP-2"
    }
}


resource "aws_nat_gateway" "eks-nat-gw1" {
    allocation_id = aws_eip.eks-eip-1.id
    subnet_id = var.PRI_SUB3_ID

    tags = {
      name = "NAT-GW-1"
    }
  
}

resource "aws_nat_gateway" "eks-nat-gw2" {
    allocation_id = aws_eip.eks-eip-2.id
    subnet_id = var.PRI_SUB4_ID

    depends_on = [ var.IGW_ID ]

    tags = {
      name = "NAT-GW-2"
    }
  
}


resource "aws_route_table" "Pri-rt-a" {
  vpc_id = var.VPC_ID

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-nat-gw1.id
  }

  tags = {
    Name = "pri-rt-a"
  }
}

resource "aws_route_table_association" "pri-sub3-with-pri-rt-a" {
  subnet_id      = var.PRI_SUB3_ID
  route_table_id = aws_route_table.Pri-rt-a.id
}




resource "aws_route_table" "Pri-rt-b" {
  vpc_id = var.VPC_ID

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-nat-gw2.id
  }

  tags = {
    Name = "pri-rt-b"
  }
}


resource "aws_route_table_association" "pri-sub4-with-pri-rt-b" {
  subnet_id      = var.PRI_SUB4_ID
  route_table_id = aws_route_table.Pri-rt-b.id
}


