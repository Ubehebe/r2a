# based on https://section411.com/2019/07/hello-world



resource "aws_ecs_cluster" "test-cluster" {
  name = "test-cluster"
}

resource "aws_ecs_service" "test-service" {
  name            = "test"
  cluster         = aws_ecs_cluster.test-cluster.arn
  task_definition = aws_ecs_task_definition.test-definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  # required when launch_type is "FARGATE", but terraform doesn't fail until
  # terraform apply.
  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.r2a-http-ingress.id,
      aws_security_group.r2a-allow-all-egress.id,
    ]
    subnets = [
      aws_subnet.r2a-public-subnet.id,
      aws_subnet.r2a-private-subnet.id
    ]
  }
}

resource "aws_ecs_task_definition" "test-definition" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task-execution-role.arn
  # cpu and memory have weird syntax and semantics. see
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definitions
  cpu    = ".25 vCPU"
  memory = "0.5 GB"
  # this is the only network mode supported for fargate, but you still have to specify it.
  network_mode = "awsvpc"
  container_definitions = jsonencode([
    {
      name  = "http-echo"
      image = "hashicorp/http-echo:1.0"
    }
  ])
}