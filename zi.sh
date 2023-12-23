#自用脚本


# 获取IP地址及其信息
IP4=$(curl -s4m2 https://ip.gs/json)
IP6=$(curl -s6m2 https://ip.gs/json)
WAN4=$(expr "$IP4" : '.*ip\":\"\([^"]*\).*')
WAN6=$(expr "$IP6" : '.*ip\":\"\([^"]*\).*')
COUNTRY4=$(expr "$IP4" : '.*country\":\"\([^"]*\).*')
COUNTRY6=$(expr "$IP6" : '.*country\":\"\([^"]*\).*')
ASNORG4=$(expr "$IP4" : '.*asn_org\":\"\([^"]*\).*')
ASNORG6=$(expr "$IP6" : '.*asn_org\":\"\([^"]*\).*')

# 判断IP地址状态
IP4="$WAN4 （$COUNTRY4 $ASNORG4）"
IP6="$WAN6 （$COUNTRY6 $ASNORG6）"
if [ -z $WAN4 ]; then
	IP4="当前VPS未检测到IPv4地址"
fi
if [ -z $WAN6 ]; then
	IP6="当前VPS未检测到IPv6地址"
fi

# 获取脚本运行次数
COUNT=$(curl -sm2 "https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2FMisaka-blog%2FMisakaLinuxToolbox%40master%2FMisakaToolbox.sh&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false" 2>&1) &&
TODAY=$(expr "$COUNT" : '.*\s\([0-9]\{1,\}\)\s/.*')
TOTAL=$(expr "$COUNT" : '.*/\s\([0-9]\{1,\}\)\s.*')

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

#秋水网速测试
function speedtest(){
wget -qO- bench.sh | bash
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
wget -O "/root/install_6.0.sh" "http://www.btkaixin.net/install/install_6.0.sh" --no-check-certificate -T 30 -t 5 -d
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

#编译python3
function python3(){
wget -N --no-check-certificate https://raw.githubusercontent.com/xyysjd/qiancheng.io/main/python.sh && bash python.sh
}

#安装warp+
function menu(){
wget -O "/root/menu.sh" "https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh" --no-check-certificate -T 30 -t 5 -d
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

#开启bbr加速
function tcp(){
wget -O "/root/tcp.sh" "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/tcp.sh"
chmod 777 "/root/tcp.sh"
blue "下载完成"
bash /root/tcp.sh
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
wget -qO- get.docker.com | bash
}

#哪吒
function nezha(){
curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh
}


#回程检测
function mtrtrace(){
curl https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh|bash
}

#ssh修改root登录
function rootdl(){
curl -L https://raw.githubusercontent.com/xyysjd/qiancheng.io/main/root.sh -o root.sh && chmod +x root.sh && ./root.sh
}

#安装acme证书
function acme(){
curl -L https://raw.githubusercontent.com/xyysjd/qiancheng.io/main/acme.sh -o acme.sh && chmod +x acme.sh && ./acme.sh
}

#开启swap
function swap(){
curl -L https://raw.githubusercontent.com/xyysjd/qiancheng.io/main/swap.sh -o swap.sh && chmod +x swap.sh && ./swap.sh
}

#screen
function screen(){
curl -L https://raw.githubusercontent.com/xyysjd/qiancheng.io/main/screen.sh -o screen.sh && chmod +x screen.sh && ./screen.sh
}

#neko优化
function neko(){
curl -L https://raw.githubusercontent.com/xyysjd/qiancheng.io/main/tools.sh -o tools.sh && chmod +x tools.sh && ./tools.sh
}

#XrayR
function XrayR(){
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
}

#更换语言为中文
function zhongwen(){
	chattr -i /etc/locale.gen
	cat > '/etc/locale.gen' << EOF
zh_CN.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8
en_US.UTF-8 UTF-8
ja_JP.UTF-8 UTF-8
EOF
	locale-gen
	update-locale
	chattr -i /etc/default/locale
	cat > '/etc/default/locale' << EOF
LANGUAGE="zh_CN.UTF-8"
LANG="zh_CN.UTF-8"
LC_ALL="zh_CN.UTF-8"
EOF
	export LANGUAGE="zh_CN.UTF-8"
	export LANG="zh_CN.UTF-8"
	export LC_ALL="zh_CN.UTF-8"
}

#开启端口
open_ports(){
    systemctl stop firewalld.service
    systemctl disable firewalld.service
    setenforce 0
    ufw disable
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -t nat -F
    iptables -t mangle -F 
    iptables -F
    iptables -X
    netfilter-persistent save
    yellow "VPS中的所有网络端口已开启"
}

#主菜单
function start_menu(){
    clear 
    blue "===============----千城一键综合Linux脚本----==============="
    blue "================脚本最后更新时间2022年5月19日================"
    red  "================-------大自然的搬运工-------================"
    red  "==========今日运行次数：$TODAY 总共运行次数：$TOTAL=========="
    blue "检测到VPS信息如下"
    blue "处理器架构：$arch"
    blue "虚拟化架构：$virt"
    blue "操作系统：$release"
    blue "内核版本：$kernelVer"
    blue "IPv4地址：$IP4"
    blue "IPv6地址：$IP6"
    green " 1. vps性能测试            2. 秋水网速测试"                  
    green " 3. 路由追踪               4. 流媒体检测"
    green " 5. 安装warp+              6. 宝塔开心版"
    green " 7. x-ui安装               8. 八合一脚本"
    green " 9. 开启bbr加速           10. 哪吒"
    green " 11. 安装docker           12. python3"
    green " 13. 回程检测             14. ssh修改root登录"
    green " 15. 安装acme证书         16. 开启端口"
    green " 17. 开启swap             18. screen"
    green " 19. neko优化             20.更换语言为中文"
    green " 21. XrayR                0. 退出脚本"
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
#秋水网速测试
        2 ) speedtest ;;
#路由追踪
        3 ) jcnf ;;
#宝塔开心版
        6 ) install_6.0 ;;
#x-ui安装
        7 ) install ;;
#python3
        12 ) python3 ;; 
#安装warp+  
        5 ) menu ;;     
#vps性能测试
        1 ) superbench ;;  
#开启bbr 
        9 ) tcp ;;  
#八合一脚本  
      8 ) baheyi ;;
#流媒体检测
      4 ) liumeiti ;;
#docker
      11 ) docker ;;
#哪吒
      10 ) nezha ;;
#回程检测
      13 ) mtrtrace ;;

#ssh修改root登录
      14 ) rootdl ;;

#安装acme证书
      15 ) acme ;;

#开启端口
      16 ) open_ports ;;

#开启swap
      17 ) swap ;;

#screen
      18 ) screen ;;

#neko优化
      19 ) neko ;;

#更换语言为中文
      20 ) zhongwen ;;

#XrayR
      21 ) XrayR ;;

#退出
        0 ) exit 1 ;;
    esac
}
start_menu

