[
  {
    "image": "${docker_image}",
    "name": "${local_environment_prefix}",
    "essential": true,
    "cpu": 256,
    "memoryReservation": 512,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "mountPoints": [],
    "entryPoint": [],
    "command": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${aws_region}",
        "awslogs-group": "${cloudwatch_log_group_name}",
        "awslogs-stream-prefix": "${cloudwatch_log_stream}"
      }
    },
   
    "placement_constraints": [],
   
    "volume": []
  }
]
