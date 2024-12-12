#### Retrieve Component AMI

data "aws_ami" "component_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CyberArk PAM ${var.component} * ${local.default_ami_os}"]
  }

  owners = ["923248178732"]
}

#### Provision Component Instance

resource "aws_instance" "component" {
  ami                    = local.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.id
  user_data              = local.user_data

  tags = {
    Name = var.instance_name
  }

  # Wait for instance to become reachable before resource "Creation complete"
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${self.id} --region ${local.region}"
  }

  lifecycle {
    replace_triggered_by = [null_resource.userdata_updated]
  }
}