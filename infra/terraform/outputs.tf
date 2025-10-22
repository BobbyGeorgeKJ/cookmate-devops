output "instance_id" {
  value = aws_instance.cookmate_ec2.id
}

output "public_ip" {
  value = aws_instance.cookmate_ec2.public_ip
}

output "bucket_name" {
  value = aws_s3_bucket.cookmate_bucket.bucket
}
