resource "aws_autoscaling_group" "asg" {
  name                      = "${var.candidate}-frontend"
  vpc_zone_identifier       = aws_subnet.private[*].id
  max_size                  = var.number_of_azs
  min_size                  = 1
  desired_capacity          = var.number_of_azs
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.this.name]
  force_delete              = true

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.candidate
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "frontend" {
  name          = "${var.candidate}-frontend"
  image_id      = var.AMIS[var.AWS_REGION]
  instance_type = "t3.nano"

  user_data = filebase64("${path.module}/scripts/bootstrap.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.node.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [
      "${aws_security_group.node.id}"
    ]
  }

  tag_specifications {
    resource_type = "volume"

    tags = local.preparedTags
  }

  tag_specifications {
    resource_type = "instance"

    tags = local.preparedTags
  }

  tags = local.preparedTags
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.candidate}_instance_profile"
  role = aws_iam_role.node.name

  tags = merge(local.preparedTags, {
    Role = "iam"
  })
}

resource "aws_iam_role" "node" {
  name = "${var.candidate}_node"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = merge(local.preparedTags, {
    Role = "iam"
  })
}

resource "aws_iam_role_policy_attachment" "node" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_security_group" "node" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.candidate}-node"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.preparedTags, {
    Role = "security-group-node"
  })
}
