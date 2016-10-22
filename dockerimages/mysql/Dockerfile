FROM rhel7.2:latest
MAINTAINER Mauricio "Maltron" Leal <maltron@gmail.com>

ENV JAVA_HOME  /opt/java/jdk/8
ENV JBOSS_HOME /opt/java/server/as/wildfly

# Install packages necessary to run WildFly
RUN printf "[rhel-7-server-rpms]\n\
name=Red Hat Enterprise Linux 7\n\
baseurl=http://192.168.1.138/repos/rhel-7-server-rpms\n\
enabled=1\n\
gpgcheck=0" > /etc/yum.repos.d/openshift.repo && \
     yum -y update && yum -y install unzip tar && yum clean all && \
     groupadd --system wildfly --gid 1000 && mkdir -p /opt/java/server/as && \
     useradd --uid 1000 --system --gid wildfly --create-home \
             --home-dir /opt/java/server/as/wildfly --shell /sbin/nologin --comment "WildFly User" wildfly && \
     chmod 755 /opt/java/server/as/wildfly && \
    curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/jdk-8u112-linux-x64.tar.gz -O && \
    tar xf jdk-8u112-linux-x64.tar.gz && \
    mkdir --parent /opt/java/jdk/8 && cd /opt/java/jdk/8 && mv /jdk1.8.0_112/* . && cd / && \
    curl -O http://192.168.1.138/software/wildfly-10.1.0.Final.tar.gz && tar xf wildfly-10.1.0.Final.tar.gz && cd wildfly-10.1.0.Final && mv * /opt/java/server/as/wildfly/ && cd / && \
    curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/mysql-connector-java-5.1.40.tar.gz && \
    tar xf mysql-connector-java-5.1.40.tar.gz && mkdir --parent /opt/java/server/as/wildfly/modules/com/mysql/main/ && \
    cp mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar /opt/java/server/as/wildfly/modules/com/mysql/main/ && \
    printf "<module xmlns=\"urn:jboss:module:1.1\" name=\"com.mysql\">\n\n    <resources>\n        <resource-root path=\"mysql-connector-java-5.1.40-bin.jar\"/>\n    </resources>\n\n    <dependencies>\n        <module name=\"javax.api\"/>\n        <module name=\"javax.transaction.api\"/>\n    </dependencies>\n</module>" > /opt/java/server/as/wildfly/modules/com/mysql/main/module.xml && \ 
    sed -i '/                <drivers>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <driver name=\"MySQL\" module=\"com.mysql\">\n                        <driver-class>com.mysql.jdbc.Driver</driver-class>\n                        <xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xa-datasource-class>\n                    </driver>' /opt/java/server/as/wildfly/standalone/configuration/standalone.xml && \
    sed -i '/            <datasources>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <datasource jndi-name=\"java:jboss/datasource/DataSourceDS\" pool-name=\"DataSourceDS\">\n                    <connection-url>jdbc:mysql://database:3306</connection-url>\n                    <driver>MySQL</driver>\n                    <security>\n                        <user-name>mauricio</user-name>\n                        <password>maltron</password>\n                    </security>\n                </datasource>' /opt/java/server/as/wildfly/standalone/configuration/standalone.xml && \
    mkdir ${JBOSS_HOME}/standalone/log && touch ${JBOSS_HOME}/standalone/log/server.log && \
    mkdir ${JBOSS_HOME}/standalone/data && \
    chown -R wildfly:wildfly ${JBOSS_HOME} && chmod -R 777 ${JBOSS_HOME}/standalone && \
    cd / && rm -rf jdk1.8.0_112/ && rm -rf jdk-8u112-linux-x64.tar.gz && \
    rm -rf wildfly-10.1.0.Final/ && rm -rf wildfly-10.1.0.Final.tar.gz && \
    rm -rf mysql-connector-java-5.1.40 && rm -rf mysql-connector-java-5.1.40.tar.gz

EXPOSE 8080
WORKDIR /opt/java/server/as/wildfly
USER wildfly
CMD ["/opt/java/server/as/wildfly/bin/standalone.sh","-b","0.0.0.0"]
