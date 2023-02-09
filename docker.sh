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

# 菜单选项
echo "1. Install Docker"
echo "2. Uninstall Docker"
echo "0. Exit"
read -p "Enter your choice (1/2/0): " CHOICE

# 安装Docker的步骤
if [ "$CHOICE" == "1" ]; then
    if [ "$OS" == "ubuntu" ]; then
        # Ubuntu或Debian
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker
    elif [ "$OS" == "centos" ]; then
        # CentOS
        sudo yum update -y
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    # 检查Docker是否安装成功
    if [ "$(docker version 2>&1 >/dev/null)" ]; then
        echo "Docker installed successfully!"
        echo "Docker version: $(docker version --format '{{.Server.Version}}')"
    else
        echo "Error: Failed to install Docker."
        exit 1
    fi
elif [ "$CHOICE" == "2" ]; then
    if [ "$OS" == "ubuntu" ]; then
        # Ubuntu或Debian
        sudo systemctl stop docker
        sudo apt-get remove -y docker-ce docker-ce-cli containerd.io
        sudo apt-get autoremove -y
    elif [ "$OS" == "centos" ]; then
        # CentOS
        sudo systemctl stop docker
        sudo yum remove -y docker-ce docker-ce-cli containerd.io
    fi
    echo "Docker uninstalled successfully!"
elif [ "$CHOICE" == "0" ]; then
    exit 0
else
    echo "Error: Invalid option."
    exit 1
fi
