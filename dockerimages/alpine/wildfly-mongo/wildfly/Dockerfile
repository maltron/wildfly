FROM anapsix/alpine-java:jre8
MAINTAINER Mauricio "Maltron" Leal <maltron@gmail.com>

ENV JBOSS_HOME=/opt/java/server/as/wildfly \
    GROUP_ID=1001 \
    USER_ID=1001 \
    USER=wildfly \
    WILDFLY_VERSION=10.1.0.Final

RUN addgroup -S ${USER} -g ${GROUP_ID} && adduser -u ${USER_ID} -S -G ${USER} -h /home/${USER} ${USER} && chmod 755 /home/${USER} && \
    apk upgrade --update && apk add --update libstdc++ curl bash && \
### ORIGINAL WILDFLY: http://download.jboss.org/wildfly/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.zip
    curl -O http://192.168.1.138/software/wildfly-${WILDFLY_VERSION}.zip && \
### Unpack all the necessary files
    unzip wildfly-${WILDFLY_VERSION}.zip && \
### WildFly: Create directory, wildfly user and move things into place
    mkdir -p ${JBOSS_HOME} && \
    mv /wildfly-${WILDFLY_VERSION}/* ${JBOSS_HOME} && \
    mkdir -p ${JBOSS_HOME}/standalone/data && \
    mkdir -p ${JBOSS_HOME}/standalone/log/ && touch ${JBOSS_HOME}/standalone/log/server.log && \
### Wildfly: Creating a directory for hotdeployment. We will do RSync in here
    mkdir -p ${JBOSS_HOME}/standalone/deployments-exploded/ROOT.war && \
    chown -R wildfly:wildfly ${JBOSS_HOME} && chgrp -R wildfly ${JBOSS_HOME} && chmod -R 777 ${JBOSS_HOME}/standalone && \
### Wildfly: Modify file standalone.xml to enable exploded deployment in directory deployments-exploded
    sed -i "/        <subsystem xmlns=\"urn:jboss:domain:deployment-scanner:2.0\">/a \ \ \ \ \ \ \ \ \ \ \ \ <deployment-scanner name=\"deployments-exploded\" path=\"deployments-exploded\" relative-to=\"jboss.server.base.dir\" scan-enabled=\"true\" scan-interval=\"5000\" auto-deploy-zipped=\"false\" auto-deploy-exploded=\"true\" deployment-timeout=\"60\"/>" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
### Clean Up
    rm -rf wildfly-${WILDFLY_VERSION}.zip && rm -rf ${WILDFLY_VERSION}

EXPOSE 8080
WORKDIR ${JBOSS_HOME}
USER wildfly
CMD ["/opt/java/server/as/wildfly/bin/standalone.sh","-b","0.0.0.0"]
