# centos基本配置安装
# basic
sudo echo "hch-centos" > /etc/hostname
sudo yum install -y vim
sudo yum install -y git
sudo yum install -y gcc
sudo yum install -y rsync
sudo yum install -y net-tools
sudo yum install -y wget
sudo yum install -y curl
sudo yum install -y zip unzip
sudo yum install -y avahi
sudo yum install -y sysstat
sudo curl -O https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/n/nss-mdns-0.14.1-9.el7.x86_64.rpm
sudo yum install ./nss-mdns-0.14.1-9.el7.x86_64.rpm

# firewall
sudo firewall-cmd --add-port=80/tcp --add-port=8080/tcp --add-port=8000/tcp --add-port=5353/udp --permanent


# java
sudo yum install -y maven

# docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
sudo systemctl enable docker
sudo usermod -aG docker hch
