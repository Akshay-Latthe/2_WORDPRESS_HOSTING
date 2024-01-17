Requirements  are as follows:
We need to setup the following: VPC with two public, two private and two database
1.	Setup one EC2 instances in private subnet. Install WordPress in the location /var/www/html  with auto scaling and load balancing
2.	And EFS Drive should be mounted to the machine at location /var/www/html/wp-content/uploads
3.	One Aurora MySQL should be deployed into db private subnet and WordPress needs to use that database. 
4.	WordPress EC2 should be in auto scaling group with one AMI
5.	In order to access WordPress you need to use AWS ALB deployed into public subnet
6.  Use redis is used for elastic cashe of RDS

# How to deploy a three-tier architecture in AWS using Terraform?

### What is Terraform?

Terraform is an open-source infrastructure as a code (IAC) tool that allows to create, manage & deploy the production-ready environment. Terraform codifies cloud APIs into declarative configuration files. Terraform can manage both existing service providers and custom in-house solutions.

![1](https://github.com/Akshay-bl/2_WORDPRESS_HOSTING/blob/main/1.png)


In this tutorial, I will deploy a three-tier application in AWS using Terraform.

![2](https://github.com/Akshay-bl/2_WORDPRESS_HOSTING/blob/main/2.png)

### Prerequisites:

* Basic knowledge of AWS & Terraform & packer 
* AWS account
* AWS Access & Secret Key
### Installation Prerequisites :

* AWS cli is installed and configured with aws account
* Terraform installed and configured

> In this project, I have used some variables also that I will discuss later in this article.

**Step 1: - Clone the git repository**   

**Step 2:-  Go to packer directory and in that  app2.sh file and  aws-debion.pkr.hcl as per Git repo**

    * We use this to Create AMI of the Wordpress on AWS EC2. This AMI we are using in the Autosacling group. *

## steps:

* 1) aws-debion.pkr.hcl file content variables, required_plugins, locals, source, build blocks for AMI creation.
* 2) "app2.hcl" is shell script used for aws-debion.pkr.hcl file in build which will run on aws EC2 instance 

### RUN This command in packer directory
    ** "packer build aws-debion.pkr.hcl" **

***Copy the AMI ID FORM CONSOLE use that AMI in following Autoscaling Group Terraform Code  AMI ID ***
AWS AMI is get created on your AWS account
or go to the AMI IN AWS EC2 use that AMI in following Autoscaling Group Terraform Code  AMI ID. 

#AMI ID LOOK LIKE THIS "ami-0814cfadf25b13f"

**Step 3:- Terraform files ".tf" in 2_WORDPRESS_HOSTING Directory**

*The 1_vpc_&_keypair.tf file content VPC , SUBNETES, INTERNET GETWAY, ELASTIC IP , NAT GETWAYES,  ROUTE TABLES Terraform Code IN THE THIS FILE 

* The 1.1_securityG.tf file content all required security groups Terraform Code in this  FILE 

* The 1.2_bh_ec2.tf file content all required security groups Terraform Code in this  FILE 

* The 1.3_alb.tf file content Application Load Balancer Terraform Code in this  FILE 

* The 1.4_efs.tf file content EFS STORAGE AND MOUNT POINTS OF EFS STORAGE Terraform Code in this  FILE  

* The 1.4.1_ec2-wp.tf file content  'Launch Template' for AUTOSCALING GROUP WITH Abouv "AMI ID" and  script in the file location "template_files/bootstrap_wp.tpl"  in this  FILE  is used 

       * bootstrap_wp.tpl file content the script to attache EFS storage for every new instance in auto scaling group and attach the AWS AI of wordperess with RDS BD with cridentiles of DB 

* The 1.5_wp_autoscaling.tf content  AUTO SCALING GROUP AND  AUTO SCALINGPOLICIES Terraform Code in this  FILE 

* The 1.6_acmcif_&_route53.tf content  ACM CERTIFICATE AND ROUTE53 WITH "A" NAME RECORD "DNS" Terraform Code in this  FILE  

* The 1.7_rds_new.tf  RDS Aurora DB cluster Terraform Code in this  FILE 

* The 1.8_redis.tf REDIS ELASTIC CASHES IS attached to RDS by Terraform Code in this  FILE 

* config.tf conatent Terraform code for terraform configuration

* output.tf conatent Terraform code for terraform OUTPUTS form all above infra created 

* terraform.tfvars conatent ALL VARIABLES OF ALL ABOVE FILES IN SINGLE FILE WHICH WE CAN CHANGE DYNAMICALLY for all above infra  we are creating 

* vars.tf   ALL VARIABLES OF ALL ABOVE FILES IN SINGLE FILE WHICH WE CAN CHANGE DYNAMICALY for all above infra  we are creating  


So, now our entire code is ready. We need to run the below steps to create infrastructure.
## steps: 
* go to the 2_WORDPRESS_HOSTING directory
## RUN Follwing commands: 
* "terraform init" is to initialize the working directory and downloading plugins of the provider
* "terraform plan" is to create the execution plan for our code
* "terraform apply" is to create the actual infrastructure. It will ask you to provide the Access Key and Secret Key in order to create the infrastructure. So, instead of hardcoding the Access Key and Secret Key, it is better to apply at the run time.


**Step 4:- Verify the resources**

* Terraform will create below resources

  * VPC
  * Public Subnets, Private Subnets, RDS Subnets
  * Route Table
  * Internet Gateway
  * Route Table Association
  * Security Groups for Web & RDS instances
  * Basstion Host EC2
  * EFS Storage
  * Application Load Balancer with target group
  * EC2 instances for autoscalig 
  * RDS instance 
  * Redis Cache instances are created 
  * Route53 and ACM with DNS for "domain name"


** Step 5:- Verify DNS is workig ON incognito mode MODE"**

Once the resource creation finishes you can get the DNS  in AWS ACCOUNT ON ROUTE53 ACCESS THAT "

That’s it now, you have learned how to create various resources in AWS using Terraform.