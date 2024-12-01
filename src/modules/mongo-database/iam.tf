resource "aws_iam_role" "eb_db" {
  name = format("%s-%s-eb-db", var.resource_prefix, var.environment)
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_instance_profile" "eb_db" {
  name = format("%s-%s-eb-db", var.resource_prefix, var.environment)
  role = aws_iam_role.eb_db.name
}

resource "aws_iam_role_policy_attachment" "session_manager" {
  role       = aws_iam_role.eb_db.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
