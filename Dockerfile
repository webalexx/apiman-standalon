# Use Wildfly 10 image as the base
FROM jboss/wildfly:10.0.0.Final

MAINTAINER Eric Wittmann <eric.wittmann@redhat.com>

ENV APIMAN_VERSION 1.2.9.Final

RUN cd $HOME/wildfly \
 && curl http://downloads.jboss.org/apiman/$APIMAN_VERSION/apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip | bsdtar -xvf-

 
RUN $HOME/wildfly/bin/add-user.sh admin admin123! --silent

RUN rm -f $HOME/wildfly/standalone/configuration/apiman.properties
COPY apiman.properties $HOME/wildfly/standalone/configuration/

# Set the default command to run on boot
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]


