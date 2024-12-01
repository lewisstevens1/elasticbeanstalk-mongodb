resource "aws_route53_record" "dev-ns" {
  zone_id = var.r53_zone_id
  name    = "rds"
  type    = "A"
  ttl     = "30"
  records = [
    aws_instance.db.private_ip
  ]
}
