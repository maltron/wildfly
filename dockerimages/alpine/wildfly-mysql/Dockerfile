FROM anapsix/alpine-java:jre8
MAINTAINER Mauricio "Maltron" Leal <maltron@gmail.com>

LABEL io.k8s.description="WildFly Appplication Server" \
      io.k8s.display-name="WildFly 10.1.0" \
      io.openshift.expose-services="8080:wildfly" \
      io.openshift.tags="appserver,j2ee,java" \
      # this label tells s2i where to find its mandatory scripts
      # (run, assemble, save-artifacts)
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

ENV JBOSS_HOME=/opt/java/server/as/wildfly \
    GROUP_ID=1001 \
    USER_ID=1001 \
    USER=wildfly

RUN addgroup -S ${USER} -g ${GROUP_ID} && adduser -u ${USER_ID} -S -G ${USER} -h /home/${USER} ${USER} && chmod 755 /home/${USER} && \
    apk upgrade --update && apk add --update libstdc++ curl bash && \
### ORIGINAL WILDFLY: http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.zip
    curl -O http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.zip && \
### ORIGINAL: MYSQL: http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.zip
    curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.zip && \
### Unpack all the necessary files
    unzip wildfly-10.1.0.Final.zip && unzip mysql-connector-java-5.1.40.zip && \
### WildFly: Create directory, wildfly user and move things into place
    mkdir -p ${JBOSS_HOME} && \
    mv /wildfly-10.1.0.Final/* ${JBOSS_HOME} && \
    mkdir -p ${JBOSS_HOME}/standalone/data && \
    mkdir -p ${JBOSS_HOME}/standalone/log/ && touch ${JBOSS_HOME}/standalone/log/server.log && \
    mkdir -p ${JBOSS_HOME}/standalone/deployments-exploded/ROOT.war && \
    chown -R wildfly:wildfly ${JBOSS_HOME} && chgrp -R wildfly ${JBOSS_HOME} && chmod -R 777 ${JBOSS_HOME}/standalone && \
### WildFly: Add some users for Security experimentation
    echo "redhat=guest" >> ${JBOSS_HOME}/standalone/configuration/application-roles.properties && \
    echo "redhat=a61461431d8a3a52ea041ea5d25dcbc2" >> ${JBOSS_HOME}/standalone/configuration/application-users.properties && \
### MySQL: Create directory, move the jar file and create all the necessary content
    mkdir -p ${JBOSS_HOME}/modules/com/mysql/main/ && \
    mv /mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar ${JBOSS_HOME}/modules/com/mysql/main/ && \
### MySQL: Create the Module definition
    printf "<module xmlns=\"urn:jboss:module:1.1\" name=\"com.mysql\">\n\n    <resources>\n        <resource-root path=\"mysql-connector-java-5.1.40-bin.jar\"/>\n    </resources>\n\n    <dependencies>\n        <module name=\"javax.api\"/>\n        <module name=\"javax.transaction.api\"/>\n    </dependencies>\n</module>" > ${JBOSS_HOME}/modules/com/mysql/main/module.xml && \
### MySQL: Add the necessary content into standalone.xml to add a MySQL Driver
    sed -i '/                <drivers>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <driver name=\"MySQL\" module=\"com.mysql\"><#NEWLINE>                        <driver-class>com.mysql.jdbc.Driver</driver-class><#NEWLINE>                        <xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xa-datasource-class><#NEWLINE>                    </driver>' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
    sed -i '/            <datasources>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <datasource jndi-name=\"java:/jboss/datasource/DataSourceDS\" pool-name=\"DataSourceDS\"><#NEWLINE>                    <connection-url>${env.DATASOURCE_CONNECTION}</connection-url><#NEWLINE>                    <driver>MySQL</driver><#NEWLINE>                    <security><#NEWLINE>                        <user-name>${env.DATASOURCE_USERNAME}</user-name><#NEWLINE>                        <password>${env.DATASOURCE_PASSWORD}</password><#NEWLINE>                    </security><#NEWLINE>                </datasource>' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
    sed -i "/        <subsystem xmlns=\"urn:jboss:domain:deployment-scanner:2.0\">/a \ \ \ \ \ \ \ \ \ \ \ \ <deployment-scanner name=\"deployments-exploded\" path=\"deployments-exploded\" relative-to=\"jboss.server.base.dir\" scan-enabled=\"true\" scan-interval=\"5000\" auto-deploy-zipped=\"false\" auto-deploy-exploded=\"true\" deployment-timeout=\"60\"/>" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
### NEW LINE ADJUST: Replace all markers <#NEWLINE> with the actual character
    sed -i "s/<#NEWLINE>/\n/g" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
### Adjust all the necessary permissions
#    chown -R wildfly:wildfly ${JBOSS_HOME} && chmod -R 777 ${JBOSS_HOME}/standalone && \
### Create all the necessary scripts for S2I and give the proper permissions
    mkdir -p /usr/libexec/s2i && \
    printf "#!/bin/sh\n\
mv /tmp/src/*.war ${JBOSS_HOME}/standalone/deployments" > /usr/libexec/s2i/assemble && \
    printf "#!/bin/sh\n\
exec /opt/java/server/as/wildfly/bin/standalone.sh -b 0.0.0.0\n" > /usr/libexec/s2i/run && \
    chmod 755 /usr/libexec/s2i/* && \
### Clean Up
#    sed -i '2i JAVA_HOME=/usr/java/jdk1.8.0_112' ${JBOSS_HOME}/bin/standalone.sh && \
#    sed -i '3i JBOSS_HOME=/opt/java/server/as/wildfly' ${JBOSS_HOME}/bin/standalone.sh && \
    rm -rf /mysql-connector-java-5.1.40.zip && rm -rf /mysql-connector-java-5.1.40 && rm -rf wildfly-10.1.0.Final.zip && rm -rf wildfly-10.1.0.Final

EXPOSE 8080
WORKDIR ${JBOSS_HOME}
USER ${USER_ID}
CMD ["/opt/java/server/as/wildfly/bin/standalone.sh","-b","0.0.0.0"]
