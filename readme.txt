Reqirment as below :
We need to setup following: VPC with two public, two private and two database
1.	Setup one EC2 instance in private subnet. Install WordPress in the location /var/www/html  with auto sacling and load balencing
2.	And EFS Drive should be mounted to the machine at location /var/www/html/wp-content/uploads
3.	One Aurora MySQL should be deployed into db private subnet and WordPress needs to use that database. 
4.	WordPress EC2 should be in autoscaling group with one AMI
5.	In order to access WordPress you need to use AWS ALB deployed into public subnet
6.    Use redis is used for ealstic cashe of RDS
