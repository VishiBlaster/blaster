# installation commands for the vulnerable machine blasters
# do not run this machine in your local network without monitoring it
# user password : Naarut00_(!s)_Th33Go@@t$$

echo -e "\e[1;31m updating repos \e[0m" 
apt update

echo -e "\e[1;31m installing apache \e[0m" 
apt install -y apache2

echo -e "\e[1;31m [+] installing and configuring ftp \e[0m"
apt install -y vsftpd
sudo ufw allow 20
sudo ufw allow 21
mkdir /var/ftp
chown nobody:nogroup /var/ftp
sudo cp /etc/vsfpd.conf /etc/vsftpd.conf.bak
sed -i 's/anonymous_enable=NO/anonymous_enable=Yes/' /etc/vsftpd.conf
echo "anon_root=/var/ftp/" >> /etc/vsftpd.conf
systemctl restart vsftpd

echo -e "\e[1;31m [+] installing and configuring ssh \e[0m"
apt install openssh-server -y
ufw allow ssh

echo -e "\e[1;31m [+] moving the binary to ftp \e[0m"
mv /root/data/backup.zip /var/ftp/backup.zip
chown nobody:nogroup /var/ftp/backup.zip



# add user manager
echo -e "\e[1;31m [+] adding user manager \e[0m"
useradd -m manager
echo manager:'password123' | sudo chpasswd

# priv esc
echo -e "\e[1;31m [+] adding privilege escalation vector \e[0m"
apt install -y gcc
echo 'int main() {setgid(0);setuid(0);system("wget http:/\/localhost:80");return 0;}' > /home/manager/crawler.c
gcc /home/manager/crawler.c -o /home/manager/crawler
chmod 644 /home/manager/crawler.c
chmod u+s /home/manager/crawler

# cleanup
echo -e "\e[1;31m [+] CLEANING UP \e[0m"

echo "[+] Disabling IPv6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
update-grub

echo "[+] Configuring hostname"
hostnamectl set-hostname blasters
cat << EOF > /etc/hosts
127.0.0.1 localhost
127.0.0.1 blasters
EOF

echo "[+] Disabling history files"
ln -sf /dev/null /root/.bash_history
ln -sf /dev/null /home/manager/.bash_history

echo "[+] Enabling root SSH login"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

echo "[+] Setting passwords"
echo "root:IamPrettySecure" | sudo chpasswd

echo "[+] Dropping flags"
echo "ca742c7ad27d517527f49531c02f76b8" > /root/root.txt
echo "9f1642b69b2a23aca3c5863e3f1ffd92" > /home/manager/user.txt
chmod 0600 /root/root.txt
chmod 0644 /home/manager/user.txt
chown manager:manager /home/manager/user.txt 

echo "[+] Cleaning up"
rm -rf /root/install.sh
rm -rf /root/.cache
rm -rf /root/.viminfo
rm -rf /home/manager/.sudo_as_admin_successful
rm -rf /home/manager/.cache
rm -rf /home/manager/.viminfo
find /var/log -type f -exec sh -c "cat /dev/null > {}" \;