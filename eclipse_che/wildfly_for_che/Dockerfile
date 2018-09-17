# Copyright (c) 2012-2018 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation

FROM eclipse/stack-base:ubuntu
EXPOSE 4403 8000 8080 9990 22

LABEL che:server:8080:ref=wildfly che:server:9990:ref=jboss che:server:8080:protocol=http che:server:8000:ref=tomcat8-debug che:server:8000:protocol=http

ENV MAVEN_VERSION=3.3.9

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 \
     M2_HOME=/home/user/apache-maven-$MAVEN_VERSION 

ENV PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH
RUN mkdir /home/user/apache-maven-$MAVEN_VERSION && \
    wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C /home/user/apache-maven-$MAVEN_VERSION/
ENV TERM xterm

ENV WILDFLY_VERSION 10.1.0.Final
ENV WILDFLY_SHA1 9ee3c0255e2e6007d502223916cefad2a1a5e333
ENV JBOSS_HOME=/home/user/wildfly-$WILDFLY_VERSION

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd /home/user \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz && \
    tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && rm wildfly-$WILDFLY_VERSION.tar.gz && \
    sed -i 's/127.0.0.1/0.0.0.0/g' /home/user/wildfly-$WILDFLY_VERSION/standalone/configuration/standalone.xml && \
    sudo mkdir -p /home/user/.m2 && \
    sudo mkdir -p /home/user/jdtls/data && \
    sudo chgrp -R 0 ${HOME} && \
    sudo chmod -R g+rwX ${HOME} && \
# Adding MySQL Capabilities into the WildFly
    curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.zip && \
    unzip mysql-connector-java-5.1.40.zip && \
    mkdir --parents ${JBOSS_HOME}/modules/com/mysql/main/ && \
    mv mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar ${JBOSS_HOME}/modules/com/mysql/main/ && \
    printf "<module xmlns=\"urn:jboss:module:1.1\" name=\"com.mysql\">\n\n    <resources>\n        <resource-root path=\"mysql-connector-java-5.1.40-bin.jar\"/>\n    </resources>\n\n    <dependencies>\n        <module name=\"javax.api\"/>\n        <module name=\"javax.transaction.api\"/>\n    </dependencies>\n</module>" > ${JBOSS_HOME}/modules/com/mysql/main/module.xml && \
    sed -i '/                <drivers>/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <driver name=\"MySQL\" module=\"com.mysql\">\n                        <driver-class>com.mysql.jdbc.Driver</driver-class>\n                        <xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xa-datasource-class>\n                    </driver>' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
    rm -rf mysql-connector-java-5.1.40 && rm -rf mysql-connector-java-5.1.40.zip && \
# Adding MySQL Client
    sudo apt-get update && sudo apt-get -y install mysql-client
