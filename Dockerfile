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

ARG MAVEN_VERSION=3.5.0
ARG USER_HOME_DIR="/root"
ARG SHA=beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries



USER root
#RUN yum  install -y maven 

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn


USER jboss

RUN mkdir $USER_HOME_DIR/.m2
RUN chmod 0775 $USER_HOME_DIR/.m2

COPY repository $USER_HOME_DIR/.m2/repository

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

#COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
#COPY settings-docker.xml /usr/share/maven/ref/

VOLUME "$USER_HOME_DIR/.m2"


#RUN /usr/local/bin/mvn-entrypoint.sh

#CMD ["mvn"]


ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml"]