#!/bin/bash

set -euvxo pipefail

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
		tmate \
		tmux \
		tree \
		uuid-runtime \
		vim \
		wget && \
	apt-get autoremove -y
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

# INSTALL NVIDIA CUDA BASE =================================
export NVARCH=x86_64

export NVIDIA_REQUIRE_CUDA="cuda>=12.1 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471 brand=tesla,driver>=510,driver<511 brand=unknown,driver>=510,driver<511 brand=nvidia,driver>=510,driver<511 brand=nvidiartx,driver>=510,driver<511 brand=geforce,driver>=510,driver<511 brand=geforcertx,driver>=510,driver<511 brand=quadro,driver>=510,driver<511 brand=quadrortx,driver>=510,driver<511 brand=titan,driver>=510,driver<511 brand=titanrtx,driver>=510,driver<511 brand=tesla,driver>=515,driver<516 brand=unknown,driver>=515,driver<516 brand=nvidia,driver>=515,driver<516 brand=nvidiartx,driver>=515,driver<516 brand=geforce,driver>=515,driver<516 brand=geforcertx,driver>=515,driver<516 brand=quadro,driver>=515,driver<516 brand=quadrortx,driver>=515,driver<516 brand=titan,driver>=515,driver<516 brand=titanrtx,driver>=515,driver<516 brand=tesla,driver>=525,driver<526 brand=unknown,driver>=525,driver<526 brand=nvidia,driver>=525,driver<526 brand=nvidiartx,driver>=525,driver<526 brand=geforce,driver>=525,driver<526 brand=geforcertx,driver>=525,driver<526 brand=quadro,driver>=525,driver<526 brand=quadrortx,driver>=525,driver<526 brand=titan,driver>=525,driver<526 brand=titanrtx,driver>=525,driver<526"
export NV_CUDA_CUDART_VERSION="12.1.105-1"
export NV_CUDA_COMPAT_PACKAGE="cuda-compat-12-1"

export NVIDIA_REQUIRE_CUDA="cuda>=12.1"
export NV_CUDA_CUDART_VERSION="12.1.105-1"

export TARGETARCH=$NVARCH

apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

export CUDA_VERSION="12.1.1"

apt-get update && apt-get update

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-12-1=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
export NVIDIA_VISIBLE_DEVICES=all
export NVIDIA_DRIVER_CAPABILITIES=compute,utility
# ==========================================================

# INSTALL NVIDIA CUDA RUNTIME ==============================
export NV_CUDA_LIB_VERSION="12.1.1-1"

export NV_NVTX_VERSION="12.1.105-1"
export NV_LIBNPP_VERSION="12.1.0.40-1"
export NV_LIBNPP_PACKAGE="libnpp-12-1=${NV_LIBNPP_VERSION}"
export NV_LIBCUSPARSE_VERSION="12.1.0.106-1"

export NV_LIBCUBLAS_PACKAGE_NAME="libcublas-12-1"
export NV_LIBCUBLAS_VERSION="12.1.3.1-1"
export NV_LIBCUBLAS_PACKAGE="${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}"

export NV_LIBNCCL_PACKAGE_NAME="libnccl2"
export NV_LIBNCCL_PACKAGE_VERSION="2.17.1-1"
export NCCL_VERSION="2.17.1-1"
export NV_LIBNCCL_PACKAGE="${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda12.1"

export NV_NVTX_VERSION="12.1.105-1"
export NV_LIBNPP_VERSION="12.1.0.40-1"
export NV_LIBNPP_PACKAGE="libnpp-12-1=${NV_LIBNPP_VERSION}"
export NV_LIBCUSPARSE_VERSION="12.1.0.106-1"

export NV_LIBCUBLAS_PACKAGE_NAME="libcublas-12-1"
export NV_LIBCUBLAS_VERSION="12.1.3.1-1"
export NV_LIBCUBLAS_PACKAGE="${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}"

export NV_LIBNCCL_PACKAGE_NAME="libnccl2"
export NV_LIBNCCL_PACKAGE_VERSION="2.17.1-1"
export NCCL_VERSION="2.17.1-1"
export NV_LIBNCCL_PACKAGE="${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda12.1"

apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-12-1=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    cuda-nvtx-12-1=${NV_NVTX_VERSION} \
    libcusparse-12-1=${NV_LIBCUSPARSE_VERSION} \
    ${NV_LIBCUBLAS_PACKAGE} \
    ${NV_LIBNCCL_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME}

# Add entrypoint items
export NVIDIA_PRODUCT_NAME="CUDA"
# COPY entrypoint.d/ /opt/nvidia/entrypoint.d/
# COPY nvidia_entrypoint.sh /opt/nvidia/
# ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh"]

# ==========================================================
