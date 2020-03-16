firewall-cmd --add-service=http --permanent
firewall-cmd --reload
mkdir /etc/www
hostname > /etc/www/index.html
hostname > /etc/www/hostname.txt
uptime >> /etc/www/index.html
cd /etc/www
chmod a+x /etc/rc.d/rc.local
sed -i -e '$i \cat /etc/www/hostname.txt > /etc/www/index.html && uptime >> /etc/www/index.html\n' /etc/rc.d/rc.local
sed -i -e '$i \cd /etc/www && python -m SimpleHTTPServer 80 &\n' /etc/rc.d/rc.local
python -m SimpleHTTPServer 80 &