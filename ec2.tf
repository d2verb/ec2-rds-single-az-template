# =============
# EC2 インスタンス
# =============
resource "aws_instance" "sample" {
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_1a.id
  ami                    = "ami-02892a4ea9bfa2192"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.sample.key_name

  tags = {
    Name = "${var.project}-ec2"
  }
}

resource "aws_key_pair" "sample" {
  key_name   = "${var.project}-kp"
  public_key = file(var.ssh_public_key_path)
}

# ===============
# セキュリティグループ
# ===============
resource "aws_security_group" "ec2" {
  name   = "${var.project}-ec2-sg"
  vpc_id = aws_vpc.sample.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.ec2_ingress_allowed_ip["http"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ec2_ingress_allowed_ip["ssh"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ec2_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

# =========================
# EC2 インスタンスの public dns
# =========================
output "ec2_endpoint" {
  value = aws_instance.sample.public_dns
}