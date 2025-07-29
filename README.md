GITLAB + PORTAINER
docker-compose up -d

HARBOR
mkdir harbor
cd harbor/
wget -c https://github.com/goharbor/harbor/releases/download/v2.13.1/harbor-offline-installer-v2.13.1.tgz
tar xzfv harbor-offline-installer-v2.13.1.tgz 
cd harbor/
sudo ./install.sh --with-trivy

OPTIONAL
sudo setfacl -R -d -m u:10000:rwx /workspaces/ghps/mnt/nfs/harbor 
sudo setfacl -R -m u:10000:rwx /workspaces/ghps/mnt/nfs/harbor 
sudo setfacl -R -m u:codespace:rwx /workspaces/ghps/mnt/nfs/harbor 
sudo setfacl -R -d -m u:codespace:rwx /workspaces/ghps/mnt/nfs/harbor
