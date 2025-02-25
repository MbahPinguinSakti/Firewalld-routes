dnf install mod_security mod_security_crs -y
echo "config /etc/httpd/modsecurity.d/ dan modsecurity.conf, change it to: SecRuleEngine On"
dnf install httpd
echo "konfig /etc/httpd/conf.d/mod_evasive.conf"

dnf groupinstall "Development Tools" -y && dnf install httpd-devel apr-devel apr-util-devel redhat-rpm-config
git clone https://github.com/shivaas/mod_evasive.git
apxs -i -a -c mod_evasive24.c

touch /etc/httpd/conf.d/mod_evasive.conf

echo '<IfModule mod_evasive24.c>
    DOSHashTableSize    3097
    DOSPageCount        2
    DOSSiteCount        50
    DOSPageInterval     1
    DOSSiteInterval     1
    DOSBlockingPeriod   10
    DOSEmailNotify      youremail@example.com
    DOSSystemCommand    "sudo /usr/bin/logger -t mod_evasive -p local6.info"
    DOSLogDir           "/var/log/mod_evasive"
</IfModule>' >> /etc/httpd/conf.d/mod_evasive.conf

mkdir /var/log/mod_evasive

chown apache:apache /var/log/mod_evasive

systemctl restart httpd