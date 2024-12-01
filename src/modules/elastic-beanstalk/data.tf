data "aws_ami" "elastic_beanstalk" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["aws-elasticbeanstalk-amzn-2023*nodejs22*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "archive_file" "application" {
  type        = "zip"
  source_dir  = format("%s/resources/application", path.module)
  output_path = format("%s/resources/application.zip", path.module)
}

resource "random_string" "random_id" {
  length  = 6
  special = false
  upper   = false
}
