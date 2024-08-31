#!/usr/bin/env sh

set -xe

podman build . -t localhost/odin-static
podman run --name OdinBuild localhost/odin-static
podman cp OdinBuild:/Odin.zip .
podman rm --force OdinBuild
