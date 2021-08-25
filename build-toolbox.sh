#!/bin/sh
set -eux
NAME=mto-toolbox
TOOLBOX_RELEASE=34

if [ -n "${TOOLBOX_RELEASE:-}" ]; then
    RELEASE="--release $TOOLBOX_RELEASE"
    NAME="$NAME-$TOOLBOX_RELEASE"
else
    RELEASE=''
fi

toolbox rm --force $NAME || true
toolbox create $RELEASE -c $NAME
toolbox run -c "$NAME" sh -exec '\
sudo echo "mto-toolbox" | sudo tee /etc/hostname
sudo hostname -F /etc/hostname

sudo dnf install -y git wget \
    ansible rsync pre-commit go \
    fish neovim starship bash-completion fcct nmap jq pass hugo npm kpcli

CM_VER="2.1.5"
sudo dnf install -y https://github.com/twpayne/chezmoi/releases/download/v${CM_VER}/chezmoi-${CM_VER}-x86_64.rpm

#chezmoi init
#chezmoi cd
#git branch --show-current
#git branch -m main
#git branch --show-current
#git config --local init.defaultBranch main
#git remote add origin https://github.com/mto79/dotfiles.git
#git config --global user.email "marc@mto.nu"
#git config --global user.name "mto"

#DUP_VER="2.0.6.3-2.0.6.3_beta_20210617"
#sudo dnf install -y mono-core
#sudo dnf install -y https://updates.duplicati.com/beta/duplicati-${DUP_VER}.noarch.rpm
#sudo cert-sync --user /etc/pki/tls/certs/ca-bundle.crt

#PAC_VER="1.7.2"
#sudo wget -O ~/Downloads/packer_${PAC_VER}_linux_amd64.zip https://releases.hashicorp.com/packer/${PAC_VER}/packer_${PAC_VER}_linux_amd64.zip
#sudo unzip ~/Downloads/packer_${PAC_VER}_linux_amd64.zip -d ~/Downloads
#sudo mv ~/Downloads/packer /usr/local/bin/

#sudo dnf install -y vagrant

#TER_VER="0.15.1"
##sudo wget -O ~/Downloads/terraform_${TER_VER}_linux_amd64.zip https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
#sudo unzip ~/Downloads/terraform_${TER_VER}_linux_amd64.zip -d ~/Downloads
#sudo mv ~/Downloads/terraform /usr/local/bin/


#KUB_VER="1.21.0"
#sudo wget -O ~/Downloads/kubectl https://dl.k8s.io/release/v${KUB_VER}/bin/linux/amd64/kubectl
#sudo mv ~/Downloads/kubectl /usr/local/bin/kubectl
#sudo chown root.root /usr/local/bin/kubectl
#sudo chmod 755 /usr/local/bin/kubectl

sudo dnf clean packages
'
