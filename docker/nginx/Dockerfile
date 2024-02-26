FROM nginx:alpine

ARG DOCKER_UID

RUN set -eux; \
    apk --update add shadow; \
    \
    usermod -u $DOCKER_UID nginx; \
    \
    apk del shadow; \
    rm -rf /var/cache/apk

EXPOSE 443
