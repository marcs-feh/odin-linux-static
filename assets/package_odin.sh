#!/usr/bin/env sh

set -xe

cd /
sh build_static.sh
sh remove_dlls.sh Odin
strip Odin/odin
tar xJvf Odin.txz Odin
mv Odin.txz Odin

