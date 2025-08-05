[![ Gitlab-CE, Portainer, Sonarqube and Harbor on Github Codespace in 30 minutes ](https://img.youtube.com/vi/-qFsZfMLyNc/maxresdefault.jpg)](https://www.youtube.com/watch?v=-qFsZfMLyNc)

```
GITLAB + PORTAINER + SONARQUBE
    docker-compose up -d

    SONARQUBE OPTION
    user ID 1000:1000
    vm.max_map_count=524288
    fs.file-max=131072
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



NOTES:
/data/gitlab/config          -> /etc/gitlab             (EBS)
/data/gitlab/data            -> /var/opt/gitlab         (EBS)
/data/gitlab/logs            -> /var/log/gitlab         (EFS)

#/ Harbor
/data/harbor/data            -> /data                   (EFS)
/data/harbor/database        -> PostgreSQL volume       (EBS)
/data/harbor/redis           -> Redis volume            (EBS)

#/ SonarQube
/data/sonar/data             -> /opt/sonarqube/data     (EBS)
/data/sonar/extensions       -> /opt/sonarqube/extensions (EFS)
/data/sonar/logs             -> /opt/sonarqube/logs     (EFS)

#/ Portainer
/data/portainer              -> /data                   (EFS)

OPTIONAL CODESPACE:
  sudo fallocate -l 16G /tmp/swap
  sudo chmod 600 /tmp/swap
  sudo mkswap /tmp/swap
  sudo swapon /tmp/swap

  sudo setfacl -R -d -m u:10000:rwx /mnt/local
  sudo setfacl -R -d -m u:1000:rwx /mnt/local
  sudo setfacl -R -d -m u:999:rwx /mnt/local
  sudo setfacl -R -d -m u:10000:rwx /mnt/nfs
  sudo setfacl -R -d -m u:1000:rwx /mnt/nfs
  sudo setfacl -R -d -m u:999:rwx /mnt/nfs

  sudo setfacl -R -m u:10000:rwx /mnt/local
  sudo setfacl -R -m u:1000:rwx /mnt/local
  sudo setfacl -R -m u:999:rwx /mnt/local
  sudo setfacl -R -m u:10000:rwx /mnt/nfs
  sudo setfacl -R -m u:1000:rwx /mnt/nfs
  sudo setfacl -R -m u:999:rwx /mnt/nfs
```
