data "aws_vpc" "default" { 
	default = true
}

data "aws_ami_id" "linuxId" {
	owners = "amazon"
	most_recent = true
	filter {
		name = "name"
		values = ["amazon/images/amazon*linux*"]
	}
}

resource "aws_subnet" "test_subnet" { 
	vpc_id   = data.aws_vpc.default.id
	cidr_block = "172.31.0.0/20"
	availability_zone = "us-east-1a"
}

resource "aws_network_interface" "test_ni"{
	subnet_id = "aws_subnet.test_subnet.id"
}

resource "aws_instance" "TestLinuxInstance" {
  ami = data.aws_ami.linuxId.id
  instance_type = "t2.micro"
  security_groups = [module.security_group.this_security_group_id]
  key_name = "prashant-key"
       
  tags {
        Name = "EC2_Instance_Terraform"
       }
  network_interface {
		network_interface_id = aws_network_interface.test_ni.id
		device_index = 0
		}

  user_data     = <<-EOF
                    #!/bin/bash
                    sudo su
                    yum -y install httpd
					 echo "<p> Hello from `ifconfig | grep "inet " |grep 0.0.0.0|awk '{print $2}'` </p>" >> /var/www/html/index.html
                    sudo systemctl enable httpd
                    sudo systemctl start httpd
                  EOF
}

resource "tls_private_key" "prashant" {
	algorithm = RSA
}

module "key_pair" {
	source = "terraform-aws-modules/key-pair/aws"
	key_name = "prashant-key"
	public_key = tls_private_key.prashant.public_key_openssh
}

module "security_group" {
    source = "terraform-aws-modules/security-group/aws"
	version = "~> 3.0"
    name        = "user-service"
    description = "Security group for user-service with custom ports open within VPC"
    vpc_id      = data.aws_vpc.default.id
    ingress_cidr_blocks      = ["0.0.0.0/0"]
    ingress_rules            = ["http-80-tcp" , "ssh-tcp"]
}

resource "github_repository" "prashant-repo" {
  name        = "prashant-repo"
  description = "My new repository for use with Terraform"
}
