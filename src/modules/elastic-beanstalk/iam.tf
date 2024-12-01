resource "aws_iam_role" "eb_app" {
  name = format("%s-%s-eb-app", var.resource_prefix, var.environment)

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "elasticbeanstalk.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "eb_app" {
  name   = format("%s-%s-eb-app", var.resource_prefix, var.environment)
  policy = file(format("%s/resources/iam_policy.json", path.module))
}


resource "aws_iam_role" "eb_instance" {
  name = format("%s-%s-eb-instance", var.resource_prefix, var.environment)
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


resource "aws_iam_instance_profile" "eb_instance" {
  name = format("%s-%s-eb-instance", var.resource_prefix, var.environment)
  role = aws_iam_role.eb_instance.name
}

resource "aws_iam_policy" "eb_instance" {
  name   = format("%s-%s-eb-instance", var.resource_prefix, var.environment)
  policy = file(format("%s/resources/iam_policy.json", path.module))
}

resource "aws_iam_role_policy_attachment" "eb_instance" {
  role       = aws_iam_role.eb_instance.name
  policy_arn = aws_iam_policy.eb_instance.arn
}

resource "aws_iam_role_policy_attachment" "session_manager" {
  role       = aws_iam_role.eb_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
