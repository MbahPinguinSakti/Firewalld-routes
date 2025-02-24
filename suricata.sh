dnf install epel-release git php php-gd php-mysqlnd -y
cd /var/www/html
git clone https://github.com/digininja/dvwa 
chown -R root:root /var/www/html/dvwa
cp /var/www/html/dvwa/config/config.inc.php.dist /var/www/html/dvwa/config/config.inc.php 

dnf install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

mysql -u root -e "create database dvwa" 
mysql -u root -e "create user 'dvwa'@'localhost' identified by '123'" 
mysql -u root -e "grant all on dvwa.* to 'dvwa'@'localhost'" 
mysql -u root -e "flush privileges"

echo "jangan lupa setting config.inc.php setelah itu restart httpd"
systemctl restart httpd
systemctl status httpd  

echo "buka port 80"

setsebool -P httpd_can_network_connect_db 1

echo "installing suricata"

dnf install suricata -y || { echo "Instalasi Suricata gagal"; exit 1; }

touch /etc/suricata/rules/sqli-xss-sshb.rules


sqli1=' alert tcp any any -> any 80 (msg: "Error Based SQL Injection Detected"; content: "%27"; sid: 100000011; )'
sqli2=' alert tcp any any -> any 80 (msg: "Error Based SQL Injection Detected"; content: "22"; sid: 100000012; )'
sqli3=' alert tcp any any -> any 80 (msg: "AND SQL Injection Detected"; content: "and"; nocase; sid: 100000060;)' 
sqli4=' alert tcp any any -> any 80 (msg: "OR SQL Injection Detected"; content: "or"; nocase; sid:100000061; )'


xss='alert tcp any any -> any 80 (msg: "XSS Attack Detected"; content: "<script>"; http_uri; content: "</script>"; http_uri; flow:to_server; sid: 10000301; rev:1;)'

sshb='alert tcp any any -> any 22 (msg:"SSH Bruteforce Attempt"; flow:to_server,established; detection_filter: track by_src, count 5, seconds 60; classtype:attempted-dos; sid:1000003; rev:1;)'

sed -i s/suricata.rules/sqli-xss-sshb.rules /etc/suricata/suricata.yaml

echo "${sqli1}" >> "/etc/suricata/rules/sqli-xss-sshb.rules"
echo "${sqli2}" >> "/etc/suricata/rules/sqli-xss-sshb.rules"
echo "${sqli3}" >> "/etc/suricata/rules/sqli-xss-sshb.rules"
echo "${xss}" >> "/etc/suricata/rules/sqli-xss-sshb.rules"
echo "${sshb}" >> "/etc/suricata/rules/sqli-xss-sshb.rules"

read -p "interface: " adapter

sed -i s/eth0/${adapter} /etc/sysconfig/suricata