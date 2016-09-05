FROM ubuntu:xenial
MAINTAINER Beat Strasser <beat.strasser@inventage.com>

# install java
RUN echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get update && \
	apt-get install -yq software-properties-common && \
	add-apt-repository ppa:webupd8team/java && \
	apt-get purge software-properties-common -yq && \
	apt-get update && \
	apt-get install -yq oracle-java8-installer oracle-java8-set-default curl && \
	apt-get autoremove -yq && \
	apt-get clean -yq && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV SONATYPE_WORK /sonatype-work
ENV IQ_VERSION 1.22.0-01

RUN mkdir -p /opt/sonatype/iq-server \
  && curl --fail --silent --location --retry 3 \
    https://download.sonatype.com/clm/server/nexus-iq-server-${IQ_VERSION}-bundle.tar.gz \
  | gunzip \
  | tar x -C /opt/sonatype/iq-server nexus-iq-server-${IQ_VERSION}.jar

RUN useradd -r -u 200 -m -c "iq-server role account" -d ${SONATYPE_WORK} -s /bin/false iq-server

VOLUME ${SONATYPE_WORK}

RUN mkdir -p ${SONATYPE_WORK}/log && chown -R iq-server ${SONATYPE_WORK}/log

ADD ./config.yml /sonatype-work/config.yml

ENV JVM_OPTIONS -server
EXPOSE 8070
EXPOSE 8071
WORKDIR /opt/sonatype/iq-server
USER iq-server

CMD java \
  ${JVM_OPTIONS} \
  -jar nexus-iq-server-${IQ_VERSION}.jar \
  server /sonatype-work/config.yml
