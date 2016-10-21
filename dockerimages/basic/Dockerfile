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
     chmod 755 /opt/java/server/as/wildfly

#RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/jdk-8u112-linux-x64.tar.gz


#ADD jdk-8u112-linux-x64.tar.gz ${JAVA_HOME}
#RUN mkdir --parents ${JAVA_HOME} && cd ${JAVA_HOME} && cd .. && rm -rf 8 && mv /jdk1.8.0_112 8 && cd /
RUN curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://192.168.1.138/software/jdk-8u112-linux-x64.tar.gz -O && tar xf jdk-8u112-linux-x64.tar.gz && mkdir --parent /opt/java/jdk/8 && cd /opt/java/jdk/8 && mv /jdk1.8.0_112/* . && cd / && curl -O http://192.168.1.138/software/wildfly-10.1.0.Final.tar.gz && tar xf wildfly-10.1.0.Final.tar.gz && cd wildfly-10.1.0.Final && mv * /opt/java/server/as/wildfly/ && chown -R wildfly:wildfly /opt/java/server/as/wildfly && cd / && rm -rf jdk1.8.0_112/ && rm -rf jdk-8u112-linux-x64.tar.gz && rm -rf wildfly-10.1.0.Final/ && rm -rf wildfly-10.1.0.Final.tar.gz

EXPOSE 8080
WORKDIR /opt/java/server/as/wildfly
USER wildfly
CMD ["/opt/java/server/as/wildfly/bin/standalone.sh","-b","0.0.0.0"]
