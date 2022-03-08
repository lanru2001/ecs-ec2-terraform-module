account_id                = "362387340557"
vpc_cidr                  = "172.16.0.0/16"
public_subnets_cidr       = ["172.16.6.0/24", "172.16.7.0/24"]
private_subnets_cidr      = ["172.16.8.0/24", "172.16.9.0/24"]
create                    = true
name                      = "cw-app"
namespace                 = "cw-dev"
docker_image              = "nginx"
environment               = "cloudworld"
stage                     = "dev"
aws_region                = "us-east-2"
azs                       = ["us-east-2a", "us-east-2b"]
cloudwatch_log_group_name = "ecs/cloudworld-dev"
cloudwatch_log_stream     = "ecs"
bucket_name               = "cloudworld-lb-logs"
cw_container_port         = "80"
name_prefix               = "cloudworld-app"
health_check_path         = "/"
ami_id                    = "ami-0e4efed85dffc2b28"     #"ami-0231217be14a6f3ba"
PATH_TO_PUBLIC_KEY        = "mykey.pub"
PATH_TO_PRIVATE_KEY       = "mykey"
db_name                   = "cwDevBb"
db_instance_port          = 3306
username                  = "mysqladmin"
password                  = "Family1!" #store password in AWS secret manager
family                    = "mysql5.7"
engine                    = "mysql"
engine_version            = "5.7.26"
instance_class            = "db.t2.micro"
tag                       = "cw-app-dev"
container_port            = 80
disk_size                 = 10
pvt_desired_size          = 2
pvt_max_size              = 2
pvt_min_size              = 2
publ_desired_size         = 2
publ_max_size             = 2
publ_min_size             = 2
desired_size              = 2
instance_type             = "t2.medium"
identifier                = "cloudworld-dev-app-db"
autoscale_min             = "2"
autoscale_max             = "3"
autoscale_desired         = "2"
