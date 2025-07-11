resource "aws_iam_role" "task-execution-role" {
  name               = "task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task-assume-role.json
}

data "aws_iam_policy_document" "task-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is
# an AWS-managed policy, it's okay.
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.task-execution-role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}
