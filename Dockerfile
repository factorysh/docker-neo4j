FROM bearstech/java:1.8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https \
    && wget -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add - \
    && echo 'deb https://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends neo4j \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# http
EXPOSE 7474
# bolt
EXPOSE 7687

ENV NEO4J_CONF=/etc/neo4j
ENV NEO4J_HOME=/var/lib/neo4j
VOLUME /var/lib/neo4j/data

COPY entrypoint.sh /usr/local/bin/
COPY neo4j.conf /etc/neo4j/neo4j.conf

RUN set -eux \
    && usermod -u 1001 neo4j \
    && groupmod -g 1001 neo4j \
    && chown -R neo4j:neo4j /var/lib/neo4j \
    && chown -R neo4j:neo4j /var/log/neo4j \
    && ln -s /proc/self/fd/1 /var/log/neo4j/debug.log

USER neo4j


ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/share/neo4j/bin/neo4j", "console"]

# generated labels

ARG GIT_VERSION
ARG GIT_DATE
ARG BUILD_DATE

LABEL \
    com.bearstech.image.revision_date=${GIT_DATE} \
    org.opencontainers.image.authors=Bearstech \
    org.opencontainers.image.revision=${GIT_VERSION} \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.url=https://github.com/factorysh/docker-neo4j \
    org.opencontainers.image.source=https://github.com/factorysh/docker-neo4j/blob/${GIT_VERSION}/Dockerfile
