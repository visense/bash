#!/bin/bash

Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

check_info(){
# 检查并安装 curl wget sudo ntpdate
    for pkg in curl wget sudo ntpdate; do
      if ! type $pkg >/dev/null 2>&1; then
        echo -e "${Tip} 未安装 $pkg，正在安装..."
        apt-get update || apt-get --allow-releaseinfo-change update && apt-get install $pkg -y
      else
        echo -e "${Info} $pkg 已安装。"
      fi
    done
	menu
}

dabian_apt_update(){

RELEASE=$(cat /etc/issue)

apt_update(){
    apt update
    if [ $? -ne 0 ]; then
        exit 1
    fi;
}

apt_upgrade(){
    apt_update
    apt upgrade -y
    apt dist-upgrade -y
    apt full-upgrade -y
}

debian10_upgrade(){
    echo "[INFO] Doing debian 10 upgrade..."
    apt_upgrade
    sed -i 's/stretch/buster/g' /etc/apt/sources.list
    sed -i 's/stretch/buster/g' /etc/apt/sources.list.d/*.list
    apt_upgrade
	clear
    echo "${Info} Please reboot"
}

debian11_upgrade(){
    echo "[INFO] Doing debian 11 upgrade..."
    apt_upgrade
    sed -i 's/buster/bullseye/g' /etc/apt/sources.list
    sed -i 's/buster/bullseye/g' /etc/apt/sources.list.d/*.list
    sed -i 's/bullseye\/updates/bullseye-security/g' /etc/apt/sources.list
    apt_upgrade
	clear
    echo "${Info} Please reboot"
}


echo $RELEASE | grep ' 9 '
if [ $? -eq 0 ]; then
    debian10_upgrade
    exit 0
fi;

echo $RELEASE | grep ' 10 '
if [ $? -eq 0 ]; then
    debian11_upgrade
    exit 0
fi;
}

system_network_optimization() {
modprobe ip_conntrack
cat >'/etc/sysctl.d/99-sysctl.conf' <<EOF
net.ipv4.tcp_fack = 1
net.ipv4.tcp_early_retrans = 3
net.ipv4.neigh.default.unres_qlen=10000
net.ipv4.conf.all.route_localnet=1
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.lo.forwarding = 1
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.all.accept_ra = 2
net.ipv6.conf.default.accept_ra = 2
net.core.netdev_max_backlog = 1000000
net.core.netdev_budget = 50000
net.core.netdev_budget_usecs = 5000
fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 67108864
net.core.wmem_default = 67108864
net.core.optmem_max = 65536
net.core.somaxconn = 1000000
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 2
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_max_tw_buckets = 500000
net.ipv4.tcp_fastopen = 0
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_autocorking = 0
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_syn_backlog = 819200
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_ecn_fallback = 1
net.ipv4.tcp_frto = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.neigh.default.gc_thresh3=8192
net.ipv4.neigh.default.gc_thresh2=4096
net.ipv4.neigh.default.gc_thresh1=2048
net.ipv6.neigh.default.gc_thresh3=8192
net.ipv6.neigh.default.gc_thresh2=4096
net.ipv6.neigh.default.gc_thresh1=2048
net.ipv4.tcp_orphan_retries = 1
net.ipv4.tcp_max_orphans = 100
net.ipv4.tcp_retries2 = 1
vm.swappiness = 1
vm.overcommit_memory = 1
kernel.pid_max=64000
net.netfilter.nf_conntrack_buckets = 262144
net.netfilter.nf_conntrack_max = 1000000
net.nf_conntrack_max = 1000000
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 30
net.netfilter.nf_conntrack_tcp_timeout_established = 600
## Enable bbr
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=524288
EOF
  sysctl -p > /dev/null 2>&1
  sysctl --system > /dev/null 2>&1
  echo madvise >/sys/kernel/mm/transparent_hugepage/enabled

  cat >'/etc/systemd/system.conf' <<EOF
[Manager]
#DefaultTimeoutStartSec=90s
DefaultTimeoutStopSec=3s
#DefaultRestartSec=100ms
DefaultLimitCORE=infinity
DefaultLimitNOFILE=infinity
DefaultLimitNPROC=infinity
DefaultTasksMax=infinity
EOF

  cat > '/etc/security/limits.conf' << EOF
root     soft   nofile    1000000
root     hard   nofile    1000000
root     soft   nproc     unlimited
root     hard   nproc     unlimited
root     soft   core      unlimited
root     hard   core      unlimited
root     hard   memlock   unlimited
root     soft   memlock   unlimited
*     soft   nofile    1000000
*     hard   nofile    1000000
*     soft   nproc     unlimited
*     hard   nproc     unlimited
*     soft   core      unlimited
*     hard   core      unlimited
*     hard   memlock   unlimited
*     soft   memlock   unlimited
EOF
  if grep -q "ulimit" /etc/profile; then
    :
  else
    sed -i '/ulimit -SHn/d' /etc/profile
    sed -i '/ulimit -SHu/d' /etc/profile
    echo "ulimit -SHn 1000000" >> /etc/profile
  fi
  if grep -q "pam_limits.so" /etc/pam.d/common-session; then
    :
  else
    sed -i '/required pam_limits.so/d' /etc/pam.d/common-session
    echo "session required pam_limits.so" >> /etc/pam.d/common-session
  fi
  systemctl daemon-reload
  clear
  echo -e "${Info} TCP optimization completed"
  sleep 3
  menu
}
m_icmp(){
clear
echo "
1 - 开启ICMP
2 - 关闭ICMP
"
echo
read -p "请输入对应的数字并回车:" a
i=$a
if [[ $i == 1 ]];then
sed -i "s/net.ipv4.icmp_echo_ignore_all=1/net.ipv4.icmp_echo_ignore_all=0/g" /etc/sysctl.conf
sed -i "s/net.ipv4.icmp_echo_ignore_broadcasts=1/net.ipv4.icmp_echo_ignore_broadcasts=0/g" /etc/sysctl.conf
sysctl -p && sysctl --system  > /dev/null 2>&1
clear
echo -e "${Info} Unblocking ICMP"
sleep 3
menu
fi
if [[ $i == 2 ]];then
sed -i '/net.ipv4.icmp_echo_ignore_all/d' /etc/sysctl.conf
sed -i '/net.ipv4.icmp_echo_ignore_broadcasts/d' /etc/sysctl.conf
cat >> '/etc/sysctl.conf' << EOF
net.ipv4.icmp_echo_ignore_all=1
net.ipv4.icmp_echo_ignore_broadcasts=1
EOF
sysctl -p && sysctl --system  > /dev/null 2>&1
clear
echo -e "${Info} Locking ICMP"
sleep 3
menu
fi
}

check_tv(){
bash <(curl -Ls unlock.moe)
}

install_warp(){
wget -N https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh && bash menu.sh
}

install_debian11(){
read -p "请输入密码:" a
i=$a
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') -d 11 -v 64 -p "$i"
}

install_proxmox(){
echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
apt -y update && apt -y dist-upgrade
apt install -y ifupdown2 proxmox-ve open-iscsi
reboot
}

exchange_sources(){
clear
echo "
---------[国内]---------
1 - 阿里云 Sources
2 - 腾讯云 Sources
3 - 网易云 Sources
4 - 华为云 Sources
5 - 清华大学 Sources
6 - 中科大 Sources
---------[海外]---------
7 - 官方 Sources
8 - Linode Sources
"
echo
read -p "请输入对应的数字并回车（默认7）:" a
i=$a
if [[ $i == 1 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye main non-free contrib

deb https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main

deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib

deb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
if [[ $i == 2 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb https://mirrors.tencent.com/debian/ bullseye main non-free contrib
deb-src https://mirrors.tencent.com/debian/ bullseye main non-free contrib

deb https://mirrors.tencent.com/debian-security/ bullseye-security main
deb-src https://mirrors.tencent.com/debian-security/ bullseye-security main

deb https://mirrors.tencent.com/debian/ bullseye-updates main non-free contrib
deb-src https://mirrors.tencent.com/debian/ bullseye-updates main non-free contrib

deb https://mirrors.tencent.com/debian/ bullseye-backports main non-free contrib
deb-src https://mirrors.tencent.com/debian/ bullseye-backports main non-free contrib
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
if [[ $i == 3 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb https://mirrors.163.com/debian/ bullseye main non-free contrib
deb-src https://mirrors.163.com/debian/ bullseye main non-free contrib

deb https://mirrors.163.com/debian-security/ bullseye-security main
deb-src https://mirrors.163.com/debian-security/ bullseye-security main

deb https://mirrors.163.com/debian/ bullseye-updates main non-free contrib
deb-src https://mirrors.163.com/debian/ bullseye-updates main non-free contrib

deb https://mirrors.163.com/debian/ bullseye-backports main non-free contrib
deb-src https://mirrors.163.com/debian/ bullseye-backports main non-free contrib
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
if [[ $i == 4 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb https://mirrors.huaweicloud.com/debian/ bullseye main non-free contrib
deb-src https://mirrors.huaweicloud.com/debian/ bullseye main non-free contrib

deb https://mirrors.huaweicloud.com/debian-security/ bullseye-security main
deb-src https://mirrors.huaweicloud.com/debian-security/ bullseye-security main

deb https://mirrors.huaweicloud.com/debian/ bullseye-updates main non-free contrib
deb-src https://mirrors.huaweicloud.com/debian/ bullseye-updates main non-free contrib

deb https://mirrors.huaweicloud.com/debian/ bullseye-backports main non-free contrib
deb-src https://mirrors.huaweicloud.com/debian/ bullseye-backports main non-free contrib
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
if [[ $i == 5 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
if [[ $i == 6 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb https://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free

deb https://mirrors.ustc.edu.cn/debian-security/ bullseye-security main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian-security/ bullseye-security main contrib non-free
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
if [[ $i == 7 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free

deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-backports main contrib non-free

deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
if [[ $i == 8 ]];then
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb http://mirrors.linode.com/debian/ bullseye main contrib non-free
deb-src http://mirrors.linode.com/debian/ bullseye main contrib non-free

deb http://mirrors.linode.com/debian/ bullseye-updates main contrib non-free
deb-src http://mirrors.linode.com/debian/ bullseye-updates main contrib non-free

deb http://mirrors.linode.com/debian/ bullseye-backports main contrib non-free
deb-src http://mirrors.linode.com/debian/ bullseye-backports main contrib non-free

deb http://mirrors.linode.com/debian-security/ bullseye-security main contrib non-free
deb-src http://mirrors.linode.com/debian-security/ bullseye-security main contrib non-free
EOF
apt-get clean
apt-get update
apt-get upgrade -y
fi
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list << EOF
deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free

deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-backports main contrib non-free

deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
EOF
apt-get clean
apt-get update
apt-get upgrade -y
sleep 3
menu
}

open_ssh(){
clear
read -p "请输入Root密码并回车（默认yierxm666）:" a
i=$a
sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo root:$i | sudo chpasswd
systemctl restart ssh
sleep 3
menu
}

change_dns(){
clear
echo "
---------[国内]---------
1 - 阿里云   DNS
2 - 百度云   DNS
3 - 腾讯云   DNS
4 - 清华大学 DNS
5 - 114      DNS
6 - 360      DNS
---------[海外]---------
7 - 谷歌       DNS
8 - Cloudflare DNS
"
echo
read -p "请输入对应的数字并回车（默认7）:" a
i=$a
if [[ $i == 1 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 223.5.5.5\nnameserver 223.6.6.6\nnameserver 101.6.6.6" >/etc/resolv.conf;
fi
if [[ $i == 2 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 180.76.76.76\nnameserver 223.5.5.5\nnameserver 101.6.6.6" >/etc/resolv.conf;
fi
if [[ $i == 3 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 119.29.29.29\nnameserver 182.254.116.116\nnameserver 101.6.6.6" >/etc/resolv.conf;
fi
if [[ $i == 4 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 101.6.6.6\nnameserver 223.5.5.5\nnameserver 119.29.29.29" >/etc/resolv.conf;
fi
if [[ $i == 5 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 114.114.114.114\nnameserver 114.114.115.115\nnameserver 223.5.5.5" >/etc/resolv.conf;
fi
if [[ $i == 6 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 101.226.4.6\nnameserver 218.30.118.6\nnameserver 123.125.81.6" >/etc/resolv.conf;
fi
if [[ $i == 7 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 8.8.8.8\nnameserver 8.8.4.4\nnameserver 208.67.222.222" >/etc/resolv.conf;
fi
if [[ $i == 8 ]];then
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 8.8.8.8" >/etc/resolv.conf;
fi
echo -e "options timeout:1 attempts:1 rotate single-request-reopen\nnameserver 8.8.8.8\nnameserver 8.8.4.4\nnameserver 1.1.1.1" >/etc/resolv.conf;
menu
}

install_speedtest(){
clear
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash >/dev/null 2>&1
apt-get install speedtest -y >/dev/null 2>&1
speedtest
}

syn_time(){
clear
echo -e "${Info}正在同步系统时间"
clear
systemctl stop ntp >/dev/null 2>&1
\cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime >/dev/null 2>&1
ntpServer=(
[0]=time.windows.com
[1]=s2m.time.edu.cn
[2]=s1a.time.edu.cn
[3]=s2g.time.edu.cn
[4]=s2k.time.edu.cn
[5]=cn.ntp.org.cn
)
serverNum=`echo ${#ntpServer[*]}`
NUM=0
for (( i=0; i<=$serverNum; i++ )); do
echo -en "正在和NTP服务器 \033[34m${ntpServer[$NUM]} \033[0m 同步中..."
ntpdate ${ntpServer[$NUM]} >> /dev/null 2>&1
if [ $? -eq 0 ]; then
	 echo -e "\t\t\t[  \e[1;32mOK\e[0m  ]"
	 echo -e "当前时间：\033[34m$(date -d "2 second" +"%Y-%m-%d %H:%M.%S")\033[0m"
	 break
else
	 echo -e "\t\t\t[  \e[1;31mERROR\e[0m  ]"
	 let NUM++
fi
sleep 2
done
hwclock --systohc
systemctl start ntp >/dev/null 2>&1
echo -e "${Info}同步完成"
}

m_ipv6(){
clear
echo "
1 - 开启IPv6
2 - 关闭IPv6
"
echo
read -p "请输入对应的数字并回车:" a
i=$a
if [[ $i == 1 ]];then
sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.all.accept_ra/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.default.accept_ra/d' /etc/sysctl.conf

  echo "net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.all.accept_ra = 2
net.ipv6.conf.default.accept_ra = 2" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}IPv6已开启"
fi
if [[ $i == 2 ]];then
sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.conf

  echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}IPv6已关闭"
fi
}

port_ssh(){
# 确定文件路径和特定文本
file_path="/etc/ssh/sshd_config"
search_term="#Port 22"

# 搜索文件并输出结果
if grep -q "$search_term" "$file_path"; then
  read -p "请输入新的SSH端口号：" port

  # 判断端口号是否合法
  if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    echo "端口号必须为数字！"
    exit 1
  fi

  # 修改SSH配置文件
  sed -i "s/#Port 22/Port $port/g" /etc/ssh/sshd_config

  # 重启SSH服务
  systemctl restart sshd

  echo "SSH端口已修改为 $port ，请妥善保管新的端口号！"
  exit 1
else
  # 确定文件路径和特定文本
   file_path="/etc/ssh/sshd_config"
   search_term="Port 22"
   if grep -q "$search_term" "$file_path"; then
   read -p "请输入新的SSH端口号：" port

  # 判断端口号是否合法
  if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    echo "端口号必须为数字！"
    exit 1
  fi

  # 修改SSH配置文件
  sed -i "s/Port 22/Port $port/g" /etc/ssh/sshd_config

  # 重启SSH服务
  systemctl restart sshd

  echo "SSH端口已修改为 $port ，请妥善保管新的端口号！"
  exit 1
  fi
fi
}

menu() {
  clear
  echo && echo -e "逸二VPS管理脚本
  -- Author | 逸二 --
 ${Green_font_prefix} 0.${Font_color_suffix} 更新 脚本
  -------------------
 ${Green_font_prefix} 1.${Font_color_suffix} 安装 SpeedTest
 ${Green_font_prefix} 2.${Font_color_suffix} 安装 Debian11
 ${Green_font_prefix} 3.${Font_color_suffix} 安装 WARP
 ${Green_font_prefix} 4.${Font_color_suffix} 安装 Proxmox
 --------------------
 ${Green_font_prefix} 5.${Font_color_suffix} 更新 Dabian11
 ${Green_font_prefix} 6.${Font_color_suffix} 更新 软件源
 ${Green_font_prefix} 7.${Font_color_suffix} 优化 网络配置
 ${Green_font_prefix} 8.${Font_color_suffix} 同步 网络时间
 --------------------
 ${Green_font_prefix} 9.${Font_color_suffix} 管理 DNS
 ${Green_font_prefix}10.${Font_color_suffix} 管理 IPV6
 ${Green_font_prefix}11.${Font_color_suffix} 管理 ICMP
 ${Green_font_prefix}12.${Font_color_suffix} 管理 SSH
 ${Green_font_prefix}13.${Font_color_suffix} 修改 SSH端口
 --------------------
 ${Green_font_prefix}14.${Font_color_suffix} 检测 流媒体 " && echo
  echo
  read -erp " 请输入数字 [0-14]:" num
  case "$num" in
  0)
    
    ;;
  1)
    install_speedtest
    ;;
  2)
    install_debian11
    ;;
  3)
    install_warp
    ;;
  4)
    install_proxmox
    ;;
  5)
    dabian_apt_update
    ;;
  6)
    exchange_sources
    ;;
  7)
    system_network_optimization
    ;;
  8)
    syn_time
    ;;
  9)
    change_dns
    ;;
  10)
    m_ipv6
    ;;
  11)
    m_icmp
    ;;
  12)
    open_ssh
    ;;
  13)
    port_ssh
    ;;
  14)
    check_tv
    ;;
    *)
    echo "请输入正确数字 [0-13]"
    ;;
  esac
}
check_info
