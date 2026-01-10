AWS HAProxy Terraform + Ansible Automation

This project demonstrates a production-style AWS infrastructure and configuration workflow using Terraform for infrastructure provisioning and Ansible for configuration management.

Terraform is responsible for creating all AWS resources (VPC, subnets, security groups, EC2 instances), while Ansible configures HAProxy, Nginx, and monitoring services on top of that infrastructure.

🏗️ Architecture Overview
                Internet
                    |
            ┌───────▼────────┐
            │     lb-01       │
            │    HAProxy      │
            │  (Public IP)    │
            └───────┬────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────▼────────┐     ┌────────▼───────┐
│    web-01       │     │     web-02     │
│   Nginx         │     │    Nginx       │
│ (Private IP)    │     │ (Private IP)   │
└─────────────────┘     └────────────────┘

                    ┌───────────────────┐
                    │     mon-01        │
                    │ Prometheus /      │
                    │ Grafana /         │
                    │ Node Exporter     │
                    └───────────────────┘

🚀 What This Project Does
Terraform — Infrastructure Provisioning

Terraform provisions the complete AWS environment, including:

Custom VPC and public subnet

Internet Gateway and routing

Security groups with least-privilege access

EC2 instances:

lb-01 — HAProxy load balancer

web-01, web-02 — Nginx backend servers

mon-01 — Monitoring host

Terraform outputs provide public and private IPs for Ansible automation

Ansible — Configuration Management

Ansible configures services on the provisioned EC2 instances:

Installs and configures Nginx on backend servers

Installs and configures HAProxy with:

Round-robin load balancing

Health checks

Dynamic backend generation from inventory

Private-IP backend routing

Installs and runs Node Exporter for monitoring

Uses role-based, idempotent playbooks

📁 Repository Structure
aws-haproxy-terraform-ansible/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── terraform.tfvars
│
├── ansible/
│   ├── inventory/
│   │   └── inventory.ini
│   ├── roles/
│   │   ├── web/
│   │   ├── lb/
│   │   └── monitor/
│   └── site.yml
└── README.md

⚙️ Ansible Roles Breakdown
🔹 web

Installs and starts Nginx

Deploys a simple HTML page identifying the host

Used to validate load-balancing behavior

🔹 lb

Installs HAProxy

Dynamically generates backend configuration using inventory data

Routes traffic to backend servers via VPC private IPs

Automatically reloads HAProxy on configuration changes

🔹 monitor

Installs and runs Node Exporter

Exposes host-level metrics for Prometheus

▶️ How to Run
1️⃣ Provision infrastructure with Terraform
cd terraform
terraform init
terraform apply


Record the public and private IPs from Terraform outputs.

2️⃣ Update Ansible inventory

Edit ansible/inventory/inventory.ini using Terraform outputs:

[web]
web-01 ansible_host=PUBLIC_IP private_ip=PRIVATE_IP
web-02 ansible_host=PUBLIC_IP private_ip=PRIVATE_IP

3️⃣ Run Ansible configuration
cd ansible
ansible-playbook -i inventory/inventory.ini site.yml

4️⃣ Validate
curl http://<LOAD_BALANCER_PUBLIC_IP>


Traffic should alternate between backend servers.

🔍 Key Design Decisions

Separation of concerns — Terraform provisions infrastructure, Ansible configures services

Private backend routing — HAProxy communicates with backends using private IPs

Security-first design — tightly scoped security group rules between tiers

Idempotent automation — playbooks can be safely re-run

Role-based structure — scalable, maintainable automation

🧪 Tested On

Ubuntu Server 22.04 LTS

AWS EC2 (t3.micro)

Terraform 1.5+

Ansible 2.14+
