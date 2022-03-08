#Key pair 
resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair2"
  public_key = file(var.PATH_TO_PUBLIC_KEY)

}

#Cloudwatch log group 
resource "aws_cloudwatch_log_group"  "cw_log" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 30
}

#Cloudwatch log stream 
resource "aws_cloudwatch_log_stream" "cw_stream" {
  name           = var.cloudwatch_log_stream
  log_group_name = aws_cloudwatch_log_group.cw_log.name
}

#ECS Cluster 
resource "aws_ecs_cluster"  "cw_cluster" {
  name = "${var.name}-cluster"
}

resource "aws_ecs_capacity_provider" "test" {
  name = "capacity-provider-test"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs-cluster.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

data "template_file" "app" {
  template = file("template/crownworld_app.json.tpl")

  vars = {
    docker_image              = var.docker_image
    aws_region                = var.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    cloudwatch_log_stream     = var.cloudwatch_log_stream
    local_environment_prefix  = local.environment_prefix
  }
}

resource "aws_ecs_task_definition"  "cw_task_definition" {
  
  count                    = var.create ? 1 : 0
  family                   = "crownworld-app"
  container_definitions    = data.template_file.app.rendered
  network_mode             = "host"
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = [ "EC2" ]
  depends_on               = [ aws_launch_configuration.cw_launch_config ]

}

#ECS Service 
resource "aws_ecs_service" "app_service" {
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.cw_cluster.id
  task_definition                    = aws_ecs_task_definition.cw_task_definition[0].arn
  desired_count                      = 1
  iam_role                           = aws_iam_role.ecs_service_role.arn
  
  depends_on                         = [ aws_alb_listener.ecs_alb_http_listner, aws_iam_role.ecs_service_role ]
  launch_type                        = "EC2"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  
  ordered_placement_strategy {
    type     = "binpack"
    field    = "cpu"
  }


  load_balancer {
    target_group_arn = aws_alb_target_group.cw_alb_tg_group.arn 
    container_name   = "${local.environment_prefix}"
    container_port   = var.cw_container_port
  }
}
