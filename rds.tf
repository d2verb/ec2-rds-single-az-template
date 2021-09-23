# ===============
# RDS インスタンス
# ===============
resource "aws_db_instance" "sample" {
  name                   = "${var.project}_db"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.db_config["username"]
  password               = var.db_config["password"]
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.sample.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}

# ===============
# サブネットグループ
# ===============
resource "aws_db_subnet_group" "sample" {
  name       = "${var.project}-sng"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
}

# ===============
# セキュリティグループ
# ===============
resource "aws_security_group" "rds" {
  name   = "${var.project}-rds-sg"
  vpc_id = aws_vpc.sample.id
}

resource "aws_security_group_rule" "mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2.id
  security_group_id        = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
}

# ===============
# RDS のエンドポイント
# ===============
output "rds_endpoint" {
  value = aws_db_instance.sample.endpoint
}