FROM bitnami/nginx

COPY paths.conf /opt/bitnami/nginx/conf/paths.conf
COPY healthcheck.conf /opt/bitnami/nginx/conf/server_blocks/healthcheck.conf

ENV NGINX_HTTP_PORT_NUMBER=5000

EXPOSE 5000