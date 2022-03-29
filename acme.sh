#!/bin/bash
red='\033[0;31m'
bblue='\033[0;34m'
plain='\033[0m'
red(){ echo -e "\033[31m\033[01m$1\033[0m";}
green(){ echo -e "\033[32m\033[01m$1\033[0m";}
yellow(){ echo -e "\033[33m\033[01m$1\033[0m";}
white(){ echo -e "\033[37m\033[01m$1\033[0m";}
readp(){ read -p "$(yellow "$1")" $2;}
[[ $EUID -ne 0 ]] && yellow "请以root模式运行脚本" && exit 1
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
red "不支持你当前系统，请选择使用Ubuntu,Debian,Centos系统" && exit 1
fi
[[ $(type -P yum) ]] && yumapt='yum -y' || yumapt='apt -y'
[[ $(type -P curl) ]] || (yellow "检测到curl未安装，升级安装中" && $yumapt update;$yumapt install curl)

get_char(){
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}
back1(){
white "------------------------------------------------------------------------------------------------"
white " 回主菜单，请按任意键"
white " 退出脚本，请按Ctrl+C"
get_char && bash acme.sh
}

acmeinstall(){
v6=$(curl -s6m3 https://ip.gs)
v4=$(curl -s4m3 https://ip.gs)
if [[ -z $v4 ]]; then
yellow "检测到VPS为纯IPV6 Only，添加dns64"
echo -e nameserver 2a01:4f8:c2c:123f::1 > /etc/resolv.conf
green "dns64添加完毕"
sleep 2
fi
yellow "关闭防火墙，开放所有端口规则"
systemctl stop firewalld.service >/dev/null 2>&1
systemctl disable firewalld.service >/dev/null 2>&1
setenforce 0 >/dev/null 2>&1
ufw disable >/dev/null 2>&1
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F 
iptables -F
iptables -X
green "所有端口已开放"
sleep 2
if [[ -n $(lsof -i :80|grep -v "PID") ]]; then
yellow "检测到80端口被占用，现执行80端口全释放"
sleep 2
lsof -i :80|grep -v "PID"|awk '{print "kill -9",$2}'|sh >/dev/null 2>&1
green "80端口全释放完毕！"
sleep 2
fi	
green "安装必要依赖及acme.sh"
[[ $(type -P yum) ]] && yumapt='yum -y' || yumapt='apt -y'
[[ $(type -P curl) ]] || $yumapt update;$yumapt install curl
[[ $(type -P socat) ]] || $yumapt install socat
readp "请输入注册所需的邮箱（回车跳过则自动生成虚拟gmail邮箱）：" Aemail
if [ -z $Aemail ]; then
auto=`date +%s%N |md5sum | cut -c 1-6`
Aemail=$auto@gmail.com
fi
yellow "当前注册的邮箱名称：$Aemail"
curl https://get.acme.sh | sh -s email=$Aemail
$yumapt install lsof
source ~/.bashrc
bash /root/.acme.sh/acme.sh --upgrade --auto-upgrade
readp "请输入解析完成的域名:" ym
green "已输入的域名:$ym" && sleep 1
domainIP=$(curl -s ipget.net/?ip="cloudflare.1.1.1.1.$ym")
if [[ -n $(echo $domainIP | grep nginx) ]]; then
domainIP=$(curl -s ipget.net/?ip="$ym")
if [[ $domainIP = $v4 ]]; then
yellow "当前二级域名解析到的IPV4：$domainIP" && sleep 1
bash /root/.acme.sh/acme.sh  --issue -d ${ym} --standalone -k ec-256 --server letsencrypt
fi
if [[ $domainIP = $v6 ]]; then
yellow "当前二级域名解析到的IPV6：$domainIP" && sleep 1
bash /root/.acme.sh/acme.sh  --issue -d ${ym} --standalone -k ec-256 --server letsencrypt --listen-v6
fi
if [[ -n $(echo $domainIP | grep nginx) ]]; then
yellow "域名解析无效，请检查二级域名是否填写正确或稍等几分钟等待解析完成再执行脚本"
elif [[ -n $(echo $domainIP | grep ":") || -n $(echo $domainIP | grep ".") ]]; then
if [[ $domainIP != $v4 ]] && [[ $domainIP != $v6 ]]; then
red "当前二级域名解析的IP与当前VPS使用的IP不匹配"
green "建议如下："
yellow "1、请确保Cloudflare小黄云关闭状态(仅限DNS)，其他域名解析网站设置同理"
yellow "2、请检查域名解析网站设置的IP是否正确"
fi
fi
else
green "经检测，当前为泛域名申请证书模式，目前脚本仅支持Cloudflare的DNS申请方式"
readp "请复制Cloudflare的Global API Key:" GAK
export CF_Key="$GAK"
readp "请输入登录Cloudflare的注册邮箱地址:" CFemail
export CF_Email="$CFemail"
if [[ $domainIP = $v4 ]]; then
yellow "当前泛域名解析到的IPV4：$domainIP" && sleep 1
bash /root/.acme.sh/acme.sh --issue --dns dns_cf -d ${ym} -d *.${ym} -k ec-256 --server letsencrypt
fi
if [[ $domainIP = $v6 ]]; then
yellow "当前泛域名解析到的IPV6：$domainIP" && sleep 1
bash /root/.acme.sh/acme.sh --issue --dns dns_cf -d ${ym} -d *.${ym} -k ec-256 --server letsencrypt --listen-v6
fi
fi
bash /root/.acme.sh/acme.sh --install-cert -d ${ym} --key-file /root/private.key --fullchain-file /root/cert.crt --ecc
checktls
}
checktls(){
if [[ -f /root/cert.crt && -f /root/private.key ]]; then
if [[ -s /root/cert.crt && -s /root/private.key ]]; then
sed -i '/--cron/d' /etc/crontab >/dev/null 2>&1
echo "0 0 * * * root bash /root/.acme.sh/acme.sh --cron -f >/dev/null 2>&1" >> /etc/crontab
green "恭喜，域名证书申请成功！域名证书（cert.crt）和密钥（private.key）已保存到 /root 文件夹" 
yellow "公钥文件crt路径如下，可直接复制"
green "/root/cert.crt"
yellow "密钥文件key路径如下，可直接复制"
green "/root/private.key"
else
red "遗憾，域名证书申请失败"
yellow "建议一：更换下二级域名名称再尝试执行脚本（重要）"
green "例：原二级域名 x.xxxx.eu.org 或 x.xxxx.cf ，在cloudflare中重命名其中的x名称，确定并生效"
yellow "建议二：更换下当前本地网络IP环境，再尝试执行脚本"
fi
fi
}
acme(){
yellow "稍等3秒，检测IP环境中"
wgcfv6=$(curl -s6m6 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
wgcfv4=$(curl -s4m6 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
if [[ ! $wgcfv4 =~ on|plus && ! $wgcfv6 =~ on|plus ]]; then
acmeinstall
else
yellow "检测到正在使用WARP接管VPS出站，现执行临时关闭"
systemctl stop wg-quick@wgcf >/dev/null 2>&1
green "WARP已临时闭关"
acmeinstall
yellow "现恢复原先WARP接管VPS出站设置，现执行WARP开启"
systemctl start wg-quick@wgcf >/dev/null 2>&1
green "WARP已恢复开启"
fi
}
Certificate(){
[[ -z $(/root/.acme.sh/acme.sh -v 2>/dev/null) ]] && yellow "未安装acme.sh证书申请，无法执行" && back1
bash /root/.acme.sh/acme.sh --list
readp "请输入要撤销并删除的域名证书（复制Main_Domain下显示的域名）:" ym
if [[ -n $(bash /root/.acme.sh/acme.sh --list | grep $ym) ]]; then
bash /root/.acme.sh/acme.sh --revoke -d ${ym} --ecc
bash /root/.acme.sh/acme.sh --remove -d ${ym} --ecc
green "撤销并删除${ym}域名证书成功"
back1
else
red "未找到你输入的${ym}域名证书，请自行核实！"
back1
fi
}
acmerenew(){
[[ -z $(/root/.acme.sh/acme.sh -v 2>/dev/null) ]] && yellow "未安装acme.sh证书申请，无法执行" && back1
bash /root/.acme.sh/acme.sh --list
readp "请输入要续期的域名证书（复制Main_Domain下显示的域名）:" ym
if [[ -n $(bash /root/.acme.sh/acme.sh --list | grep $ym) ]]; then
bash /root/.acme.sh/acme.sh --renew -d ${ym} --force --ecc
checktls
back1
else
red "未找到你输入的${ym}域名证书，请自行核实！"
back1
fi
}
#某些人又来抄了，就是你：Misaka，Misaka，Misaka，不写出处，此提醒永存。不讲武德的人今后注定不成事。
uninstall(){
[[ -z $(/root/.acme.sh/acme.sh -v 2>/dev/null) ]] && yellow "未安装acme.sh证书申请，无法执行" && back1
curl https://get.acme.sh | sh
bash /root/.acme.sh/acme.sh --uninstall
rm -rf ~/.acme.sh acme.sh
sed -i '/--cron/d' /etc/crontab >/dev/null 2>&1
[[ -z $(/root/.acme.sh/acme.sh -v 2>/dev/null) ]] && green "acme.sh卸载完毕" || red "acme.sh卸载失败"
}

start_menu(){
clear
green "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"           
echo -e "${bblue} ░██   ░██     ░██   ░██     ░██${plain}   ░██    ░██     ░██      ░██ ██ ${red}██${plain} "
echo -e "${bblue} ░██  ░██      ░██  ░██${plain}      ░██  ░██      ░██   ░██      ░██    ${red}░░██${plain} "            
echo -e "${bblue} ░██ ██        ░██${plain} ██        ░██ ██         ░██ ░██      ░${red}██        ${plain} "
echo -e "${bblue} ░██ ██       ${plain} ░██ ██        ░██ ██           ░██        ${red}░██    ░██ ██${plain} "
echo -e "${bblue} ░██ ░${plain}██       ░██ ░██       ░██ ░██          ░${red}██         ░██    ░░██${plain}"
echo -e "${bblue} ░${plain}██  ░░██     ░██  ░░██     ░██  ░░${red}██        ░██          ░██ ██ ██${plain} "
green "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
white "甬哥Github项目  ：github.com/kkkyg"
white "甬哥blogger博客 ：kkkyg.blogspot.com"
white "甬哥YouTube频道 ：www.youtube.com/c/甬哥侃侃侃kkkyg"
yellow "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
green " 1. 首次ACME申请证书（自动识别单域名与泛域名） "
green " 2. 查询、撤销并删除当前已申请的域名证书 "
green " 3. 手动续期域名证书 "
green " 4. 卸载一键ACME证书申请脚本 "
green " 0. 退出 "
read -p "请输入数字:" NumberInput
case "$NumberInput" in     
1 ) acme;;
2 ) Certificate;;
3 ) acmerenew;;
4 ) uninstall;;
* ) exit      
esac
}   
start_menu "first" 

