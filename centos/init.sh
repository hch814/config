# centos基本配置安装
# basic
sudo echo "hch-centos" > /etc/hostname
sudo yum install -y vim
sudo yum install -y git
sudo yum install -y gcc
sudo yum install -y rsync
sudo yum install -y net-tools

# java
sudo yum install -y maven

# docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
sudo systemctl enable docker
sudo usermod -aG docker hch
