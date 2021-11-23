# AWS EC2 Application Load Balancer (Host Header Based Routing) using Terraform

![image](https://drive.google.com/uc?export=view&id=1qdiZoGLrL-hWjb1yxFJTHMOFiXEmzkmV)

## Pre-requisite

- You need a Registered Domain in AWS Route53 to implement this usecase
- Create `private-key` folder
- Copy your AWS EC2 Key pair `terraform-key.pem` in `private-key` folder

## Populating Variables

The values for these variables should be placed into terraform.tfvars. Simply copy terraform.tfvars.example to terraform.tfvars and edit it with the proper values.

## Execute Terraform Commands

terraform init

terraform validate

terraform plan

terraform apply

## Verify via AWS Management Console

Observation:

1. Verify EC2 Instances created
2. Verify VPC
3. Verify Subnets
4. Verify IGW
5. Verify Public Route for Public Subnets
6. Verify no public route for private subnets
7. Verify NAT Gateway and Elastic IP for NAT Gateway
8. Verify NAT Gateway route for Private Subnets
9. Verify no public route or no NAT Gateway route to Database Subnets
10. Verify Subnets Security Group
11. Verify Load Balancer Security Group (80 and SSL 443 Rule)
12. Verify ALB Listener - HTTP:80 - Should contain a redirect from HTTP to HTTPS
13. Verify ALB Listener - HTTPS:443 - Should contain 3 rules

```t
13.1 Host Header app1.domain.com to app1-tg 
13.2 Host Header app2.domain.com toto app2-tg 
13.3 Fixed Response: any other errors or any other IP or valid DNS to this LB
```

14. Verify ALB Target Groups App1 and App2, Targets (should be healthy)
15. Verify SSL Certificate (Certificate Manager)
16. Verify Route53 DNS Record
17. Verify Tags

## Connect to Bastion EC2 Instance and Test

```t
# Connect to Bastion EC2 Instance from local desktop
ssh -i private-key/terraform-key.pem ec2-user@<PUBLIC_IP_FOR_BASTION_HOST>

# Curl Test for Bastion EC2 Instance to Private EC2 Instances
curl  http://<Private-Instance-App1-Private-IP>
curl  http://<Private-Instance-App2-Private-IP>

# Connect to Private EC2 Instances App 1 from Bastion EC2 Instance
ssh -i /tmp/terraform-key.pem ec2-user@<Private-Instance-App1-Private-IP>
cd /var/www/html
ls -lrta
Observation: 
1) Should find index.html
2) Should find app1 folder
3) Should find app1/index.html file
4) Should find app1/metadata.html file

# Connect to Private EC2 Instances App 2 from Bastion EC2 Instance
ssh -i /tmp/terraform-key.pem ec2-user@<Private-Instance-App2-Private-IP>
cd /var/www/html
ls -lrta
Observation: 
1) Should find index.html
2) Should find app2 folder
3) Should find app2/index.html file
4) Should find app2/metadata.html file
```

## Web Browser Test

```t
# App1
1. http://app1.domain.com -> index.html
2. http://app1.domain.com/app1/index.html -> /app1/index.html
3. http://app1.domain.com/app1/metadata.html -> /app1/metadata.html
4. Failure Case: Access App2 Directory from App1 DNS: http://app1.domain.com/app2/index.html - Should return Directory not found 404

# App2
1. http://app2.domain.com -> index.html
2. http://app1.domain.com/app2/index.html -> /app2/index.html
3. http://app1.domain.com/app2/metadata.html -> /app2/metadata.html
4. Failure Case: Access App2 Directory from App1 DNS: http://app2.domain.com/app1/index.html - Should return Directory not found 404
```

## Terraform Destroy

terraform destroy

## Clean-Up

rm -rf .terraform*

rm -rf terraform.tfstate*
