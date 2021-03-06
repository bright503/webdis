FROM alpine:3.12.3 AS stage
LABEL maintainer="Nicolas Favre-Felix <n.favrefelix@gmail.com>"

RUN apk update && apk add wget make gcc libevent-dev msgpack-c-dev musl-dev bsd-compat-headers jq
COPY . /webdis
RUN cd webdis && make && make install && cd ..
RUN sed -i -e 's/"daemonize":.*true,/"daemonize": false,/g' /etc/webdis.prod.json

# main image
FROM alpine:3.12.3
RUN apk update && apk add libevent msgpack-c gettext
COPY --from=stage /usr/local/bin/webdis /usr/local/bin/
COPY --from=stage /etc/webdis.prod.json /etc/webdis.prod.json.template 
COPY docker-entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
EXPOSE 7379
ENTRYPOINT ["/entrypoint.sh"]
