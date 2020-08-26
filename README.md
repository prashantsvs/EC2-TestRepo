# EC2-TestRepo

terraform-test

This code snippet is an IaC solution to provision a free tier EC2 Amazon Linux instance.

The instance will be running Apache server, and the default web site should serve up a page saying “Hello from AAA.BBB.CCC.DDD”, where AAA.BBB.CCC.DDD is the public IP address of the instance. The instance should include a tag, and a security group restricting traffic to port 80 and 22. SSH access should be possible via key-based authentication, but not by password.

The required modules will be loaded once we run the terraform init. We will get to know provisioning action plan once we run terraform plan
