#!/bin/bash

# 函数：修改 SSH 端口
change_ssh_port() {
    read -p "请输入新的 SSH 端口号: " new_port
    sudo sed -i "s/^#\?Port .*/Port $new_port/" /etc/ssh/sshd_config
    sudo systemctl restart sshd
    echo "SSH端口号已修改为 $new_port，并已重启SSH服务。"
}

# 函数：修改 root 密码并允许 root 密码登录
change_root_password() {
    read -p "设置root密码: " password
    echo root:$password | sudo chpasswd root
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
    sudo systemctl restart sshd
    echo "VPS用户名：root"
    echo "VPS密码：$password"
    echo "请妥善保存好登录信息！然后重启VPS确保设置已保存！"
}

# 主菜单
main_menu() {
    clear
    echo "============================="
    echo "  VPS设置脚本  "
    echo "============================="
    echo "1. 修改SSH端口"
    echo "2. 修改root密码并允许root登录"
    echo "3. 退出"
    read -p "请选择要执行的操作 [1-3]: " choice
    case $choice in
        1) change_ssh_port ;;
        2) change_root_password ;;
        3) echo "退出脚本" && exit ;;
        *) echo "无效选项，请重新选择" && main_menu ;;
    esac
}

# 执行主菜单
main_menu
