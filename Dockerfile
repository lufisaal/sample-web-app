FROM centos:7

ENV TOMCAT_VERSION=8.5.100
ENV CATALINA_HOME=/opt/tomcat
ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk

RUN mkdir ${CATALINA_HOME}
WORKDIR ${CATALINA_HOME}

# Install necessary packages
RUN yum -y install java-1.8.0-openjdk openssl
# INSTALL tomcat
RUN curl -O https://downloads.apache.org/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xvfz apache-tomcat-*.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION}/* ${CATALINA_HOME}/. && \
    rm apache-tomcat-*.tar.gz

# get sample app
WORKDIR ${CATALINA_HOME}/webapps
RUN curl -O -L https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war

# Copy SSL certificate and key
COPY tomcat-cert.pem ${CATALINA_HOME}/conf/
COPY tomcat-key.pem ${CATALINA_HOME}/conf/
# converting cert-key to pkcs12
RUN openssl pkcs12 -export -in ${CATALINA_HOME}/conf/tomcat-cert.pem -inkey ${CATALINA_HOME}/conf/tomcat-key.pem -out ${CATALINA_HOME}/conf/tomcat-keystore.p12 -name tomcat -password pass:testomcat

#Config tomcat 
COPY server.xml ${CATALINA_HOME}/conf

EXPOSE 4041

CMD ["/opt/tomcat/bin/catalina.sh", "run"]