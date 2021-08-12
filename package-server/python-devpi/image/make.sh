#!/bin/bash

set -ex

TAG=devpi:5.5.0
REGISTRY=tmaxcloudck

TAG_REMOTE="$REGISTRY/$TAG"

docker build --no-cache --rm --network host -t $TAG .
docker tag $TAG $TAG_REMOTE
docker push $TAG_REMOTE
