resource "aws_security_group" "this" {
  name   = format("%s-%s-eb-sg", var.resource_prefix, var.environment)
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_p80_ingress" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
