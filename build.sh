#!/usr/bin/env sh

odinRelease="master"

case "$1" in
	"include-sources") includeSources=1 ;;
	*) echo "Unkown option '$1'" && exit 1 ;;
esac

set -e

ODIN_ARCHIVE="odin-$odinRelease.tar.zst"

[ -d "Odin" ] \
	|| git clone https://github.com/odin-lang/Odin Odin

if [ ! -f "$ODIN_ARCHIVE" ]; then
	cd Odin
	git archive "$odinRelease" --format=tar | zstd -1 -T0 -o ../"$ODIN_ARCHIVE"
	cd ..
fi

podman build . -t localhost/odin-static --build-arg ODIN_ARCHIVE="$ODIN_ARCHIVE"
podman run --name OdinBuild localhost/odin-static
podman cp OdinBuild:/Odin.zip .

podman rm --force OdinBuild
rm -f "$ODIN_ARCHIVE"

if [ ! -z $includeSources ]; then
	mv Odin/src .
	zip -r Odin.zip src
	mv src Odin
fi
