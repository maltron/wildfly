FROM tomcat:7-jre7-alpine
MAINTAINER fabio

ENV user=tomcat \
    group=tomcat \
    uid=1001 \
    gid=501

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="Tomcat using Alpine's Linux with OpenJDK" \
    io.k8s.display-name="alpine" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,webserver,java" \
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble, save-artifacts)
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

RUN addgroup -S ${group} -g ${gid} && \
    adduser -u ${uid} -S -G ${group} -D ${user} && \
    chown -R tomcat:tomcat /usr/local/tomcat && \
    mkdir -p /usr/local/tomcat/logs && \
    chmod -R 777 /usr/local/tomcat/conf /usr/local/tomcat/webapps /usr/local/tomcat/logs && \
### Create all the necessary scripts for S2I and give the proper permissions
    mkdir -p /usr/libexec/s2i && \
    printf "#!/bin/sh\n\
mv /tmp/src/*.war /usr/local/tomcat/webapps" > /usr/libexec/s2i/assemble && \
    printf "#!/bin/sh\n\
catalina.sh run\n" > /usr/libexec/s2i/run && \
    chmod 755 /usr/libexec/s2i/*

EXPOSE 8080
USER ${uid}
