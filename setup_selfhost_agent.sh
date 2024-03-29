#!/bin/bash
agentuser="<<--devops user account email--->>"
pool="aks-private-pool"
pat="--your pat token--"
azdourl="--azure devops project url--"

# install az cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# install docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker $agentuser

# install kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt-get install -y kubectl

# install helm
curl -o helm.tar.gz https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz
tar zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64
rm -f helm.tar.gz

# download azdo agent
mkdir -p /opt/azdo && cd /opt/azdo
cd /opt/azdo
curl -o azdoagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.175.2/vsts-agent-linux-x64-2.175.2.tar.gz
tar xzvf azdoagent.tar.gz
rm -f azdoagent.tar.gz

# configure as azdouser
chown -R $agentuser /opt/azdo
chmod -R 755 /opt/azdo
runuser -l selfhost-admin -c "/opt/devopsagent/config.sh --unattended --url $azdourl --auth pat $pat --token  --pool $pool --acceptTeeEula"


sudo ./config.sh --unattended --url $azdourl --auth pat $pat --token  --pool $pool --acceptTeeEula"
# install and start the service
./svc.sh install
./svc.sh start