# AWS EC2 Provisioning & Linux System Exploration

## Executive Summary
Provisioned a cloud-based Linux environment (Amazon Linux 2023) in the AWS `eu-west-2` (London) region. Executed core Linux System Administration commands to inspect system hardware, memory usage, disk partitioning, network interfaces, and file system hierarchy.

## Key Concepts & Skills Demonstrated
* **Cloud Operations:** AWS EC2 instance lifecycle (launching, SSH connectivity via RSA key pair, termination).
* **System Inspection:** Reviewing CPU architecture (`lscpu`), RAM allocation (`free -m`), and storage usage (`df -h`).
* **Networking & Identity:** Inspecting network interfaces and IP allocation (`ip a`).
* **File Operations & Navigation:** Directory navigation (`pwd`), hidden file viewing (`ls -la`), nested directory creation (`mkdir -p`), and file tracking (`ls -ltr`).

---

## Environment Specifications

| Attribute | Configuration Value |
| :--- | :--- |
| **Cloud Provider** | Amazon Web Services (AWS) |
| **AWS Region** | `eu-west-2` (London) |
| **Instance Name** | `my-first-server` |
| **Operating System** | Amazon Linux 2023 AMI |
| **Instance Type** | `t3.micro` (2 vCPU, 1 GiB RAM) |
| **Authentication** | SSH Key Pair (`my-key.pem`) |

---

## Step-by-Step Execution

### 1. Instance Provisioning & SSH Connection
1. Launched an EC2 instance in the London region with the designated parameters.
2. Generated and downloaded the private key `my-key.pem`.
3. Set appropriate file permissions on the private key to secure access:
   ```bash
   chmod 400 my-key.pem
