variable "identifier" {
  description = "Unique name for the RDS instance"
  type        = string
}

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "username" {
  type        = string
  description = "Master username"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Master password"
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "port" {
  type    = number
  default = 3306
}

variable "vpc_security_group_id" {
  description = "Single security group ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of at least 2 subnet IDs in different AZs"
  type        = list(string)
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "storage_encrypted" {
  type    = bool
  default = true
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "apply_immediately" {
  type    = bool
  default = true
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "parameter_group_name" {
  type        = optional(string)
  description = "List of at least 2 subnet IDs in different AZs"
}