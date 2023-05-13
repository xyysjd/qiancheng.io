#!/bin/bash

# 安装依赖包
sudo apt-get update
sudo apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget -y

# 下载Python源码包
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz

# 解压缩源码包
tar xvf Python-3.10.0.tgz

# 进入解压目录
cd Python-3.10.0

# 编译并安装Python
./configure --enable-optimizations
make -j $(nproc)
sudo make install

# 更新符号链接
sudo ln -sf /usr/local/bin/python3.10 /usr/bin/python3

# 验证Python版本
python3 --version
