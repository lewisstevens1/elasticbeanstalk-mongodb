resource "aws_s3_bucket" "application" {
  bucket = format("%s%s", var.s3_bucket_prefix, random_string.random_id.result)
}

resource "aws_s3_object" "application" {
  bucket = aws_s3_bucket.application.id
  key    = format("app-%s.zip", data.archive_file.application.output_sha256)

  source = data.archive_file.application.output_path
}
