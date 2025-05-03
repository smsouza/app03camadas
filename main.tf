# main.tf

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "three-tier-vpc"
  cidr = var.vpc_cidr_block

  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  tags = {
    Project = "Three-Tier"
  }
}

resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  name   = "app-alb"

  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  target_groups = [
    {
      name_prefix      = "app"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
      default_action = {
        type             = "forward"
        target_group_index = 0
      }
    }
  ]

  tags = {
    Environment = "dev"
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "app-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = filebase64("./user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  desired_capacity     = var.autoscaling_desired_capacity
  max_size             = var.autoscaling_max_size
  min_size             = var.autoscaling_min_size

  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [module.alb.target_group_arns[0]]

  tag {
    key                 = "Name"
    value               = "AppInstance"
    propagate_at_launch = true
  }
}

resource "aws_db_instance" "default" {
  identifier         = "rds-instance"
  engine             = "mysql"
  instance_class     = var.rds_instance_class
  allocated_storage  = var.rds_allocated_storage
  name               = var.rds_db_name
  username           = var.rds_username
  password           = var.rds_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "default" {
  name       = "main-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "Main DB subnet group"
  }
}

resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow MySQL access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}
