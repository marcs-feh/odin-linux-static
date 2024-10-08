#!/usr/bin/env sh

directory="$1"
files="$(find $directory -name "*.dll" -o \
	-name "*.lib" -o \
	-name "*.obj" -o \
	-name "*.dynlib" -o \
	-name "*.dylib")"

for f in $files; do
	rm $f
done
