# main.tf

terraform {
  backend "s3" {
    bucket  = "techbleat-class-cicd-state-bucket"
    key     = "envs/dev/capstone2/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = { Name = "cap2-bastion" }
}

# App Server
resource "aws_instance" "app_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = { Name = "cap2-app-server" }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "cap2-db-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_2.id]

  tags = { Name = "cap2-db-subnet-group" }
}

# RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier             = "cap2-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "cap2db"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = { Name = "cap2-postgres" }
}