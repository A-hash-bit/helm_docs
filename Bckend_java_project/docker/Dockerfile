FROM <base-image>

ARG version="9.0.43"
ENV JAVA_OPTS="-Djava.security.egd=file:///dev/urandom"
ENV CATALINA_BASE="/opt/apache-tomcat-${version}"
ENV CATALINA_HOME="/opt/apache-tomcat-${version}"
ENV CATALINA_PID="/opt/apache-tomcat-${version}/temp/tomcat.pid"
ENV CATALINA_OPTS="-Xms512M -Xmx10240M -server -XX:+UseParallelGC"
ENV PATH="/opt/apache-tomcat-${version}/bin:$PATH"

RUN yum --disableplugin=fastestmirror -y install wget && \
    wget https://archive.apache.org/dist/tomcat/tomcat-9/v${version}/bin/apache-tomcat-${version}.tar.gz && \
    yum -y remove wget adoptopenjdk-11-openj9 && \
    yum -y install adoptopenjdk-8-openj9 && \
    tar xvfz apache-tomcat-${version}.tar.gz && \
    mv apache-tomcat-${version} /opt && \
    chmod +x /opt/apache-tomcat-${version}/bin/*.sh && \
    ln -sf /opt/apache-tomcat-${version} /opt/tomcat && \
    rm -rf /opt/tomcat/webapps/docs && \
    rm -rf /opt/tomcat/webapps/examples && \
    rm -rf /opt/tomcat/webapps/manager  && \
    rm -rf /opt/tomcat/webapps/host-manager

RUN mkdir $CATALINA_HOME/omlibs


COPY  docker/tomcat-users.xml $CATALINA_BASE/conf/
COPY  docker/server.xml $CATALINA_BASE/conf/
COPY  docker/context.xml $CATALINA_BASE/conf/
COPY  docker/catalina.properties $CATALINA_BASE/conf/
COPY  docker/ojdbc8.jar $CATALINA_BASE/lib/
COPY  docker/redisson-tomcat-9-3.15.6.jar $CATALINA_BASE/lib/
COPY  docker/redisson-all-3.15.6.jar $CATALINA_BASE/lib/

COPY target/ordermanager.war $CATALINA_BASE/webapps/

COPY docker/entrypoint.sh /app/entrypoint.sh


RUN groupadd -g 3000 bigroup \
    && groupadd -g 511 admin \
    && useradd -u 3000 -m -d /opt/tomcat -s /bin/false -g 3000 -G admin biuser \
    && chown -R biuser:bigroup /opt/apache-tomcat-${version} \
    && chmod +x /app/entrypoint.sh

USER biuser

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
