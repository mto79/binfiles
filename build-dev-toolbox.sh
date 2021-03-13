#!/bin/sh
set -eux
NAME=dev-toolbox

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
    ansible rsync rxvt-unicode-256color pre-commit go 

sudo curl -fsSL https://starship.rs/install.sh | bash

sudo dnf -y install gvim vim htop pngquant optipng cargo fish hub \
	waifu2x-converter-cpp the_silver_searcher iperf3

PAC_VER="1.7.0"
sudo wget -O ~/Downloads/packer_${PAC_VER}_linux_amd64.zip https://releases.hashicorp.com/packer/${PAC_VER}/packer_${PAC_VER}_linux_amd64.zip
sudo unzip ~/Downloads/packer_${PAC_VER}_linux_amd64.zip -d ~/Downloads
sudo mv ~/Downloads/packer /usr/local/bin/

sudo dnf install -y vagrant

TER_VER="0.14.8"
sudo wget -O ~/Downloads/terraform_${TER_VER}_linux_amd64.zip https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
sudo unzip ~/Downloads/terraform_${TER_VER}_linux_amd64.zip -d ~/Downloads
sudo mv ~/Downloads/terraform /usr/local/bin/

type gh >/dev/null 2>&1 || sudo dnf install -y $(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep -o https:.*_linux_amd64.rpm)

sudo dnf clean packages
'