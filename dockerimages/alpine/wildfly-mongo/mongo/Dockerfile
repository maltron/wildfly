FROM alpine:latest
MAINTAINER Mauricio "Maltron" Leal <maltron@gmail.com>

LABEL io.k8s.description="MongoDB is a scalable, high-performance, open source NoSQL database." \
      io.k8s.display-name="MongoDB 3.2" \
      io.openshift.expose-services="27017:mongodb" \
      io.openshift.tags="database,mongodb,mongodb32" \
      # this label tells s2i where to find its mandatory scripts
      # (run, assemble, save-artifacts)
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

ENV MONGO_HOME=/var/lib/mongodb \
    GROUP_ID=1001 \
    USER_ID=1001 \
    USER=mongo \
    MONGODB_VERSION=3.2 \
    # Set paths to avoid hard-coding them in scripts.
    #HOME=/var/lib/mongodb \
    CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/mongodb \
    # Incantations to enable Software Collections on `bash` and `sh -i`.
    ENABLED_COLLECTIONS=rh-mongodb32 \
    BASH_ENV="\${CONTAINER_SCRIPTS_PATH}/scl_enable" \
    ENV="\${CONTAINER_SCRIPTS_PATH}/scl_enable" \
    PROMPT_COMMAND=". \${CONTAINER_SCRIPTS_PATH}/scl_enable"

###  Add some of the scripts
ADD root /

### Create a user and group
RUN addgroup -S ${USER} -g ${GROUP_ID} && \
    adduser -u ${USER_ID} -S -G ${USER} -h ${MONGO_HOME} ${USER} && \
    chmod 755 -R ${MONGO_HOME} && \
### Data Directory
    mkdir -p ${MONGO_HOME}/data && chown -R mongo:mongo ${MONGO_HOME}/data && \
### Upgrade all the packages and install all the necessary ones
    apk upgrade --update && \
### MongoDB
    echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --no-cache mongodb && \
    rm /usr/bin/mongosniff /usr/bin/mongoperf && \
    touch /etc/mongod.conf && chown mongodb:0 /etc/mongod.conf && /usr/libexec/fix-permissions /etc/mongod.conf && \
### Create all the necessary scripts for S2I and give the proper permissions
    mkdir -p /usr/libexec/s2i && \
#    printf "#!/bin/sh\n\
#mv /tmp/src/*.war /usr/local/tomcat/webapps" > /usr/libexec/s2i/assemble && \
    printf "#!/bin/sh\n\
mongod --dbpath /var/lib/mongodb/data\n" > /usr/libexec/s2i/run && \
    chmod 755 /usr/libexec/s2i/*

VOLUME ${MONGO_HOME}/data
EXPOSE 27017
WORKDIR ${MONGO_HOME}
USER mongo
#CMD ["mongod","--dbpath","/var/lib/mongodb/data"]
#ENTRYPOINT ["container-entrypoint"]
#CMD ["run-mongod"]
