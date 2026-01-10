# AWS HAProxy Ansible Automation

This repository contains **role-based Ansible automation** used to configure a production-style HAProxy load balancing stack on AWS EC2 instances.

The infrastructure itself is provisioned separately using Terraform. This repository focuses purely on **configuration management and service orchestration**.

---

## 🏗️ Architecture Overview

            ┌──────────────┐
            │   Internet   │
            └──────┬───────┘
                   │
            ┌──────▼───────┐
            │   lb-01      │
            │  (HAProxy)  │
            └──────┬───────┘
                   │
      ┌────────────┴────────────┐
      │                         │
            ┌──────────────┐
            │   Internet   │
            └──────┬───────┘
                   │
            ┌──────▼───────┐
            │   lb-01      │
            │  (HAProxy)  │
            └──────┬───────┘
                   │
      ┌────────────┴────────────┐
      │                         │

---

## 🚀 What This Repo Does

Using Ansible, this project automatically:

- Configures **Nginx** on web servers
- Configures **HAProxy** as a load balancer with:
  - Round-robin balancing
  - Health checks
  - Dynamic backend generation
- Deploys **Node Exporter** for monitoring
- Uses **private IPs for backend traffic**
- Ensures idempotent, repeatable deployments

---

## 📁 Repository Structure

aws-haproxy-ansible/
├── inventory/
│ └── inventory.ini
├── roles/
│ ├── web/
│ │ └── tasks/main.yml
│ ├── lb/
│ │ ├── tasks/main.yml
│ │ ├── handlers/main.yml
│ │ └── templates/haproxy.cfg.j2
│ └── monitor/
│ └── tasks/main.yml
└── site.yml


---

## ⚙️ Roles Breakdown

### 🔹 web
- Installs and starts Nginx
- Deploys a simple HTML page identifying the host
- Used to verify load balancing behavior

### 🔹 lb
- Installs HAProxy
- Generates backend configuration dynamically using inventory data
- Routes traffic to web servers via **private IPs**
- Restarts HAProxy automatically on config changes

### 🔹 monitor
- Installs and runs Node Exporter
- Provides host-level metrics for Prometheus

---

## ▶️ How to Run

### 1️⃣ Ensure inventory is updated
Edit `inventory/inventory.ini` with the correct IPs from Terraform outputs.

Example:
```ini
[web]
web-01 ansible_host=PUBLIC_IP private_ip=PRIVATE_IP
web-02 ansible_host=PUBLIC_IP private_ip=PRIVATE_IP



2️⃣ Run the full configuration
ansible-playbook -i inventory/inventory.ini site.yml

3️⃣ Validate
curl http://<LOAD_BALANCER_PUBLIC_IP>

🔍 Key Lessons & Design Decisions

Separation of concerns: Terraform handles infrastructure, Ansible handles configuration

Private backend routing: HAProxy communicates with web servers using VPC private IPs

Idempotency: Playbooks can be re-run safely without unintended changes

Role-based structure: Clean, scalable automation design

🧪 Tested On

Ubuntu Server 22.04 LTS

AWS EC2 (t3.micro)

Ansible 2.14+

📌 Related Repositories

Infrastructure (Terraform): aws-haproxy-terraform

Monitoring: Prometheus + Grafana deployed separately


