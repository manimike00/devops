data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    cluster_name = "${var.name}-cluster"
  }
}

resource "aws_iam_role" "this" {
  name = "${var.name}-ecs-instance-role"
  path = "/ecs/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-ecs-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"
}

resource "aws_security_group" "ecs_instance_sg" {
  name        = "${var.name}-instance-sg"
  description = "Security Group for ECS Instance"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.security_groups
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "this" {
  name = "${var.name}-lc"
  image_id = data.aws_ami.amazon_linux_ecs.id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.this.id
  key_name = var.key_name
  security_groups = [aws_security_group.ecs_instance_sg.id]
  user_data = data.template_file.user_data.rendered
  root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
  }
}

resource "aws_autoscaling_group" "this" {
  name = "${var.name}-asg"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier = var.subnets
}

