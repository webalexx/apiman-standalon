# Use Wildfly 10 image as the base
FROM jboss/wildfly:10.0.0.Final

MAINTAINER Aleksei <webalexx@gmail.com>

ENV APIMAN_VERSION 1.2.9.Final

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \ chmod 755 /opt/jboss

USER root
# Set the working directory to jboss' user home directory
RUN yum  install -y maven 
USER jboss

RUN cd $HOME/wildfly \
 && curl http://downloads.jboss.org/apiman/$APIMAN_VERSION/apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip | bsdtar -xvf-

RUN $HOME/wildfly/bin/add-user.sh admin admin123! --silent

#RUN cd $HOME && curl http://mirror.netcologne.de/apache.org/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz  | bsdtar -xvf-

#RUN mkdir $HOME/maven
#RUN cp -f -R $HOME/apache-maven-3.5.0 $HOME/maven
#RUN rm -f -R apache-maven-3.5.0

#RUN export M2_HOME=$HOME/maven/apache-maven-3.5.0
#RUN export MAVEN_HOME=$HOME/maven/apache-maven-3.5.0
#RUN export PATH=${M2_HOME}/bin:${PATH}

RUN mkdir $HOME/.m2
RUN mkdir $HOME/.m2/repository
RUN mkdir $HOME/.m2/repository/io
COPY io/* $HOME/.m2/repository/io/

RUN rm -f $HOME/wildfly/standalone/configuration/apiman.properties
ADD apiman.properties $HOME/wildfly/standalone/configuration/

#VOLUME ["/opt"]

# Set the default command to run on boot
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]


