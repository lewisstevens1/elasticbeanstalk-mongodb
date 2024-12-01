resource "aws_elastic_beanstalk_application" "this" {
  name = format("%s-%s-eb-app", var.resource_prefix, var.environment)
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = format("%s-%s-%s", var.resource_prefix, var.environment, data.archive_file.application.output_sha256)
  application = aws_elastic_beanstalk_application.this.name

  bucket = aws_s3_bucket.application.id
  key    = aws_s3_object.application.key
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = format("%s-%s-%s", var.resource_prefix, var.environment, random_string.random_id.result)
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.4.0 running Node.js 22"
  version_label       = aws_elastic_beanstalk_application_version.default.name

  # aws:elasticbeanstalk
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
    resource  = ""
  }

  # aws:autoscaling
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance.name
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "gp3"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = true
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.this.id
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance.arn
    resource  = ""
  }

  # aws:ec2
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", keys(var.public_subnets))
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = true
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "EnableSpot"
    value     = true
    resource  = ""
  }


  # aws:rds
  setting {
    namespace = "aws:rds:dbinstance"
    name      = "HasCoupledDatabase"
    value     = false
    resource  = ""
  }

  # aws:elb
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.this.id
    resource  = ""
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = aws_security_group.this.id
    resource  = ""
  }

}
