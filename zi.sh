#自用脚本

#彩色
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}

#网速测试
function speedtest(){
wget -O "/root/speedtest.sh" "http://yun.789888.xyz/speedtest.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/speedtest.sh"
chmod 777 "/root/speedtest.sh"
blue "下载完成"
bash /root/speedtest.sh
}

#路由追踪
function jcnf(){
wget -O "/root/jcnf.sh" "https://raw.githubusercontent.com/Netflixxp/jcnfbesttrace/main/jcnf.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/jcnf.sh"
chmod 777 "/root/jcnf.sh"
blue "下载完成"
bash /root/jcnf.sh
}

#宝塔开心版
function install_6.0(){
wget -O "/root/install_6.0.sh" "http://v7.hostcli.com/install/install_6.0.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/install_6.0.sh"
chmod 777 "/root/install_6.0.sh"
blue "下载完成"
bash /root/install_6.0.sh
}

#x-ui安装
function install(){
wget -O "/root/install.sh" "https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/install.sh"
chmod 777 "/root/install.sh"
blue "下载完成"
bash /root/install.sh
}

#探针安装
function status(){
wget -O "/root/status.sh" "https://raw.githubusercontent.com/cokemine/ServerStatus-Hotaru/master/status.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/status.sh"
chmod 777 "/root/status.sh"
blue "下载完成"
bash /root/status.sh
}

#安装warp+
function menu(){
wget -O "/root/menu.sh" "https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/menu.sh"
chmod 777 "/root/menu.sh"
blue "下载完成"
bash /root/menu.sh
}

#性能测试
function superbench(){
wget -O "/root/superbench.sh" "https://raw.githubusercontent.com/qd201211/Linux-SpeedTest/master/superbench.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/superbench.sh"
chmod 777 "/root/superbench.sh"
blue "下载完成"
bash /root/superbench.sh
}

#主菜单
function start_menu(){
    clear
    red " =================================================="
                                                blue " 千城专用脚本"
    green " 1. 网速测试"
    green " 2. 路由追踪"
    green " 3. 宝塔开心版"
    green " 4. x-ui安装"
    green " 5. 探针安装"
    green " 6. 安装warp+"
    green " 7. 性能测试"
    green " 0. 退出脚本"

echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
        1 )
           speedtest
	;;
        2 )
           jcnf
	;;
       3 )
           install_6.0
               ;;
       4 )
           install
               ;;
       5 )
           status
               ;;
       6 )
           menu
               ;;
       7 )
           superbench
               ;;
       0 )
            exit 1
        ;;
        * )
            clear
            red "请输入正确数字 !"
            start_menu
        ;;
    esac
}
start_menu "first"
