FROM apiman/on-wildfly10:latest

RUN $JBOSS_HOME/bin/add-user.sh admin admin123! --silent
ADD apiman.properties $JBOSS_HOME/standalone/configuration


EXPOSE 8787
 
 
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]
#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml", "--debug"]
