
resource "aws_iam_role" "connect-ec2-s3" {
  name = "connect-ec2-s3-role"

  # Trust Policy : who is allowed to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}



# Scoped IAM policy granting access only to a specific S3 bucket
resource "aws_iam_policy" "s3_specific" {
  name        = "connect-ec2-s3-specific-bucket"
  description = "Allow EC2 role to access a specific S3 bucket only"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}"
      },
      {
        Sid    = "AllowObjectActions"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      }
    ]
  })
}

# Attach the scoped policy to the role
resource "aws_iam_role_policy_attachment" "ec2_s3_specific" {
  role       = aws_iam_role.connect-ec2-s3.name
  policy_arn = aws_iam_policy.s3_specific.arn
}

# EC2 cannot attach roles directly, it uses instance profiles
resource "aws_iam_instance_profile" "connect-ec2-s3-profile" {
  name = "connect-ec2-s3-instance-profile"
  role = aws_iam_role.connect-ec2-s3.name
}


# Created an iam role then iam policy then attached the policy to the role
# Finally created an instance profile to link the role to EC2


