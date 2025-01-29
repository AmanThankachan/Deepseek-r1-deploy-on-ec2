provider "aws" {
  region = "us-east-1" # Change as needed
}

resource "aws_iam_role" "deepseek_role" {
  name = "deepseek-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.deepseek_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "deepseek_profile" {
  name = "deepseek-instance-profile"
  role = aws_iam_role.deepseek_role.name
}

resource "aws_security_group" "deepseek_sg" {
  name        = "deepseek-sg"
  description = "Allow inbound access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 11434
    to_port     = 11434
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "deepseek" {
  ami           = "ami-0b0ea68c435eb488d" # Amazon Linux 2 GPU-supported AMI
  instance_type = "g4dn.xlarge"
  key_name      = "your-key-pair" # Replace with your SSH key name
  iam_instance_profile = aws_iam_instance_profile.deepseek_profile.name
  vpc_security_group_ids = [aws_security_group.deepseek_sg.id]

  root_block_device {
    volume_size = 100
  }

  user_data = <<EOF
#!/bin/bash
set -e
# Install dependencies
yum update -y
yum install -y docker
service docker start
usermod -aG docker ec2-user

# Install NVIDIA drivers
amazon-linux-extras enable docker
yum install -y nvidia-driver-latest-dkms
nvidia-smi

# Install Ollama and DeepSeek model
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull deepseek-r1-distill-qwen-14b

# Run Ollama server
nohup ollama serve &

# Deploy Ollama Web UI
docker run -d --name ollama-ui -p 3000:3000 --network host ghcr.io/ollama-webui/ollama-webui:latest
EOF

  tags = {
    Name = "DeepSeek-EC2"
  }
}

resource "aws_eip" "deepseek_eip" {
  instance = aws_instance.deepseek.id
}
