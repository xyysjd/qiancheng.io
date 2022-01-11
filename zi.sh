#自用脚本
rm -rf zi.sh

# 全局变量
arch=`uname -m`
virt=`systemd-detect-virt`
kernelVer=`uname -r`

#颜色
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

#检测与安装
if [[ -f /etc/redhat-release ]]; then
    release="Centos"
elif cat /etc/issue | grep -q -E -i "debian"; then
    release="Debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
    release="Ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
    release="Centos"
elif cat /proc/version | grep -q -E -i "debian"; then
    release="Debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
    release="Ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
    release="Centos"
else 
    red "不支持你当前系统，请使用Ubuntu、Debian、Centos的主流系统"
    rm -f MisakaToolbox.sh
    exit 1
fi

if ! type curl >/dev/null 2>&1; then 
    yellow "curl未安装，安装中"
    if [ $release = "Centos" ]; then
        yum -y update && yum install curl -y
    else
        apt-get update -y && apt-get install curl -y
    fi	   
else
    green "curl已安装"
fi

if ! type wget >/dev/null 2>&1; then 
    yellow "wget未安装，安装中"
    if [ $release = "Centos" ]; then
        yum -y update && yum install wget -y
    else
        apt-get update -y && apt-get install wget -y
    fi	   
else
    green "wget已安装"
fi

if ! type sudo >/dev/null 2>&1; then 
    yellow "sudo未安装，安装中"
    if [ $release = "Centos" ]; then
        yum -y update && yum install sudo -y
    else
        apt-get update -y && apt-get install sudo -y
    fi	   
else
    green "sudo已安装"
fi

function oraclefirewall(){
    if [ $release = "Centos" ]; then
        systemctl stop oracle-cloud-agent
        systemctl disable oracle-cloud-agent
        systemctl stop oracle-cloud-agent-updater
        systemctl disable oracle-cloud-agent-updater
        systemctl stop firewalld.service
        systemctl disable firewalld.service
    else
        iptables -P INPUT ACCEPT
        iptables -P FORWARD ACCEPT
        iptables -P OUTPUT ACCEPT
        iptables -F
        apt-get purge netfilter-persistent -y
    fi
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

#可乐
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

#vps性能测试
function superbench(){
wget -O "/root/superbench.sh" "https://raw.githubusercontent.com/qd201211/Linux-SpeedTest/master/superbench.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/superbench.sh"
chmod 777 "/root/superbench.sh"
blue "下载完成"
bash /root/superbench.sh
}

#开启bbr
function tcp(){
wget -O "/root/tcp.sh" "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/tcp.sh"
chmod 777 "/root/tcp.sh"
blue "下载完成"
bash /root/tcp.sh
}

#获取本机IP
function getip(){
echo  
curl ip.p3terx.com
echo
}

#八合一脚本
function baheyi(){
wget -O "/root/install.sh" "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/install.sh"
chmod 777 "/root/install.sh"
blue "下载完成"
bash /root/install.sh
}

#流媒体检测
function liumeiti(){
wget -O "/root/liumeiti.sh" "https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/liumeiti.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/liumeiti.sh"
chmod 777 "/root/liumeiti.sh"
blue "下载完成"
bash /root/liumeiti.sh
}

#docker
function docker(){
wget -N --no-check-certificate https://raw.githubusercontent.com/zhengyi0414/docker/main/docker-install.sh
bash docker-install.sh
}

#哪吒
function nezha(){
curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh
}

#优选ip
function youxuan(){
curl https://proxy.freecdn.workers.dev/?url=https://raw.githubusercontent.com/badafans/better-cloudflare-ip/master/shell/cf.sh -o cf.sh && chmod +x cf.sh && ./cf.sh
}

#主菜单
function start_menu(){
    clear 
    blue "===============----千城专用脚本 本人QQ1187330023----==============="
    red "===============-------大自然的搬运工-------==============="

    blue "检测到VPS信息如下"
    blue "处理器架构：$arch"
    blue "虚拟化架构：$virt"
    blue "操作系统：$release"
    blue "内核版本：$kernelVer" 
    green " 1. vps性能测试"                  
    green " 2. 网速测试"
    green " 3. 路由追踪"
    green " 4. 流媒体检测"
    green " 5. 安装warp+"
    green " 6. 宝塔开心版"
    green " 7. x-ui安装"
    green " 8. 八合一脚本"
    green " 9. 开启bbr加速"
    green " 10. 可乐"
    green " 11. 哪吒"
    green " 12. 获取本机IP"
    green " 13. docker"
    green " 14. 优选ip"
    green " 0. 退出脚本"
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
#网速测试
        2 ) speedtest ;;
#路由追踪
        3 ) jcnf ;;
#宝塔开心版
        6 ) install_6.0 ;;
#x-ui安装
        7 ) install ;;
#可乐
        10 ) status ;; 
#安装warp+  
        5 ) menu ;;     
#vps性能测试
        1 ) superbench ;;  
#开启bbr 
        9 ) tcp ;;  
#获取本机IP  
        12 ) getip ;; 
#八合一脚本  
      8 ) baheyi ;;
#流媒体检测
      4 ) liumeiti ;;
#docker
      13 ) docker ;;
#哪吒
      11 ) nezha ;;

#优选ip
      14 ) youxuan ;;
#退出
        0 ) exit 1 ;;
    esac
}
start_menu

