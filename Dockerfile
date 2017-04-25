# Use Wildfly 10 image as the base
FROM jboss/wildfly:10.0.0.Final

MAINTAINER Aleksei <webalexx@gmail.com>

ENV APIMAN_VERSION 1.2.9.Final


RUN $JBOSS_HOME/bin/add-user.sh admin admin123! --silent

# Download and install apiman-standalon
RUN cd $JBOSS_HOME \
 && curl http://downloads.jboss.org/overlord/apiman/$APIMAN_VERSION/apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip -o apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip \
 && bsdtar -xf apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip \
 && rm apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip


RUN rm -f $JBOSS_HOME/standalone/configuration/apiman.properties

ADD apiman.properties $JBOSS_HOME/standalone/configuration/


USER root
# Set the working directory to jboss' user home directory
RUN yum  install -y maven 
USER jboss


#RUN cd $HOME && curl http://mirror.netcologne.de/apache.org/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz  | bsdtar -xvf-
#RUN mkdir $HOME/maven
#RUN cp -f -R $HOME/apache-maven-3.5.0 $HOME/maven
#RUN rm -f -R apache-maven-3.5.0
#RUN export M2_HOME=$HOME/maven/apache-maven-3.5.0
#RUN export MAVEN_HOME=$HOME/maven/apache-maven-3.5.0
#RUN export PATH=${M2_HOME}/bin:${PATH}

USER root
COPY io $HOME/.m2/repository/io
USER jboss

#VOLUME ["/opt"]

# Set the default command to run on boot
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]