# Lab 05: Packer + Terraform three-node deployment

Rebuilt the Week 4 two-tier app (Nginx frontend, Python API, Java API) as
infrastructure as code: **Packer** builds the machine images and **Terraform**
launches the servers from them.

**Code:** https://github.com/jidavy/fruits-veg-iac
**Application:** https://github.com/jidavy/fruits-veg_market

## Architecture

Browser -> Nginx frontend (port 80)
Browser -> Python FastAPI backend (port 8080, /fruits)
Browser -> Java Spring Boot backend (port 9090, /vegetables)

## What I built

| Tool | What it did |
|---|---|
| Packer | Built 2 AMIs from Amazon Linux 2023: `fruits-nginx` (Nginx + web files) and `fruits-backend` (Java 17, Maven, Python 3, app code, pre-built jar and virtualenv) |
| Terraform | Looked up the newest AMIs by name, created 2 security groups and 3 EC2 instances in the default VPC |
| user_data | Boot scripts: systemd services start the Python and Java apps; the frontend script swaps the backend IPs into the page |

## Design decisions

- **Two AMIs for three servers:** the backend image holds both runtimes; the
  Python and Java nodes run the same image and differ only in their boot script.
- **Baked vs boot-time:** installs and builds happen once in the image (fast
  boots); anything that depends on runtime values (backend IPs) is applied at boot.
- **AMI lookup by name** instead of hard-coded IDs, so rebuilt images are picked up.
- **Secrets kept out of Git:** `.terraform/`, state files, `*.tfvars` and keys are ignored.

## Screenshots

(add each image with a short caption)

## What I learned / problems solved

(write a few lines in your own words, e.g. Packer builds are slow so parallel
builds help; why the frontend needed a boot-time sed; the 404 on / was normal)

## Clean-up

Ran `terraform destroy` after testing to avoid charges.
