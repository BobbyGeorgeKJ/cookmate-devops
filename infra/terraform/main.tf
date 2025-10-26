##########################################
# Provider
##########################################
provider "aws" {
  region = var.region
}

##########################################
# Random ID (for unique naming)
##########################################
resource "random_id" "sg_id" {
  byte_length = 2
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

##########################################
# Security Group (allows SSH + HTTP)
##########################################
resource "aws_security_group" "cookmate_sg" {
  name        = "cookmate-sg-${random_id.sg_id.hex}"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CookMate-SG"
  }
}

##########################################
# Get Ubuntu AMI
##########################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

##########################################
# EC2 Instance (with Docker + Nginx)
##########################################
resource "aws_instance" "cookmate_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.cookmate_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -xe

    # Update packages
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg lsb-release git

    # Install Docker
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    usermod -aG docker ubuntu

    # Install Nginx
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx

    # Configure Nginx as reverse proxy
    cat > /etc/nginx/sites-available/default <<'NGINXCONF'
    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }

        location /api/ {
            proxy_pass http://localhost:5000/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }
    NGINXCONF

    systemctl restart nginx

    # Clone your app and run it
    cd /home/ubuntu
    git clone --branch ${var.repo_branch} ${var.repo_url} ${var.app_directory}
    chown -R ubuntu:ubuntu ${var.app_directory}
    cd /home/ubuntu/${var.app_directory}
    /usr/bin/docker compose up -d --build || docker compose up -d --build || true

    echo "bootstrap-complete" > /home/ubuntu/bootstrap_status
  EOF

  tags = {
    Name = "CookMate-Instance"
  }
}

##########################################
# S3 Bucket
##########################################
resource "aws_s3_bucket" "cookmate_bucket" {
  bucket = "cookmate-${random_id.bucket_id.hex}"

  tags = {
    Name = "CookMateBucket"
  }
}

##########################################
# Outputs
##########################################
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.cookmate_ec2.public_ip
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.cookmate_bucket.bucket
}
