packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  googlecompute = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

locals {
  version      = formatdate("YYYYMMDDhhmm", timestamp())
  name         = "brev-basic-ubuntu-amd64"
  name_version = "${local.name}-${local.version}"
}

source "amazon-ebs" "ubuntu-west-1" {
  ami_name      = local.name_version
  instance_type = "t2.micro"
  region        = "us-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-20230517"
      # name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  ami_groups = ["all"]

  ami_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 100
    volume_type = "gp3"
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 100
    volume_type = "gp3"
    delete_on_termination = true
  }
}

// gcp id ubuntu 20.04: 8590691149326093337
source "googlecompute" "ubuntu" {
  image_name                 = local.name_version
  project_id           = "brevdevprod"
  source_image_project_id = ["ubuntu-os-cloud"]
  source_image_family  = "ubuntu-2004-lts"
  zone                 = "us-central1-a"
  instance_name        = "n1-standard-1"
  ssh_username         = "ubuntu"
  ssh_timeout          = "5m"
  wait_to_add_ssh_keys = "1m"

  // disk_image_name = local.name_version
}

build {
  name = local.name_version
  sources = [
    "source.amazon-ebs.ubuntu-west-1",
    # "source.googlecompute.ubuntu"
  ]

  provisioner "shell" {
    script          = "scripts/configure-machine-image.sh"
    execute_command = "/usr/bin/cloud-init status --wait && chmod +x {{ .Path }}; sudo -E -S sh -c '{{ .Vars }} {{ .Path }}'"
  }
}
