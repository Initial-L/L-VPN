#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/arzvpn/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m" 
export COLOR1="$(cat /etc/arzvpn/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/arzvpn/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )


BURIQ () {
    curl -sS https://raw.githubusercontent.com/Initial-L/WhoIsL/main/Kira > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/Initial-L/WhoIsL/main/Kira | grep $MYIP | awk '{print $2}')
Isadmin=$(curl -sS https://raw.githubusercontent.com/Initial-L/WhoIsL/main/Kira | grep $MYIP | awk '{print $5}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/Initial-L/WhoIsL/main/Kira | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

x="ok"


PERMISSION

if [ "$res" = "Expired" ]; then
Exp="\e[36mExpired\033[0m"
rm -f /home/needupdate > /dev/null 2>&1
else
Exp=$(curl -sS https://raw.githubusercontent.com/Initial-L/WhoIsL/main/Kira | grep $MYIP | awk '{print $3}')
fi
export RED='\033[0;31m'
export GREEN='\033[0;32m'

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${GREEN}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi

# // nginx
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# // SSH Websocket Proxy
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi

function add-host(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               •ADD VPS HOST•                ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
read -rp "  New Host Name : " -e host
echo ""
if [ -z $host ]; then
echo -e "  [INFO] Type Your Domain/sub domain"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
else
echo "IP=$host" > /var/lib/arzvpn-pro/ipvps.conf
echo ""
echo "  [INFO] Dont forget to renew cert"
echo ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to Renew Cret"
crtxray
fi
}
function updatews(){
clear

echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}              •UPDATE SCRIPT VPS•              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Check for Script updates"
sleep 2
wget -q -O /root/install_up.sh "https://raw.githubusercontent.com/arzvpn/update/main/install_up.sh" && chmod +x /root/install_up.sh
sleep 2
./install_up.sh
sleep 5
rm /root/install_up.sh
rm /opt/.ver
version_up=$( curl -sS https://raw.githubusercontent.com/arzvpn/update/main/version_up)
echo "$version_up" > /opt/.ver
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Successfully Up To Date!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}               •Arz-VPN-STORE•              $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}                  •MENU UTAMA•                 ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )
serverV=$( curl -sS https://raw.githubusercontent.com/arzvpn/permission/main/version)
if [ "$Isadmin" = "ON" ]; then
uis="${GREEN}XRAY Arz V1$NC"
else
uis="${BLUE}XRAY Arz V1$NC"
fi
echo -e "$COLOR1│$NC Premium Version  : $uis"
if [ "$cekup" = "day" ]; then
echo -e "$COLOR1│$NC System Uptime    : $uphours $upminutes $uptimecek"
else
echo -e "$COLOR1│$NC System Uptime    : $uphours $upminutes"
fi
echo -e "$COLOR1│$NC Memory Usage     : $uram / $tram"
echo -e "$COLOR1│$NC ISP & City       : $ISP & $CITY"
echo -e "$COLOR1│$NC Current Domain   : $(cat /etc/xray/domain)"
echo -e "$COLOR1│$NC IP-VPS           : ${COLOR1}$IPVPS${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┏─━─━─━─━─━─━─━─━─━─━─━─━─━─━─━∞◆∞━─━─━─━─━─━─━─━─━─━─━─━─━─━─┓${NC}"
echo -e "$COLOR1│$NC [ SSH WEBSOCKET : ${status_ws} ]  [ XRAY : ${status_xray} ]   [ NGINX : ${status_nginx} ]      $COLOR1│$NC"
echo -e "$COLOR1┗─━─━─━─━─━─━─━─━─━─━─━─━─━─━─━∞◆∞━─━─━─━─━─━─━─━─━─━─━─━─━─━─┛${NC}"
echo -e "$COLOR1╔─━━━━━━━━━━━━━━━━━━━━━━━━━━━━━░★░━━━━━━━━━━━━━━━━━━━━━━━━━━━─╗${NC}"
echo -e "  ${COLOR1}[1]${NC}  • SSH(${COLOR1}menu-ssh${NC})  "   
echo -e "  ${COLOR1}[2]${NC}  • VMESS(${COLOR1}menu-vmess${NC}) "  
echo -e "  ${COLOR1}[3]${NC}  • VLESS(${COLOR1}menu-vless${NC}) "  
echo -e "  ${COLOR1}[4]${NC}  • TROJAN WS(${COLOR1}menu-trojan${NC}) "  
echo -e "  ${COLOR1}[5]${NC}  • SHADOWSOCKS WS(${COLOR1}menu-ss${NC})  "
echo -e "  ${COLOR1}[6]${NC}  • ADD HOST/DOMAIN(${COLOR1}add-host${NC}) "
echo -e "  ${COLOR1}[7]${NC}  • RENEW CERT/GEN SSL(${COLOR1}crtxray${NC}) "
echo -e "  ${COLOR1}[8]${NC}  • BACKUP(${COLOR1}menu-backup${NC}) "
echo -e "  ${COLOR1}[9]${NC}  • THEME(${COLOR1}menu-theme${NC}) "
echo -e "  ${COLOR1}[10]${NC} • SETTINGS(${COLOR1}menu-set${NC}) "
echo -e "  ${COLOR1}[11]${NC} • INFO AUTOSCRIPT(${COLOR1}info${NC}) "
echo -e "$COLOR1╚─━━━━━━━━━━━━━━━━━━━━━━━━━━━━░★░━━━━━━━━━━━━━━━━━━━━━━━━━━─╝${NC}"
myver="$(cat /opt/.ver)"

if [[ $serverV > $myver ]]; then
echo -e "$RED┌─────────────────────────────────────────────────┐${NC}"
echo -e "$RED│$NC ${COLOR1}[100]${NC} • UPDATE TO V$serverV" 
echo -e "$RED└─────────────────────────────────────────────────┘${NC}"
up2u="updatews"
else
up2u="menu"
fi

DATE=$(date +'%d %B %Y')
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo -e "$COLOR1│$NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""

echo -e "$COLOR1┌─────────────────────────────────────────────────┐$NC"
echo -e "$COLOR1│$NC Version     :${COLOR1} $(cat /opt/.ver) Last Version${NC}"
echo -e "$COLOR1│$NC Client Name : $Name"
if [ $exp \< 1000 ];
then
echo -e "$COLOR1│$NC License     : ${GREEN}$sisa_hari$NC Days Tersisa $NC"
else
    datediff "$Exp" "$DATE"
fi;
echo -e "$COLOR1└─────────────────────────────────────────────────┘$NC"
echo -e "$COLOR1╔═══════════════════ ≪ •❈• ≫ ═══════════════════╗${NC}"
echo -e "$COLOR1❚${NC}                •Arz-VPN-STORE•                $COLOR1❚$NC"
echo -e "$COLOR1╚═══════════════════ ≪ •❈• ≫ ═══════════════════╝${NC}" 
echo -e ""
echo -ne " Select menu : "; read opt
case $opt in
01 | 1) clear ; menu-ssh ;;
02 | 2) clear ; menu-vmess ;;
03 | 3) clear ; menu-vless ;;
04 | 4) clear ; menu-trojan ;;
05 | 5) clear ; menu-ss ;;
06 | 6) clear ; add-host ;;
06 | 7) clear ; crtxray ;;
07 | 8) clear ; menu-backup ;;
09 | 9) clear ; menu-theme ;;
10) clear ; menu-set ;;
11) clear ; info ;;
100) clear ; $up2u ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
