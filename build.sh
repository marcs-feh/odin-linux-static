#!/usr/bin/env sh

case "$1" in
	"include-sources") includeSources=1 ;;
esac

set -e

[ -d "Odin" ] \
	|| git clone https://github.com/odin-lang/Odin Odin

podman build . -t 'localhost/odin-linux-static'
podman run --rm --name OdinBuild -v $(pwd)/Odin:/Odin 'localhost/odin-linux-static'
mv 'Odin/Odin.zip' .

podman rm --force OdinBuild
rm -f "$ODIN_ARCHIVE"

if [ ! -z $includeSources ]; then
	echo "Adding source to archive"
	zip -r Odin.zip Odin/src
fi

