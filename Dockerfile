# Use Wildfly 10 image as the base
FROM jboss/wildfly:10.0.0.Final

MAINTAINER Aleksei <webalexx@gmail.com>

ENV APIMAN_VERSION 1.2.9.Final

RUN cd $HOME/wildfly \
 && curl http://downloads.jboss.org/apiman/$APIMAN_VERSION/apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip | bsdtar -xvf-

RUN $HOME/wildfly/binc/add-user.sh admin admin123! --silent

RUN mkdir $HOME/wildfly/maven350
RUN chmod 0775 $HOME/wildfly/maven350
RUN cd $HOME/wildfly/maven350 && curl http://mirror.netcologne.de/apache.org/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz  | bsdtar -xvf-

#RUN rm -f /opt/maven350/apache-maven-3.5.0-bin.tar.gz


RUN export JAVA_HOME=/usr/lib/jvm/java-8-oracle
RUN export M2_HOME=$HOME/wildfly/maven350/apache-maven-3.5.0
RUN export MAVEN_HOME=$HOME/wildfly/maven350/apache-maven-3.5.0
RUN export PATH=${M2_HOME}/bin:${PATH}


COPY io $HOME/wildfly/.m2/repository

RUN rm -f $HOME/wildfly/standalone/configuration/apiman.properties
ADD apiman.properties $HOME/wildfly/standalone/configuration/


# Set the default command to run on boot
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]


