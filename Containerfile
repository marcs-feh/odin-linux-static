FROM alpine:3.20 AS Base
	RUN apk add --no-cache \
		musl-dev llvm18-dev clang18 git mold zip lz4 \
		libxml2-static llvm18-static zlib-static zstd-static

FROM Base AS SetupScripts
	WORKDIR /Odin
	COPY assets/build_static.sh /
	COPY assets/package_odin.sh /
	COPY assets/remove_dlls.sh /

FROM SetupScripts AS Build
	WORKDIR /
	ENTRYPOINT ["sh", "/package_odin.sh"]


