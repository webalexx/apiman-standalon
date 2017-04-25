FROM jboss/wildfly:10.0.0.Final

MAINTAINER Eric Wittmann <eric.wittmann@redhat.com>

ENV APIMAN_VERSION 1.2.9.Final

RUN $JBOSS_HOME/bin/add-user.sh admin admin123! --silent

# Download and install apiman-standalon
RUN cd $JBOSS_HOME \
 && curl http://downloads.jboss.org/overlord/apiman/$APIMAN_VERSION/apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip -o apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip \
 && bsdtar -xf apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip \
 && rm apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip


# Apiman properties
ADD apiman.properties $JBOSS_HOME/standalone/configuration/


ENV MAVEN_VERSION 3.5.0
ENV PATH /usr/share/apache-maven-${MAVEN_VERSION}/bin:${PATH}

USER root
#RUN yum  install -y maven 
RUN yum --update add curl && \
    curl http://apache.mirror.anlx.net/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz > /usr/share/maven.tar.gz && \
    cd /usr/share && \
    tar xvzf maven.tar.gz && \
    rm -f maven.tar.gz


ENV MAVEN_HOME /usr/share/maven

ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

#COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
#COPY settings-docker.xml /usr/share/maven/ref/

VOLUME "$USER_HOME_DIR/.m2"

COPY io $MAVEN_CONFIG/.m2/repository/io

RUN /usr/local/bin/mvn-entrypoint.sh

CMD ["mvn"]
USER jboss

ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]