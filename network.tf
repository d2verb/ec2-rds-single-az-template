# ====
# VPC
# ====
resource "aws_vpc" "sample" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

# ========
# サブネット
# ========
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.sample.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-sn-1a"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.sample.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.project}-private-sn-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.sample.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.project}-private-sn-1c"
  }
}

# ===================
# インターネットゲートウェイ
# ===================
resource "aws_internet_gateway" "sample" {
  vpc_id = aws_vpc.sample.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# ===========
# ルートテーブル
# ===========
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.sample.id

  tags = {
    Name = "${var.project}-public-rt"
  }
}

resource "aws_route" "public" {
  gateway_id             = aws_internet_gateway.sample.id
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}