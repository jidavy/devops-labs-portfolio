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

## What I learned / problems solved

- **Packer and Terraform do different jobs.** Packer builds the image (the
  frozen disk); Terraform creates the running servers from it. I built two
  AMIs and launched three servers from them: the Python and Java nodes use
  the same backend image.
- **Bake slow things in, configure fast things at boot.** Installing Java,
  Maven and the Python libraries and compiling the jar took about 13 minutes,
  so doing that once in the image keeps server start-up fast. The backend IPs
  aren't known until Terraform creates the servers, so the frontend page is
  patched at boot with `sed`.
- **Terraform works out the order itself.** Because the frontend's boot script
  uses the Python and Java IP addresses, Terraform built the two backends
  first without me ordering anything.
- **Look AMIs up by name, don't paste IDs.** A `data "aws_ami"` block finds
  the newest `fruits-*` image, so a rebuild needs no code change.
- **A 404 isn't always a failure.** The Java server returned 404 on `/`, which
  only meant `/` isn't a route. The real endpoint, `/vegetables`, was in the
  frontend's JavaScript, and `curl` plus `grep` helped me find it.
- **Keep secrets out of Git.** `.terraform/`, state files, `*.tfvars` and key
  files are all ignored. I also split the infrastructure code into its own
  repo so it doesn't mix with the application.
- **Small gotchas:** exported AWS credentials only last for one terminal
  session, and `packer build` ran both images in parallel, with the Nginx one
  finishing in under 6 minutes and the backend in nearly 13.

## Clean-up

Ran `terraform destroy` after testing to avoid charges.
