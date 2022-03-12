# S3 remote state. 
terraform {
  backend "s3" {
    bucket         = "tf-remote-bkt1"
    key            = "project/ecs-ec2"
    region         = "us-east-2"
    dynamodb_table = "cw_locking_dynamodb"

  }
}
