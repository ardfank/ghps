```
GITLAB + PORTAINER + SONARQUBE
    docker-compose up -d

    SONARQUBE OPTION
    user ID 1000:1000
    sysctl -w vm.max_map_count=524288
    sysctl -w fs.file-max=131072
    ulimit -n 131072
    ulimit -u 8192


HARBOR  
    mkdir harbor
    cd harbor/
    wget -c https://github.com/goharbor/harbor/releases/download/v2.13.1/harbor-offline-installer-v2.13.1.tgz
    tar xzfv harbor-offline-installer-v2.13.1.tgz 
    cd harbor/
    sudo ./install.sh --with-trivy

    HARBOR OPTIONAL
    sudo setfacl -R -d -m u:10000:rwx /workspaces/ghps/mnt/nfs/harbor 
    sudo setfacl -R -m u:10000:rwx /workspaces/ghps/mnt/nfs/harbor 
    sudo setfacl -R -m u:codespace:rwx /workspaces/ghps/mnt/nfs/harbor 
    sudo setfacl -R -d -m u:codespace:rwx /workspaces/ghps/mnt/nfs/harbor
```