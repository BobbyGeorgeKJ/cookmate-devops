resource "aws_key_pair" "cookmate_key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/cookmate_aws_key.pub")
}

resource "aws_instance" "cookmate_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.cookmate_key.key_name
  vpc_security_group_ids = [aws_security_group.cookmate_sg.id]

  tags = {
    Name = "CookMate-Instance"
  }
}

resource "aws_s3_bucket" "cookmate_bucket" {
  bucket = "cookmate-${random_id.bucket_id.hex}"
  tags = {
    Name = "CookMateBucket"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical (official Ubuntu images)
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
