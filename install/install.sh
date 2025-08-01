#!/bin/bash
export NFS_DIR="/mnt/local"
export LOCAL_DIR="/mnt/local"
export GITLAB_DOMAIN="gitlab.test.id"
export HARBOR_CONFIG="/mnt/local/harbor_config"
export HARBOR_DOMAIN="localhost"

set -e
### Download extract harbor
mkdir -p $HARBOR_CONFIG
mkdir -p $LOCAL_DIR/sonar/{sonarqube_data,sonarqube_extensions,sonarqube_logs,sonarqube_temp}
chown 1000:1000 $LOCAL_DIR/sonar/sonarqube* -R
chown 1000:1000 $NFS_DIR/sonar/sonarqube* -R
wget -c -nc https://github.com/goharbor/harbor/releases/download/v2.13.1/harbor-offline-installer-v2.13.1.tgz
tar -zxvf harbor-offline-installer-v2.13.1.tgz -C "$HARBOR_CONFIG" --strip-components=1
envsubst < harbor.yml > $HARBOR_CONFIG/harbor.yml
$HARBOR_CONFIG/prepare --with-trivy

### Generate compose
envsubst < compose.txt > docker-compose.yml
docker-compose -f docker-compose.yml up -d
