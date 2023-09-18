


## VPC , SUBNETS , ELASTIC IP , NATGETWAY , PROVIDER  ====================================
variable "region" {
  description = "Region in which the bastion host will be launched"
}

variable "public_cidrs" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
}

variable "privet_cidrs" {
  type        = list(any)
  description = "CIDR block for Privet Subnet"
}
variable "rds_cidrs" {
  type        = list(any)
  description = "CIDR block for RDS Subnet"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC "
}
variable "availability_zones" {
  type        = list(string)
  description = "AZ in which all the resources will be deployed"
}
variable "mariadb_count" {
  default     = 1
  description = "VPC HAS 1 database"
}
variable "db_instance" {
  type = string
}



variable "ami_id" {
  type = string

}
variable "mysql_ami_id" {
  type = string
}
variable "ami_id_debian" {
  type = string

}
variable "public_ec2_type" {
  type = string
}
variable "privet_ec2_type" {
  type = string
}

variable "rds_ec2_type" {
  type = string
}


variable "wordperss_ec2_count" {
  type = number

}
## =============================== ACM AND ROUTE 53 ===========================
variable "web_domain_name" {
  type = string

}
variable "domain_name" {
  description = "hosted zone domin name"
  default     = "dev.devopsinabox.aaic.cc"
  type        = string
}
variable "hosted_zone_id" {
  description = "The name of the hosted zone in which to register this site"
  type        = string
}


variable "website-additional-domains" {
  type        = string
  description = "extra domain name"
  default     = "www.wordpress.dev.devopsinabox.aaic.cc"

}



variable "user" {
  description = "SQL User for WordPress"
  type        = string
}
variable "dbname" {
  description = "Database name for WordPress"
  type        = string
}
variable "password" {
  description = "User password for WordPress"
  type        = string
}
variable "root_password" {
  description = "User password for WordPress"
  type        = string
}


# EFS MOUNT VERIABLES  =====================================

variable "efs_location" {
  description = "EFS Drive should be mounted to the machine at perticluter directory/path {/path/path....} "
  type        = string
}
variable "monitoring" {
  description = "whether to enable ec2 detailed monitoring"
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "whether to disable api termination"
  type        = bool
  default     = false
}



## ===============aurora_subnet_group RDS =======================
variable "subnet_group_name" {
  description = "Provide a unique name"
  type        = string
}
variable "cluster_name" {
  description = "Unique name is used for cluster name"
  type        = string
}
variable "engine" {
  description = "Type of engine as per requirement"
  type        = string
}
variable "engine_version" {
  description = "Engine version of engine as per requirement"
  type        = string
}
variable "database_name" {
  description = "Database name is used for logging for wordpress"
  type        = string

}

variable "db_username" {
  description = "Database user name is used for logging for wordpress"
  type        = string
}

variable "db_password" {
  description = "Database  password is used for logging for wordpress"
  type        = string
}
variable "retention_period" {
  description = "retention period users as per requirements"
  type        = number
}

variable "preferred_backup_window" {
  description = "preferred backup window for backup of database "
  type        = string
}
variable "port_no" {
  description = "port for database  as per the  database"
  type        = string
}

variable "instance_class" {
  description = "EC2 database size/class as per the requirement"
  type        = string
}

variable "cluster_engine" {
  description = " Database engine as per the requirement"
  type        = string
}

##========================== reids cahse  =============================

variable "ec_az_mode" {
  type        = string
  description = "Specifies whether the nodes is going to be created across azs or in a single az"

  validation {
    condition     = var.ec_az_mode == "cross-az" || var.ec_az_mode == "single-az"
    error_message = "The az_mode value can only be 'cross-az' or 'single-az'."
  }
}

variable "env" {
  type        = string
  default     = "dev"
  description = "current enviroment pod, dev etc.."
}