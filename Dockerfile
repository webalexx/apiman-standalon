# Use Wildfly 10 image as the base
FROM jboss/wildfly:10.0.0.Final

MAINTAINER Aleksei <webalexx@gmail.com>

ENV APIMAN_VERSION 1.2.9.Final

ROOT 

RUN cd $HOME/wildfly \
 && curl http://downloads.jboss.org/apiman/$APIMAN_VERSION/apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip | bsdtar -xvf-

RUN $HOME/wildfly/bin/add-user.sh admin admin123! --silent

RUN mkdir /opt/maven350
RUN cd /opt/maven350 && curl http://mirror.netcologne.de/apache.org/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz  | bsdtar -xvf-

#RUN rm -f /opt/maven350/apache-maven-3.5.0-bin.tar.gz

RUN export PATH=/opt/maven350/bin:$PATH

RUN rm -f $HOME/wildfly/standalone/configuration/apiman.properties
ADD apiman.properties $HOME/wildfly/standalone/configuration/


# Set the default command to run on boot
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]


