FROM alpine:3.5

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="smizy/hbase" \
    org.label-schema.url="https://github.com/smizy" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/smizy/docker-cassandra"

ENV CASSANDRA_VERSION    $VERSION
ENV CASSANDRA_HOME       /usr/local/apache-cassandra-3.9
ENV CASSANDRA_CONFIG     ${CASSANDRA_HOME}/conf
ENV CASSANDRA_DATA_DIR   ${CASSANDRA_HOME}/data
ENV CASSANDRA_LOG_DIR    /var/lib/cassandra

ENV JAVA_HOME  /usr/lib/jvm/default-jvm
ENV PATH       $PATH:${JAVA_HOME}/bin:${CASSANDRA_HOME}/bin


RUN set -x \
    && apk --no-cache add \
        bash \
        openjdk8-jre \
        python \
        su-exec \
    && mirror_url=$( \
        wget -q -O - http://www.apache.org/dyn/closer.cgi/cassandra/ \
        | sed -n 's#.*href="\(http://ftp.[^"]*\)".*#\1#p' \
        | head -n 1 \
    ) \    
    && wget -q -O - ${mirror_url}/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
        | tar -xzf - -C /usr/local \
    ## comment out directory setting
    && sed -ri.bk 's/^# ([^ ]+directory:)/\1/g' ${CASSANDRA_CONFIG}/cassandra.yaml \
    && sed -ri.bk '/^# data_file_directories/,/^$/ s/^# //g' ${CASSANDRA_CONFIG}/cassandra.yaml \
    ## user/dir/permmsion
    && adduser -D  -g '' -s /sbin/nologin -u 1000 docker \
    && adduser -D  -g '' -s /sbin/nologin cassandra \
    && mkdir -p \
        ${CASSANDRA_DATA_DIR} \
        ${CASSANDRA_LOG_DIR} \
        ${CASSANDRA_HOME}/logs \
    && chown -R cassandra:cassandra \
        ${CASSANDRA_HOME} \
        ${CASSANDRA_LOG_DIR} \
        ${CASSANDRA_DATA_DIR} \
    && chmod 777 \
        ${CASSANDRA_DATA_DIR} \
        ${CASSANDRA_LOG_DIR} \
        ${CASSANDRA_HOME}/logs 

COPY entrypoint.sh  /usr/local/bin/

WORKDIR ${CASSANDRA_HOME}

VOLUME ["${CASSANDRA_HOME}"]

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160

ENTRYPOINT ["entrypoint.sh"]
CMD ["cassandra", "-f"]