
#AWS launch configuration
resource "aws_launch_configuration"  "cw_launch_config" {

  name                        = "${var.name}-launch-config"
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  security_groups             = [ aws_security_group.cw_launch_config.id ]
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  key_name                    = aws_key_pair.mykeypair.key_name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cw_cluster.name} >> /etc/ecs/ecs.config"

}

resource "aws_autoscaling_group"  "ecs-cluster" {

  name                      = "${var.name}_auto_scaling_group"
  min_size                  = var.autoscale_min
  max_size                  = var.autoscale_max
  desired_capacity          = var.autoscale_desired
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.cw_launch_config.name
  vpc_zone_identifier       = [ aws_subnet.app_public_subnets[0].id , aws_subnet.app_public_subnets[1].id ]  
  health_check_grace_period = 300
  
}
