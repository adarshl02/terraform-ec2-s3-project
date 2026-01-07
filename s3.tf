
resource "aws_s3_bucket" "my-bucket" {
  bucket = "terraform-bucket-10604"
  region = "us-east-1"

  tags = {
    Name = "terraform-s3-bucket"
  }
}