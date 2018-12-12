FROM bearstech/java:latest

RUN apt-get update \
    && apt-get install -y apt-transport-https \
    && wget -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add - \
    && echo 'deb https://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list \
    && apt-get update \
    && apt-get install -y neo4j \
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

RUN usermod -u 1001 neo4j \
    && groupmod -g 1001 neo4j \
    && chown -R neo4j:neo4j /var/lib/neo4j \
    && chown -R neo4j:neo4j /var/log/neo4j \
    && ln -s /proc/self/fd/1 /var/log/neo4j/debug.log

USER neo4j

ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/share/neo4j/bin/neo4j", "console"]
