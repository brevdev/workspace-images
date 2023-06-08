#!/bin/bash

set -euvxo pipefail

lsblk -a
sleep 1

mount
sleep 1

fdisk -l
sleep 1

# Variables
SOURCE_DISK="/dev/nvme0n1"
TARGET_DISK="/dev/nvme1n1"
DOCKER_IMAGE="nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu20.04"
DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

RAMDISK_SIZE="16G"
RAMDISK_DIR="/var/lib/docker"

# Create a ramdisk for Docker
echo "Creating a ramdisk for Docker at ${RAMDISK_DIR} with size ${RAMDISK_SIZE}..."
mkdir -p "${RAMDISK_DIR}"
mount -t tmpfs -o size="${RAMDISK_SIZE}" tmpfs "${RAMDISK_DIR}"

# Replicate the boot and partitions of the source disk to the target disk
echo "Replicating boot and partitions from ${SOURCE_DISK} to ${TARGET_DISK}..."
sfdisk -d "${SOURCE_DISK}" | sfdisk "${TARGET_DISK}"

# Resize the root partition to take up all available space
echo "Resizing root partition on ${TARGET_DISK}..."
parted "${TARGET_DISK}" --script -- mklabel gpt
parted "${TARGET_DISK}" --script -- mkpart primary ext4 0% 100%

# Update the kernel about the new partition table
partprobe "${TARGET_DISK}"

# Wait for the root partition to appear
echo "Waiting for the root partition to appear..."
while true; do
  ROOT_PARTITION=$(fdisk -l "${TARGET_DISK}" | grep -E '^/dev' | awk '{print $1}' | head -n 1)
  if [ -n "${ROOT_PARTITION}" ]; then
    break
  fi
  sleep 1
done

lsblk -a
# Find the correct root partition name
ROOT_PARTITION=$(lsblk -l -o NAME,TYPE "${TARGET_DISK}" | grep part | awk '{print $1}' | head -n 1)

# Format the root partition
echo "Formatting root partition on ${TARGET_DISK}..."
mkfs.ext4 "/dev/${ROOT_PARTITION}"

# Mount the root partition
echo "Mounting root partition on ${TARGET_DISK}..."
mount "/dev/${ROOT_PARTITION}" /mnt

# INSTALL DOCKER ===========================================
apt-get update && sudo apt-get install -y \
	apt-transport-https \
	ca-certificates \
	gnupg \
	lsb-release

curl -fsSL https://download.docker.com/linux/${DISTRO}/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
	"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${DISTRO} \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

apt-get update && sudo apt-get install -y \
	containerd.io \
	docker-ce \
	docker-ce-cli \
	docker-compose-plugin

# Download the image using ctr
echo "Downloading image ${DOCKER_IMAGE} using ctr..."
ctr image pull "docker.io/${DOCKER_IMAGE}"

# Mount the image to a temporary directory
echo "Mounting image ${DOCKER_IMAGE} to a temporary directory..."
mkdir -p /tmp/ctr_mount
ctr image list
ctr image mount "docker.io/${DOCKER_IMAGE}" /tmp/ctr_mount

# Copy the contents of the mounted image to the root partition
echo "Copying the contents of the mounted image to the root partition..."
rsync -arog /tmp/ctr_mount/* /mnt/

# Unmount the image
echo "Unmounting the image from the temporary directory..."
umount /tmp/ctr_mount

cat /etc/resolv.conf

# Mount necessary filesystems for chroot
mkdir -p /mnt/{dev,proc,run,sys}
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
mount --bind /run /mnt/run

# Chroot into the new root partition
ROOT_UUID=$(blkid -s UUID -o value "/dev/${ROOT_PARTITION}")
export ROOT_UUID
ls -alht /mnt/
chroot /mnt /bin/bash <<EOF
# Install GRUB bootloader
echo "Installing GRUB bootloader..."
grub-install "${TARGET_DISK}"
grub-mkconfig -o /boot/grub/grub.cfg

# Update /etc/fstab with the correct UUID
echo "Updating /etc/fstab with the correct UUID..."
ROOT_UUID=$(blkid -s UUID -o value "/dev/${ROOT_PARTITION}")
sed -i "s|^UUID=.* / |UUID=${ROOT_UUID} / |" /etc/fstab
EOF

# Unmount the ramdisk
systemctl stop docker docker.socket
echo "Unmounting the ramdisk at ${RAMDISK_DIR}..."
umount "${RAMDISK_DIR}"

# RUN THE TRAP

chroot /mnt/ /bin/bash <<EOF

	echo 'nameserver 8.8.4.4' > /etc/resolv.conf

	# CONFIGURE BASE ===========================================
	export DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
	export DEBIAN_FRONTEND=noninteractive

	apt-get update && \
		apt-get upgrade -y && \
		apt-get install -y \
			apache2-utils \
			bmon \
			build-essential \
			cmake \
			curl \
			dconf-cli \
			dnsutils \
			ethtool \
			grub2 \
			grub2-common \
			htop \
			iotop \
			ipcalc \
			jq \
			libffi-dev \
			libmariadb-dev-compat \
			libssl-dev \
			libusb-dev \
			minicom \
			net-tools \
			nethogs \
			nmap \
			ntpdate \
			parted \
			pkg-config \
			pwgen \
			python3-dev \
			python3-pip \
			redis-tools \
			rsync \
			silversearcher-ag \
			software-properties-common \
			sudo \
			tmate \
			tmux \
			tree \
			uuid-runtime \
			vim \
			wget && \
		apt-get autoremove -y

	pip install --upgrade \
		accelerate \
		bitsandbytes \
		black \
		datasets \
		huggingface_hub \
		isort \
		pylama \
		tensorboard \
		torch \
		transformers

	# ==========================================================

	# INSTALL DOCKER ===========================================
	apt-get update && sudo apt-get install -y \
		apt-transport-https \
		ca-certificates \
		gnupg \
		lsb-release

	curl -fsSL https://download.docker.com/linux/${DISTRO}/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

	echo \
		"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${DISTRO} \
		$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

	apt-get update && sudo apt-get install -y \
		containerd.io \
		docker-ce \
		docker-ce-cli \
		docker-compose-plugin

	groupadd docker || echo "${USER} already part of docker group!"
	usermod -aG docker $USER

	systemctl enable docker.service
	systemctl enable containerd.service

	# Legacy Docker Compose
	curl -L "https://github.com/docker/compose/releases/download/2.10.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	# ==========================================================

	# TEST ENV =================================================

	# ==========================================================


	# Exit chroot
	exit
EOF

# Unmount filesystems and the root partition
umount /mnt/{dev,proc,run,sys}
umount /mnt

fdisk -l

echo "Done."
