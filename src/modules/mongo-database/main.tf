resource "aws_instance" "db" {
  ami                  = data.aws_ami.elastic_beanstalk.id
  instance_type        = "t3.micro"
  user_data_base64     = filebase64(format("%s/resources/userdata.sh", path.module))
  iam_instance_profile = aws_iam_instance_profile.eb_db.name

  network_interface {
    network_interface_id = aws_network_interface.db.id
    device_index         = 0
  }

  tags = {
    Name = format("%s-%s-mongodb", var.resource_prefix, var.environment)
  }
}

resource "aws_network_interface" "db" {
  subnet_id = keys(var.private_subnets)[0]

  security_groups = [
    aws_security_group.this.id
  ]

  private_ips = [
    cidrhost(values(var.private_subnets)[0], 10)
  ]
}
