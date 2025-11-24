
# Graded-Assignment-on-Deploying-a-MERN-Application-on-AWS
Graded Assignment on Deploying a MERN Application on AWS


# Travel Memory

`.env` file to work with the backend:

```
MONGO_URI='ENTER_YOUR_URL'
PORT=3000
```

Data format to be added: 

```json
{
    "tripName": "Incredible India",
    "startDateOfJourney": "19-03-2022",
    "endDateOfJourney": "27-03-2022",
    "nameOfHotels":"Hotel Namaste, Backpackers Club",
    "placesVisited":"Delhi, Kolkata, Chennai, Mumbai",
    "totalCost": 800000,
    "tripType": "leisure",
    "experience": "Lorem Ipsum, Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum,Lorem Ipsum, ",
    "image": "https://t3.ftcdn.net/jpg/03/04/85/26/360_F_304852693_nSOn9KvUgafgvZ6wM0CNaULYUa7xXBkA.jpg",
    "shortDescription":"India is a wonderful country with rich culture and good people.",
    "featured": true
}
```

## Part 1: Infrastructure Setup with Terraform

Step 1: AWS CLI Setup
What: Install and configure AWS CLI for programmatic access to AWS.

Why: Terraform and Ansible both need credentials to provision and configure resources.

How:

Download and install AWS CLI for Windows or Ubuntu (WSL).

Windows: Direct installer

Ubuntu:

bash
sudo apt update
sudo apt install awscli
Run

bash
aws configure
Enter Access Key, Secret Key, default region (e.g., ap-south-1), and output format (json).

Install because: CLI is required for Terraform and Ansible authentication.

Step 2: Terraform Installation and Initialization
What: Install Terraform and set up a new project.

Why: Terraform automates AWS resource creation (VPCs, subnets, EC2, gateways).

How:

Download Terraform

Ubuntu (WSL):

bash
sudo apt-get update && sudo apt-get install -y wget unzip
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -version
Create a new folder (e.g., mern-infra) and run:

bash
terraform init
Install because: Terraform is required for resource provisioning.

Step 3: VPC and Network Configuration
What: Define resources in your Terraform scripts for:

VPC

Public & private subnets

Internet Gateway and NAT Gateway

Route tables for proper traffic flow

Why: This sets up isolated and secure networking, mirroring common AWS best practices (public access only for web, DB is in private subnet).

VPC: Isolates your resources.

Subnets: Public for web server, private for DB.

Internet Gateway: Allows internet access to public subnet.

NAT Gateway: Lets private subnet reach internet (e.g., for OS updates) but blocks inbound traffic.

Route Tables: Define how traffic is routed between subnets and externally.

Write Terraform code in main.tf—use docs and references for syntax.

Step 4: EC2 Instance Provisioning
What: Provision two EC2 instances.

Public subnet: For the MERN web server.

Private subnet: For MongoDB database.

Why: Separating app and database improves security and scalability.

Ensure only public instance’s SSH is open, restricted to your IP

Private instance only accessible within VPC

Terraform code will specify AMI (e.g., Ubuntu), instance types, subnet placement, and key pairs.

Step 5: Security Groups and IAM Roles
What: Create and attach:

Security groups: Control traffic for web and database servers.

IAM roles: Provide necessary permissions to EC2 instances (e.g., S3 bucket access, if needed).

Why: Security groups enforce network policies; IAM roles allow secure resource access.

Terraform resource examples:

Security groups permitting 22 (SSH, limited), 80/443 (HTTP/S), 27017 (Mongo, internal only)

IAM role/resource for EC2 (attach policies as needed)

Step 6: Resource Output
What: Output the public IP of the web server EC2 instance at end of Terraform script.

Why: You’ll need this to SSH/configure and for accessing the deployed app.

Terraform Output Example:

text
output "web_public_ip" {
  value = aws_instance.web_server.public_ip
}

## Part 2: Configuration and Deployment with Ansible

Step 1: Install Ansible
What: Install Ansible on your local dev environment (Ubuntu/WSL recommended).

Why: Ansible automates provisioning and deployment/configuration for app and database servers.

How:

Ubuntu (WSL):

bash
sudo apt update
sudo apt install ansible
ansible --version
Install because: Ansible will SSH into EC2s and configure them.

Step 2: Configure Ansible Hosts
What: Set up an inventory file listing your EC2 IPs.

Why: Tells Ansible which machines to manage.

How:

Get EC2 public/private IPs (from Terraform output/AWS console)

Create hosts.ini:

text
[web]
x.x.x.x   # public IP

[db]
y.y.y.y   # private IP (reachable from web server)

Step 3: Web Server Setup (Ansible Playbook)
What: Write playbook to:

Install Node.js and NPM

Clone MERN app repo

Install dependencies

Why: Prepares the server to run your application.

Playbook sample:

text
- hosts: web
  tasks:
    - name: Install nodejs/npm
      apt:
        name: "nodejs, npm"
        state: present
    - name: Clone repo
      git:
        repo: https://github.com/UnpredictablePrashant/TravelMemory.git
        dest: /home/ubuntu/travelmemory
    - name: Install dependencies
      shell: cd /home/ubuntu/travelmemory && npm install

Step 4: Database Server Setup (Ansible Playbook)
What: Install and setup MongoDB, secure (create users, disable remote root, configure firewall).

Why: Required for app database, security hardening protects sensitive data.

Playbook sample:

Install MongoDB (official repo instructions)

Create MongoDB user with password

Limit access to internal subnet only

Step 5: Application Deployment and Configuration
What: Set environment variables (DB URI, config keys), start backend (Express/Node), frontend (React).

Why: Ensures app runs with proper config and services interact correctly.

Configure using .env files (or Ansible vars), start with PM2/systemd for reliability.

Step 6: Security Hardening
What: Make sure firewalls/security groups allow only intended traffic; use SSH key pairs and hardened configurations.

Why: Minimizes attack surface and enforces best practices.

###### Thank you!!!
--------------------------------------------------------------------

![alt text](<ansible-playbook run-1.png>)

![alt text](<backend api test - trip playbook.png>)

![alt text](<frontend deployed success.png>)

![alt text](<terraform init.png>)

![alt text](<terraform validate.png>)