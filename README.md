# Terraform AWS Sample Project

This repository contains a small Terraform configuration that provisions a VPC, subnets, route tables, an EC2 instance, an S3 bucket, and the IAM role/policy required for the instance to access a specific S3 bucket.

## Architecture

- VPC: single VPC (`aws_vpc.my-vpc`) with one public and one private subnet.
- Networking: Internet Gateway and public route table for outbound access.
- Compute: `aws_instance.my-ec2` in the public subnet using an instance profile `aws_iam_instance_profile.connect-ec2-s3-profile`.
- Storage: `aws_s3_bucket.my-bucket` used for application data; IAM policy scoped to a single bucket.
- IAM: `aws_iam_role.connect-ec2-s3` + `aws_iam_policy.s3_specific` granting least-privilege S3 access.

Simple flow: EC2 assumes the IAM role via its instance profile → role has a scoped policy allowing List/Get/Put/Delete only on the configured bucket.

## What I learned

- Prefer least-privilege IAM policies over AWS managed full-access policies; scope by bucket and object prefix when possible.
- Keep tags consistent across resources (use a `common_tags` map and `merge()` to enforce naming conventions).
- Use variables to make the configuration reusable (`s3_bucket_name`, `common_tags`).
- Validate changes locally with `terraform plan` before apply to avoid surprise costs.

## Backend explanation

This configuration currently relies on a local state file (`terraform.tfstate`) found in the repository root. For collaboration and safer state management, configure a remote backend such as S3 with DynamoDB locking. Example backend block:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```

If you switch to a remote backend, follow Terraform's instructions to migrate state (`terraform init -backend-config=...`).

## Cost safety

- Run `terraform plan` to review changes before `apply`.
- Use small instance types (the example uses `t2.micro`) and minimal EBS sizes; avoid creating large or many instances/volumes by default.
- Add budgets/alarms in AWS (AWS Budgets) and tag resources for cost allocation.
- Use `prevent_destroy` lifecycle only on truly critical resources to avoid accidental deletion, and pair it with documented runbooks.
- When experimenting, prefer workspaces or a sandbox account and destroy resources after testing: `terraform destroy`.

---

If you want, I can:

- Convert tags to a single `var.common_tags` default and reapply it across the codebase.
- Add an example `backend` configuration and a short migration guide in the README.
- Run `terraform plan` here (requires AWS credentials) or show the exact commands to run locally.

Files of interest: [iam.tf](iam.tf), [s3.tf](s3.tf), [compute.tf](compute.tf), [network.tf](network.tf), [variables.tf](variables.tf)
