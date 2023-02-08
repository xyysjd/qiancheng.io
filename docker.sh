#!/bin/bash

# 判断当前系统的版本
if [ -f /etc/lsb-release ]; then
    # Ubuntu或Debian
    OS="ubuntu"
elif [ -f /etc/redhat-release ]; then
    # CentOS
    OS="centos"
else
    # 未知系统
    echo "Error: Unsupported operating system."
    exit 1
fi

# 安装Docker的步骤
if [ "$OS" == "ubuntu" ]; then
    # Ubuntu或Debian
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
elif [ "$OS" == "centos" ]; then
    # CentOS
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# 检查Docker是否安装成功
if [ "$(docker version 2>&1 >/dev/null)" ]; then
    echo "Docker installed successfully!"
else
    echo "Error: Failed to install Docker."
    exit 1
fi
