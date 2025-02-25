ssh-keygen 

read -p "ip" ip_server

 ssh-copy-id -i /root/.ssh/id_rsa.pub root@${ip_server}

 ssh root@${ip_server}