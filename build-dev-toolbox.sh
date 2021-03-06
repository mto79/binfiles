#!/bin/sh
set -eux
NAME=dev-toolbox
TOOLBOX_RELEASE=31

if [ -n "${TOOLBOX_RELEASE:-}" ]; then
    RELEASE="--release $TOOLBOX_RELEASE"
    NAME="$NAME-$TOOLBOX_RELEASE"
else
    RELEASE=''
fi

toolbox rm --force $NAME || true
toolbox create $RELEASE -c $NAME
toolbox run -c "$NAME" sh -exec '\
sudo echo "dev-toolbox.mto.local" | sudo tee /etc/hostname
sudo hostname -F /etc/hostname

sudo dnf install -y make npm fontconfig git chromium-headless \
    libvirt-daemon-kvm libvirt-client python3-libvirt \
    virt-viewer libappstream-glib \
    expect python3-pycodestyle python3-pyflakes python-ovirt-engine-sdk4 \
    fedpkg /usr/bin/oc /usr/bin/genisoimage \
    man-pages socat wget genisoimage vim-enhanced \
    ansible rsync rxvt-unicode pre-commit go \
    fcct nmap jq pass hugo

#yes | sudo curl -fsSL https://starship.rs/install.sh | bash

sudo dnf -y install gvim vim htop pngquant optipng cargo fish hub \
	waifu2x-converter-cpp the_silver_searcher iperf3

CM_VER="2.0.11"
sudo dnf install -y https://github.com/twpayne/chezmoi/releases/download/v${CM_VER}/chezmoi-${CM_VER}-x86_64.rpm

PAC_VER="1.7.2"
sudo wget -O ~/Downloads/packer_${PAC_VER}_linux_amd64.zip https://releases.hashicorp.com/packer/${PAC_VER}/packer_${PAC_VER}_linux_amd64.zip
sudo unzip ~/Downloads/packer_${PAC_VER}_linux_amd64.zip -d ~/Downloads
sudo mv ~/Downloads/packer /usr/local/bin/

sudo dnf install -y vagrant

TER_VER="0.15.1"
sudo wget -O ~/Downloads/terraform_${TER_VER}_linux_amd64.zip https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
sudo unzip ~/Downloads/terraform_${TER_VER}_linux_amd64.zip -d ~/Downloads
sudo mv ~/Downloads/terraform /usr/local/bin/

type gh >/dev/null 2>&1 || sudo dnf install -y $(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep -o https:.*_linux_amd64.rpm)

KUB_VER="1.21.0"
sudo wget -O ~/Downloads/kubectl https://dl.k8s.io/release/v${KUB_VER}/bin/linux/amd64/kubectl
sudo mv ~/Downloads/kubectl /usr/local/bin/kubectl
sudo chown root.root /usr/local/bin/kubectl
sudo chmod 755 /usr/local/bin/kubectl

sudo dnf clean packages
'
