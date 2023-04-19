resource "aws_s3_bucket" "dev-s33buks" {
  bucket = "my-tfdevs3-test-bucket"

  tags = {
    Name        = "dev-s33buks"
    Environment = "Dev"
  }
}

#static web site hosting
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.dev-s33buks.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
#acl=public
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.dev-s33buks.id
  acl    = "public-read"
}

#versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.dev-s33buks.id
  versioning_configuration {
    status = "Enabled"
  }
}

terraform {
  backend "s3" {
    bucket = "my-tfdevs3-test-bucket"
    key    = "app/tharun/terraform.tfstate"
    region = "ap-south-1"
  }
}

