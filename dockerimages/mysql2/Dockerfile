FROM rhel7.2:latest

ENV JAVA_HOME   /usr/java/jdk1.8.0_112
ENV JBOSS_HOME  /opt/java/server/as/wildfly

#RUN export JAVA_HOME=/usr/java/jdk1.8.0_112 && export JBOSS_HOME=/opt/java/server/as/wildfly && \
### Install all the necessary tooling
RUN printf "[rhel-7-server-rpms]\n\
name=Red Hat Enterprise Linux 7\n\
baseurl=http://192.168.1.138/repos/rhel-7-server-rpms\n\
enabled=1\n\
gpgcheck=0" > /etc/yum.repos.d/wildfly.repo && \
     yum -y update && yum -y install unzip tar && yum clean all && \
### Download all the necessary packages
    curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/jdk-8u112-linux-x64.rpm && \
    curl -O http://192.168.1.138/software/wildfly-10.1.0.Final.zip && \
    curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/mysql-connector-java-5.1.40.zip && \
### Install Java Development Kit
    rpm -iv jdk-8u112-linux-x64.rpm && \
### Unpack all the necessary files
    unzip wildfly-10.1.0.Final.zip && unzip mysql-connector-java-5.1.40.zip && \
### WildFly: Create directory, wildfly user and move things into place
    mkdir --parents ${JBOSS_HOME} && rm -rf ${JBOSS_HOME} && \
    groupadd --system wildfly --gid 1000 && \
    useradd --uid 1000 --system --gid wildfly --create-home \
             --home-dir ${JBOSS_HOME} --shell /sbin/nologin --comment "WildFly User" wildfly && chmod 755 ${JBOSS_HOME} && \
    mv /wildfly-10.1.0.Final/* ${JBOSS_HOME} && chown -R wildfly:wildfly ${JBOSS_HOME} && chgrp -R wildfly ${JBOSS_HOME} && \
### MySQL: Create directory, move the jar file and create all the necessary content
    mkdir --parents ${JBOSS_HOME}/modules/com/mysql/main/ && \
    mv /mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar ${JBOSS_HOME}/modules/com/mysql/main/ && \
### MySQL: Create the Module definition
    printf "<module xmlns=\"urn:jboss:module:1.1\" name=\"com.mysql\">\n\n    <resources>\n        <resource-root path=\"mysql-connector-java-5.1.40-bin.jar\"/>\n    </resources>\n\n    <dependencies>\n        <module name=\"javax.api\"/>\n        <module name=\"javax.transaction.api\"/>\n    </dependencies>\n</module>" > ${JBOSS_HOME}/modules/com/mysql/main/module.xml && \
### MySQL: Add the necessary content into standalone.xml to add a MySQL Driver
    sed -i '/                <drivers>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <driver name=\"MySQL\" module=\"com.mysql\">\n                        <driver-class>com.mysql.jdbc.Driver</driver-class>\n                        <xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xa-datasource-class>\n                    </driver>' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
    sed -i '/            <datasources>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <datasource jndi-name=\"java:jboss/datasource/DataSourceDS\" pool-name=\"DataSourceDS\">\n                    <connection-url>jdbc:mysql://database:3306</connection-url>\n                    <driver>MySQL</driver>\n                    <security>\n                        <user-name>mauricio</user-name>\n                        <password>maltron</password>\n                    </security>\n                </datasource>' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
### Adjust all the necessary permissions
#    chown -R wildfly:wildfly ${JBOSS_HOME} && chmod -R 777 ${JBOSS_HOME}/standalone && \
### Clean Up
#    sed -i '2i JAVA_HOME=/usr/java/jdk1.8.0_112' ${JBOSS_HOME}/bin/standalone.sh && \
#    sed -i '3i JBOSS_HOME=/opt/java/server/as/wildfly' ${JBOSS_HOME}/bin/standalone.sh && \
    rm -rf /jdk-8u112-linux-x64.rpm && rm -rf /mysql-connector-java-5.1.40.zip && rm -rf /mysql-connector-java-5.1.40 && rm -rf wildfly-10.1.0.Final.zip && rm -rf wildfly-10.1.0.Final

EXPOSE 8080
WORKDIR ${JBOSS_HOME}
USER wildfly
CMD ["/opt/java/server/as/wildfly/bin/standalone.sh","-b","0.0.0.0"]
