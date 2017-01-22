FROM anapsix/alpine-java:jre8
MAINTAINER Mauricio "Maltron" Leal <maltron@gmail.com>

ENV JBOSS_HOME=/opt/java/server/as/wildfly \
    GROUP_ID=1001 \
    USER_ID=1001 \
    USER=wildfly \
    WILDFLY_VERSION=10.1.0.Final \
    ACTIVEMQ_RA_VERSION=5.14.3

RUN addgroup -S ${USER} -g ${GROUP_ID} && adduser -u ${USER_ID} -S -G ${USER} -h /home/${USER} ${USER} && chmod 755 /home/${USER} && \
    apk upgrade --update && apk add --update libstdc++ curl bash unzip && \
### ORIGINAL WILDFLY: http://download.jboss.org/wildfly/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.zip
    curl -O http://download.jboss.org/wildfly/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.zip && \
### Unpack all the necessary files
    unzip wildfly-${WILDFLY_VERSION}.zip && \
### WildFly: Create directory, wildfly user and move things into place
    mkdir -p ${JBOSS_HOME} && \
    mv /wildfly-${WILDFLY_VERSION}/* ${JBOSS_HOME} && \
    mkdir -p ${JBOSS_HOME}/standalone/data && \
    mkdir -p ${JBOSS_HOME}/standalone/log/ && touch ${JBOSS_HOME}/standalone/log/server.log && \
### Wildfly: Creating a directory for hotdeployment. We will do RSync in here
    mkdir -p ${JBOSS_HOME}/standalone/deployments-exploded/ROOT.war && \
### ActiveMQ: Installing a Resource Adapter to talk to ActiveMQ
###           Step #1: Downloading Resource Adapter
    curl -L -O http://search.maven.org/remotecontent?filepath=org/apache/activemq/activemq-rar/${ACTIVEMQ_RA_VERSION}/activemq-rar-${ACTIVEMQ_RA_VERSION}.rar && \
###           Step #2: Creating all the necessary directories
    mkdir -p ${JBOSS_HOME}/modules/system/layers/base/org/apache/activemq/main && \
###           Step #3: Unzip the contents into this directory
    unzip activemq-rar-${ACTIVEMQ_RA_VERSION=5.14.3}.rar -d ${JBOSS_HOME}/modules/system/layers/base/org/apache/activemq/main && \
###           Step #4: Creating Module definition
    printf "<module xmlns=\"urn:jboss:module:1.3\" name=\"org.apache.activemq\" slot=\"main\"><#NEWLINE>    <resources><#NEWLINE>        <resource-root path=\".\"/><#NEWLINE>        <resource-root path=\"activemq-amqp-5.14.3.jar\"/><#NEWLINE>        <resource-root path=\"activemq-broker-5.14.3.jar\"/><#NEWLINE>        <resource-root path=\"activemq-client-5.14.3.jar\"/><#NEWLINE>        <resource-root path=\"activemq-jms-pool-5.14.3.jar\"/><#NEWLINE>        <resource-root path=\"activemq-kahadb-store-5.14.3.jar\"/><#NEWLINE>          <resource-root path=\"activemq-mqtt-5.14.3.jar\"/><#NEWLINE>    <resource-root path=\"activemq-openwire-legacy-5.14.3.jar\"/><#NEWLINE>       <resource-root path=\"activemq-pool-5.14.3.jar\"/><#NEWLINE>    <resource-root path=\"activemq-protobuf-1.1.jar\"/><#NEWLINE>    <resource-root path=\"activemq-ra-5.14.3.jar\"/><#NEWLINE>      <resource-root path=\"activemq-spring-5.14.3.jar\"/><#NEWLINE>        <resource-root path=\"aopalliance-1.0.jar\"/><#NEWLINE>       <resource-root path=\"commons-logging-1.2.jar\"/><#NEWLINE>     <resource-root path=\"commons-net-3.5.jar\"/><#NEWLINE>       <resource-root path=\"commons-pool2-2.4.2.jar\"/><#NEWLINE>     <resource-root path=\"geronimo-j2ee-management_1.1_spec-1.0.1.jar\"/><#NEWLINE>       <resource-root path=\"hawtbuf-1.11.jar\"/><#NEWLINE>    <resource-root path=\"hawtdispatch-1.22.jar\"/><#NEWLINE>       <resource-root path=\"hawtdispatch-transport-1.22.jar\"/><#NEWLINE>     <resource-root path=\"log4j-1.2.17.jar\"/><#NEWLINE>    <resource-root path=\"mqtt-client-1.14.jar\"/><#NEWLINE>        <resource-root path=\"proton-j-0.16.0.jar\"/><#NEWLINE>       <resource-root path=\"slf4j-api-1.7.13.jar\"/><#NEWLINE>        <resource-root path=\"slf4j-log4j12-1.7.13.jar\"/><#NEWLINE>    <resource-root path=\"spring-aop-4.1.9.RELEASE.jar\"/><#NEWLINE>        <resource-root path=\"spring-beans-4.1.9.RELEASE.jar\"/><#NEWLINE>      <resource-root path=\"spring-context-4.1.9.RELEASE.jar\"/><#NEWLINE>    <resource-root path=\"spring-core-4.1.9.RELEASE.jar\"/><#NEWLINE>       <resource-root path=\"spring-expression-4.1.9.RELEASE.jar\"/><#NEWLINE>       <resource-root path=\"xbean-spring-4.2.jar\"/><#NEWLINE>    </resources><#NEWLINE>    <exports><#NEWLINE>        <exclude path=\"org/springframework/**\"/><#NEWLINE>        <exclude path=\"org/apache/xbean/**\"/><#NEWLINE>        <exclude path=\"org/apache/commons/**\"/><#NEWLINE>        <exclude path=\"org/aopalliance/**\"/><#NEWLINE>        <exclude path=\"org/fusesource/**\"/><#NEWLINE>    </exports><#NEWLINE>    <dependencies><#NEWLINE>        <module name=\"javax.api\" slot=\"main\"/><#NEWLINE>        <module name=\"javax.jms.api\" slot=\"main\"/><#NEWLINE>        <module name=\"javax.management.j2ee.api\" slot=\"main\"/><#NEWLINE>        <module name=\"javax.resource.api\" slot=\"main\"/><#NEWLINE>        <module name=\"org.apache.commons.logging\"/><#NEWLINE>        <module name=\"org.apache.commons.pool\"/><#NEWLINE>        <module name=\"org.apache.log4j\"/><#NEWLINE>        <module name=\"org.slf4j\"/><#NEWLINE>    </dependencies><#NEWLINE></module>" > ${JBOSS_HOME}/modules/system/layers/base/org/apache/activemq/main/module.xml && \
    sed -i "s/<#NEWLINE>/\n/g" ${JBOSS_HOME}/modules/system/layers/base/org/apache/activemq/main/module.xml && \
###           Step #5: Add a MDB instance into standalone.xml
    sed -i "/            <[/]session-bean>/a \ \ \ \ \ \ \ \ \ \ \ \ \<mdb><#NEWLINE>                <resource-adapter-ref resource-adapter-name=\"activemq\"/><#NEWLINE>                <bean-instance-pool-ref pool-name=\"mdb-strict-max-pool\"/><#NEWLINE>            </mdb>" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
###           Step #6: Add the Resource Adapter definition into standalone.xml
    sed -i "s|<subsystem xmlns=\"urn:jboss:domain:resource-adapters:4.0\"/>|<subsystem xmlns=\"urn:jboss:domain:resource-adapters:4.0\"><#NEWLINE>            <resource-adapters><#NEWLINE>                <resource-adapter id=\"activemq\"><#NEWLINE>                    <module slot=\"main\" id=\"org.apache.activemq\"/><#NEWLINE>                    <transaction-support>XATransaction</transaction-support><#NEWLINE>                    <config-property name=\"ServerUrl\"><#NEWLINE>                        \${env.BROKER_ADDRESS}?jms.rmIdFromConnectionId=true<#NEWLINE>                    </config-property><#NEWLINE>                    <config-property name=\"UseInboundSession\"><#NEWLINE>                        false<#NEWLINE>                    </config-property><#NEWLINE>                    <config-property name=\"UserName\"><#NEWLINE>                        \${env.BROKER_USERNAME}<#NEWLINE>                    </config-property><#NEWLINE>                    <config-property name=\"Password\"><#NEWLINE>                        \${env.BROKER_PASSWORD}<#NEWLINE>                    </config-property><#NEWLINE>                    <connection-definitions><#NEWLINE>                        <connection-definition class-name=\"org.apache.activemq.ra.ActiveMQManagedConnectionFactory\" jndi-name=\"java:/AMQConnectionFactory\" enabled=\"true\" use-java-context=\"true\" pool-name=\"ConnectionFactory\"><#NEWLINE>                              <recovery no-recovery=\"false\"><#NEWLINE>                                 <recover-credential><#NEWLINE>                                          <user-name>username</user-name><#NEWLINE>                                          <password>password</password><#NEWLINE>                                 </recover-credential><#NEWLINE>                         </recovery><#NEWLINE>                   </connection-definition><#NEWLINE>                    </connection-definitions><#NEWLINE>                    <admin-objects><#NEWLINE>                        <admin-object class-name=\"org.apache.activemq.command.ActiveMQTopic\" jndi-name=\"topic/event-registration\" use-java-context=\"true\" pool-name=\"topic_evereg\"><#NEWLINE>                            <config-property name=\"PhysicalName\"><#NEWLINE>                                activemq/topic/event-registration<#NEWLINE>                            </config-property><#NEWLINE>                        </admin-object><#NEWLINE>                        <admin-object class-name=\"org.apache.activemq.command.ActiveMQQueue\" jndi-name=\"queue/test-queue\" use-java-context=\"true\" pool-name=\"test_queue\"><#NEWLINE>                            <config-property name=\"PhysicalName\"><#NEWLINE>                                testQueue<#NEWLINE>                            </config-property><#NEWLINE>                        </admin-object><#NEWLINE>                    </admin-objects><#NEWLINE>                </resource-adapter><#NEWLINE>            </resource-adapters><#NEWLINE>        </subsystem>|" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
    sed -i "s/<#NEWLINE>/\n/g" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
###           Step #7: Remove active's RAR file
    rm -rf activemq-rar-${ACTIVEMQ_RA_VERSION}.rar && \
### WildFly: Turn the ownership to WildFly user
    chown -R wildfly:wildfly ${JBOSS_HOME} && chgrp -R wildfly ${JBOSS_HOME} && chmod -R 777 ${JBOSS_HOME}/standalone && \
### WildFly: Creating a Node Identifier information
    sed -i "s/<core-environment>/<core-environment node-identifier=\"\${env.HOSTNAME}\">/" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
### Wildfly: Modify file standalone.xml to enable exploded deployment in directory deployments-exploded
    sed -i "/        <subsystem xmlns=\"urn:jboss:domain:deployment-scanner:2.0\">/a \ \ \ \ \ \ \ \ \ \ \ \ <deployment-scanner name=\"deployments-exploded\" path=\"deployments-exploded\" relative-to=\"jboss.server.base.dir\" scan-enabled=\"true\" scan-interval=\"5000\" auto-deploy-zipped=\"false\" auto-deploy-exploded=\"true\" deployment-timeout=\"60\"/>" ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
### Wildfly: 
### Clean Up
    rm -rf wildfly-${WILDFLY_VERSION}.zip && rm -rf ${WILDFLY_VERSION}

EXPOSE 8080
WORKDIR ${JBOSS_HOME}
USER wildfly
CMD ["/opt/java/server/as/wildfly/bin/standalone.sh","-b","0.0.0.0"]
