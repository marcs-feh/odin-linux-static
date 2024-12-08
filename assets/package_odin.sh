#!/usr/bin/env sh

set -xe

cd /
sh build_static.sh
sh remove_dlls.sh Odin
strip Odin/odin
zip -r -9 Odin.zip \
	Odin/odin Odin/base Odin/core Odin/vendor \
	Odin/src Odin/.gitignore \
	Odin/LICENSE Odin/README.md

mv Odin.zip Odin

