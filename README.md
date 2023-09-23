# Linux Upskill Challenge

## Basic configuration

### Gitpod env vars

```bash
gp env PROJECT_ROOT=/workspace/[github repo name]
gp env AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
gp env AWS_DEFAULT_REGION=eu-central-1
gp env AWS_ACCESS_KEY_ID=IOTY7998709HGDFHGFK
gp env TF_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### AWS

AMI image for ubuntu-jammy-22.04-amd64-server-20230516

`ami           = "ami-04e601abe3e1a910f"`

Security group for SSH access opened to 0.0.0.0 for testing only

`security_groups = ["launch-wizard-1"]`

#### EC2_INSTANCE_CONNECT prefix list for SSH access

Prefix for eu-central-1:

```bash
"3.120.181.40/29"
```

[AWS IP address ranges](https://ip-ranges.amazonaws.com/ip-ranges.json)

#### Get the IP range for EC2 Instance Connect for a region

`wget -qO- https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.region=="*eu-central-1*") | select(.service=="EC2_INSTANCE_CONNECT") | .ip_prefix'`

### AWS CLI commands

#### List running instances

`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"`

#### List running instances with name tag

`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].{Name: Tags[?Key=='Name']|[0].Value, InstanceId: InstanceId}" --output table`
