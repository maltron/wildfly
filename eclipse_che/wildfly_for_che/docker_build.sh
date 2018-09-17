#!/bin/bash
set -xe
docker build --rm=true --no-cache --force-rm --tag docker.io/maltron/wildfly-che:latest .
docker push docker.io/maltron/wildfly-che:latest
