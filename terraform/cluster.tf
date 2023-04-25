
########################
## Variables
########################

variable "user-name" {
  description = "Your unique user name"
}

variable "vpc-id" {
  default = "vpc-5990f03e"
  description = "The ID of the VPC that the RDS cluster will be created in"
}

variable "vpc-name" {
  default = "default"
}

variable "vpc-rds-subnet-ids" {
  default = "subnet-06ba56e1d47dacda4,subnet-09ce7efe8579c81f7,subnet-0b9530fb1b87199c4"
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "vpc-rds-security-group-id" {
  description = "The ID of the security group that should be used for the RDS cluster instances"
  default = "sg-074b2409616207c18"
}

variable "main-username" {
  default = "availability"
}

variable "main-password" {
  default = "MySecretPassw0rd"
}

########################
## Cluster
########################

resource "aws_rds_cluster" "aurora_cluster" {

  cluster_identifier            = "${var.user-name}-aurora-cluster"
  database_name                 = "availability"
  master_username               = "${var.main-username}"
  master_password               = "${var.main-password}"
  backup_retention_period       = 0
  skip_final_snapshot           = true
  vpc_security_group_ids        = ["${var.vpc-rds-security-group-id}"]
  apply_immediately             = true

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_db_subnet_group" "aurora_subnet_group" {

  name          = "${var.user-name}_aurora_db_subnet_group"
  description   = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids    = ["subnet-06ba56e1d47dacda4","subnet-09ce7efe8579c81f7","subnet-0b9530fb1b87199c4"]
}

########################
## Output
########################

output "cluster_address" {
  value = "${aws_rds_cluster.aurora_cluster}"
  sensitive = true
}