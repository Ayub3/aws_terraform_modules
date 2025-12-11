resource "aws_db_subnet_group" "default" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.identifier}-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier           = var.identifier
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  allocated_storage    = var.allocated_storage
  port                 = var.port

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.vpc_security_group_id]

  multi_az                = var.multi_az
  storage_encrypted       = var.storage_encrypted
  publicly_accessible     = var.publicly_accessible
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  apply_immediately       = var.apply_immediately
  backup_retention_period = var.backup_retention_period
  tags                    = var.tags
}