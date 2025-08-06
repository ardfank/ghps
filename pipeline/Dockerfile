FROM ubuntu:24.04

LABEL maintainer="orlando.curieles@ingeint.com"

ENV IDEMPIERE_VERSION 12
ENV IDEMPIERE_HOME /opt/idempiere
ENV IDEMPIERE_PLUGINS_HOME $IDEMPIERE_HOME/plugins
ENV IDEMPIERE_LOGS_HOME $IDEMPIERE_HOME/log
# ENV IDEMPIERE_BUILD https://sourceforge.net/projects/idempiere/files/v12/server/idempiereServer12.gtk.linux.x86_64.zip

WORKDIR $IDEMPIERE_HOME

RUN apt-get update && \
    apt-get install -y --no-install-recommends nano postgresql-client openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/*

COPY . .

RUN ln -s $IDEMPIERE_HOME/idempiere-server.sh /usr/bin/idempiere

COPY docker-entrypoint.sh $IDEMPIERE_HOME

RUN chmod +x docker-entrypoint.sh 

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["idempiere"]
