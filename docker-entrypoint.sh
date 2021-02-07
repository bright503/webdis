#!/bin/sh
envsubst < /etc/webdis.prod.json.template > /etc/webdis.prod.json
/usr/local/bin/webdis /etc/webdis.prod.json
