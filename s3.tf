resource "aws_s3_bucket" "ktkt07" {
  bucket = "ktkt07"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

}
