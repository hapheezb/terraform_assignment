/*resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "tf-bucket44" 
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "my_terraform_ass_bucket"
    Environment = "Dev"
  }
}
*/

resource "aws_dynamodb_table" "tf_lock" {
  name = "terraform_lock"
  hash_key = "LockID"
  read_capacity = 3
  write_capacity = 3
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform_lock_table"
  }

  lifecycle {
    prevent_destroy = false
  }
}
