region             = "us-east-1"
availability_zones = ["us-east-1b", "us-east-1c"]
vpc_cidr           = "10.0.0.0/16"
public_cidrs       = ["10.0.0.0/24", "10.0.1.0/24"]
privet_cidrs       = ["10.0.2.0/24", "10.0.3.0/24"]
rds_cidrs          = ["10.0.4.0/24", "10.0.5.0/24"]

## EC2 
/* ec2_owners = ["099720109477"]
aws_ami_name = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]   */
ami_id              = "ami-053b0d53c279acc90" # (UBANTU EC2)  
wp_ami_id           = "ami-0a77f045844e0bee1"
mysql_ami_id        = "ami-0a0b6cd1a679c618d" ## (MySql-DB-AMI-(Ubantu))
ami_id_debian       = "ami-06db4d78cb1d3bbf9"
wordperss_ec2_count = 2
public_ec2_type     = "t2.micro"
privet_ec2_type     = "t2.micro"
rds_ec2_type        = "t2.micro"
db_instance         = "db.t2.micro"

### efs mount location
efs_location = "/var/www/html/wp-content/uploads"
# route 53 and ssl cirtificate
web_domain_name = "wp.dev.devop***.***.cc"
hosted_zone_id  = "Z***********FTUUN3"
root_password   = "Password"
user            = "wordpress"
password        = "Password"
dbname          = "Wordpress"


##aurora_subnet_group RDS
subnet_group_name       = "my-aurora_db_subnet_group"
cluster_name            = "aurora-cluster-wordpress-01"
engine                  = "aurora-mysql"
engine_version          = "5.7"
database_name           = "mytestdb"
db_username             = "admin"
db_password             = "admin123"
retention_period        = 5
preferred_backup_window = "07:00-09:00"
port_no                 = 3306
instance_class          = "db.t3.small"
cluster_engine          = "aurora-mysql"
ec_az_mode              = "cross-az"

