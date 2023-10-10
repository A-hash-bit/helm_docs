FROM <base image>

ARG CONTAINER_NAME
ARG ENV
ARG VERSION

ENV TZ=America/New_York

LABEL version="${VERSION}" \
      bi_maintainers="" \
      container_name="${CONTAINER_NAME}"      

#Copy node folder into nginx image
COPY build /usr/share/nginx/html
COPY docker/entrypoint.sh /app/

# create nginx user/group 
RUN set -x \
    && apk add bash curl tzdata \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -G nginx -g nginx nginx

#Add nginx conf
COPY nginx/nginx.conf /etc/nginx/conf.d/

#Changes needed to run process as nginx user
#Remove default conf
RUN if [ -f /etc/nginx/conf.d/default.conf ]; then rm /etc/nginx/conf.d/default.conf; fi
# config changes in default config file to allow nginx user to run the process
RUN sed -i -e '/listen/!b' -e '/5000;/!b' -e 's/5000;/5000;/' /etc/nginx/conf.d/nginx.conf \
    && sed -i -e '/user/!b' -e '/nginx/!b' -e '/nginx/d' /usr/local/openresty/nginx/conf/nginx.conf \
    && sed -i 's!/var/run/nginx.pid!/tmp/nginx.pid!g' /usr/local/openresty/nginx/conf/nginx.conf \
# Change folder permission
    && chmod 777 -R /usr/local/openresty/nginx /var/run/openresty

# expose port 5000 
EXPOSE 5000

#Add to PATH to run openrsty nginx as nginx user
RUN PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

#Change user to nginx
USER nginx

# start nginx
ENTRYPOINT ["/app/entrypoint.sh"]
