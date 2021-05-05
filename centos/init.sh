# centos基本配置安装
set -e
# 主机名修改
modify_hostname(){
    read -p "modify hostname? {YOUR_HOSTNAME}/n(o) " hostname
    if [[ -z $hostname || "n" == $hostname || "no" == $hostname ]]; then
        echo "skip modify_hostname..."
    return
    fi
    echo $hostname > /etc/hostname
}

# 基础软件
install_basic_software(){
    read -p "install basic software? y/n(o) " ibs
    if [[ -z $ibs || "n" == $ibs || "no" == $ibs ]]; then
        echo "skip install_basic_software..."
    return
    fi

    yum install -y vim
    yum install -y git
    yum install -y gcc
    yum install -y rsync
    yum install -y net-tools
    yum install -y wget
    yum install -y curl
    yum install -y zip unzip
    yum install -y sysstat
    yum install -y avahi
    mkdir -p /usr/local/opt && cd /usr/local/opt
    wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/n/nss-mdns-0.14.1-9.el7.x86_64.rpm
    yum install -y ./nss-mdns-0.14.1-9.el7.x86_64.rpm
    rm ./nss-mdns-0.14.1-9.el7.x86_64.rpm
    wget https://github.com/fatedier/frp/releases/download/v0.36.2/frp_0.36.2_linux_amd64.tar.gz
    tar -xzvf frp_0.36.2_linux_amd64.tar.gz
    rm ./frp_0.36.2_linux_amd64.tar.gz

    # network & firewall
    firewall-cmd --add-port=80/tcp --add-port=8080/tcp --add-port=8000/tcp --add-port=5353/udp --permanent
    firewall-cmd --reload
    systemctl enable avahi-daemon
    systemctl start avahi-daemon
}

# k8s安装
install_k8s(){
    read -p "install k8s? master/node/n(o) " ik
    while [[ "master" != $ik && "node" != $ik && "n" != $ik && "no" != $ik ]]; do
        read -p "install k8s? master/node/n(o) " ik
    done
    if [[ "n" == $ik || "no" == $ik ]]; then
        echo "skip install_k8s..."
    return
    fi

    # 关闭防火墙 永久禁用交换分区
    systemctl stop firewalld && systemctl disable firewalld
    swapoff -a
    sed -i 's/.*swap.*/#&/' /etc/fstab

    # 允许容器访问主机文件系统
    setenforce 0
    sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

    # 修改内核参数，允许 iptables 检查桥接流量
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

    sysctl --system

    # 安装docker
    yum install -y yum-utils
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum install -y docker-ce-19.03.8-3.el7
    systemctl start docker && systemctl enable docker

    # 执行配置k8s阿里云源，安装kubeadm、kubectl、kubelet
    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

    yum install -y kubeadm-1.18.0-0 kubelet-1.18.0-0
    systemctl enable kubelet && systemctl start kubelet

    if [[ $ik == "master" ]]; then
        yum install -y kubectl-1.18.0-0

        # master初始化
        kubeadm init --kubernetes-version=v1.18.0 \
        --pod-network-cidr=10.244.0.0/16 \
        --service-cidr=10.1.0.0/16 \
        --image-repository=registry.aliyuncs.com/google_containers
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        kubectl apply -f kube-flannel.yml
    fi

    if [[ $ik == "node" ]]; then
        echo please join master!
    fi
}

main(){
    modify_hostname
    install_basic_software
    install_k8s
}

main