packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  version      = formatdate("YYYYMMDDhhmm", timestamp())
  name         = "brev-basic-ubuntu-amd64"
  name_version = "${local.name}-${local.version}"
}

source "amazon-ebs" "ubuntu-west-2" {
  ami_name      = local.name_version
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  ami_groups = ["all"]
}

source "amazon-ebs" "ubuntu-west-1" {
  ami_name      = local.name_version
  instance_type = "t2.micro"
  region        = "us-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  ami_groups = ["all"]
}


build {
  name = local.name_version
  sources = [
    "source.amazon-ebs.ubuntu-west-2",
    "source.amazon-ebs.ubuntu-west-1"
  ]

  provisioner "shell" {
    script = "scripts/install-docker.sh"
  }
}