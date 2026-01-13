# AWS HAProxy Terraform + Ansible Automation

![Ansible Lint](https://github.com/danheck12/aws-haproxy-terraform-ansible/actions/workflows/ansible-lint.yml/badge.svg)
![Last Commit](https://img.shields.io/github/last-commit/danheck12/aws-haproxy-terraform-ansible)
![Repo Size](https://img.shields.io/github/repo-size/danheck12/aws-haproxy-terraform-ansible)
![Stars](https://img.shields.io/github/stars/danheck12/aws-haproxy-terraform-ansible?style=social)

Production-style AWS lab demonstrating **Terraform for infrastructure provisioning** and **Ansible for configuration management** to build a simple load-balanced web tier:

- **lb-01**: HAProxy (public entrypoint)
- **web-01 / web-02**: Nginx backends (private network)
- **mon-01**: Monitoring node (Node Exporter; extendable to Prometheus/Grafana)

---

## Table of Contents
- [Architecture](#architecture)
- [What This Project Does](#what-this-project-does)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Validate](#validate)
- [Design Decisions](#design-decisions)
- [Tested On](#tested-on)

---

## Architecture

Internet
|
v
+-------------------+
| lb-01 (Public IP) |
| HAProxy |
+---------+---------+
|
| (VPC private routing)
|
+------+------+
| |
v v
+--------+ +--------+
| web-01 | | web-02 |
| Nginx | | Nginx |
| Private| | Private|
+--------+ +--------+

(Optional/Extend)
+----------------------+
| mon-01 |
| Node Exporter |
| (Prom/Grafana later) |
+----------------------+

yaml
Copy code

---

## What This Project Does

### Terraform — Infrastructure Provisioning
Terraform creates the AWS environment including:
- VPC, subnet(s), routing/IGW
- Security groups scoped by tier (LB ↔ web, admin access)
- EC2 instances: `lb-01`, `web-01`, `web-02`, `mon-01`
- Outputs with public/private IPs to drive Ansible inventory

### Ansible — Configuration Management
Ansible configures services on provisioned instances:
- Nginx on backend servers (plus a host-identifying page)
- HAProxy on the load balancer:
  - round-robin balancing
  - health checks
  - backend generation from inventory
  - routing via backend **private IPs**
- Node Exporter on monitoring node

---

## Repository Structure

aws-haproxy-terraform-ansible/
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── versions.tf
│ └── terraform.tfvars
├── ansible/
│ ├── inventory/
│ │ └── inventory.ini
│ ├── roles/
│ │ ├── web/
│ │ ├── lb/
│ │ └── monitor/
│ └── site.yml
└── README.md

yaml
Copy code

---

## Getting Started

### Prerequisites
- AWS CLI configured (`aws sts get-caller-identity` works)
- Terraform 1.5+
- Ansible 2.14+
- SSH keypair available and allowed by your security group
- Ubuntu 22.04+ recommended (matches the lab assumptions)

### 1) Provision infrastructure with Terraform
From repo root:

```bash
cd terraform
terraform init
terraform apply
Capture Terraform outputs (public/private IPs) for inventory.

2) Update Ansible inventory
Edit:

ansible/inventory/inventory.ini

Example pattern:

ini
Copy code
[lb]
lb-01 ansible_host=<LB_PUBLIC_IP>

[web]
web-01 ansible_host=<WEB1_PUBLIC_IP> private_ip=<WEB1_PRIVATE_IP>
web-02 ansible_host=<WEB2_PUBLIC_IP> private_ip=<WEB2_PRIVATE_IP>

[monitor]
mon-01 ansible_host=<MON_PUBLIC_IP>
3) Run Ansible configuration
bash
Copy code
cd ../ansible
ansible-playbook -i inventory/inventory.ini site.yml
Validate
1) Confirm load balancing
From your machine:

bash
Copy code
curl http://<LB_PUBLIC_IP>
Refresh a few times — the response/content should alternate between backend servers.

2) Confirm HAProxy health checks (optional)
SSH to the LB and inspect HAProxy status / logs depending on your configuration.

Design Decisions
Separation of concerns: Terraform provisions; Ansible configures

Private backend routing: HAProxy talks to backends via private IPs

Security-first: tiered SG rules rather than flat allow-all

Idempotent automation: roles are safe to re-run

Role-based structure: scalable and maintainable

Tested On
Ubuntu Server 22.04 LTS

AWS EC2 (t3.micro)

Terraform 1.5+

Ansible 2.14+


