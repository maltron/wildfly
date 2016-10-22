FROM rhel7.2:latest

#ENV JAVA_HOME   /usr/java/jdk1.8.0_112
#ENV JBOSS_HOME  /opt/java/server/as/wildfly

# 1: Download all the necessary packages
RUN export JAVA_HOME=/usr/java/jdk1.8.0_112 && export JBOSS_HOME=/opt/java/server/as/wildfly && \
    curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/jdk-8u112-linux-x64.rpm && \
    curl -O http://192.168.1.138/software/wildfly-10.1.0.Final.zip && \
    curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/mysql-connector-java-5.1.40.zip && \
### Install Java Development Kit
    rpm -iv jdk-8u112-linux-x64.rpm && \
### Use Java's jar tool to unpack everything else
    jar xf wildfly-10.1.0.Final.zip && jar xf mysql-connector-java-5.1.40.zip && \
### WildFly: Create directory, wildfly user and move things into place
    mkdir --parents ${JBOSS_HOME} && rm -rf ${JBOSS_HOME} && \
    groupadd --system wildfly --gid 1000 && \
    useradd --uid 1000 --system --gid wildfly --create-home \
             --home-dir ${JBOSS_HOME} --shell /sbin/nologin --comment "WildFly User" wildfly && chmod 755 ${JBOSS_HOME} && \
    mv --force /wildfly-10.1.0.Final/* ${JBOSS_HOME} && \
### MySQL: Create directory, move the jar file and create all the necessary content
    mkdir --parents ${JBOSS_HOME}/modules/com/mysql/main/ && \
    mv /mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar ${JBOSS_HOME}/modules/com/mysql/main/ && \
### MySQL: Create the Module definition
    printf "<module xmlns=\"urn:jboss:module:1.1\" name=\"com.mysql\">\n\n    <resources>\n        <resource-root path=\"mysql-connector-java-5.1.40-bin.jar\"/>\n    </resources>\n\n    <dependencies>\n        <module name=\"javax.api\"/>\n        <module name=\"javax.transaction.api\"/>\n    </dependencies>\n</module>" > ${JBOSS_HOME}/modules/com/mysql/main/module.xml && \
### MySQL: Add the necessary content into standalone.xml to add a MySQL Driver
    sed -i '/                <drivers>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <driver name=\"MySQL\" module=\"com.mysql\">\n                        <driver-class>com.mysql.jdbc.Driver</driver-class>\n                        <xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xa-datasource-class>\n                    </driver>' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
    sed -i '/            <datasources>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <datasource jndi-name=\"java:jboss/datasource/DataSourceDS\" pool-name=\"DataSourceDS\">\n                    <connection-url>jdbc:mysql://database:3306</connection-url>\n                    <driver>MySQL</driver>\n                    <security>\n                        <user-name>mauricio</user-name>\n                        <password>maltron</password>\n                    </security>\n                </datasource>' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
### Clean Up
    sed -i '2i JAVA_HOME=/usr/java/jdk1.8.0_112' ${JBOSS_HOME}/bin/standalone.sh && \
    sed -i '3i JBOSS_HOME=/opt/java/server/as/wildfly' ${JBOSS_HOME}/bin/standalone.sh && \
    rm -rf /jdk-8u112-linux-x64.rpm && rm -rf /mysql-connector-java-5.1.40.zip && rm -rf /mysql-connector-java-5.1.40 && rm -rf wildfly-10.1.0.Final.zip && rm -rf wildfly-10.1.0.Final

