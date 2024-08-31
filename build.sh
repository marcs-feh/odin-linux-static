#!/usr/bin/env sh

podman build . -t localhost/odin-static
podman run --name OdinBuild localhost/odin-static
podman cp OdinBuild:/Odin.zip .
podman rm --force OdinBuild
