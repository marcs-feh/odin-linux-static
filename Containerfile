FROM alpine:3.20 AS Base
	RUN apk add --no-cache \
		musl-dev llvm18-dev clang18 git mold zip lz4 \
		libxml2-static llvm18-static zlib-static zstd-static

FROM Base AS Build
ARG ODIN_ARCHIVE
	WORKDIR /
	WORKDIR /Odin
	COPY ${ODIN_ARCHIVE} odin-source.tar.zst
	RUN zstd -d odin-source.tar.zst -c | tar xf -

	COPY assets/build_static.sh build_static.sh
	RUN sh build_static.sh

FROM Build AS Package
	WORKDIR /Odin
	RUN mkdir -p ./Odin
	RUN mv odin LICENSE base core vendor Odin
	COPY assets/remove_dlls.sh remove_dlls.sh
	RUN sh remove_dlls.sh Odin
	RUN zip -9 -r Odin.zip Odin

	WORKDIR /
	COPY assets/entrypoint.c /entrypoint.c
	RUN clang-18 -std=c89 entrypoint.c -static -fPIC -o entrypoint

FROM Base AS Output
	WORKDIR /
	COPY --from=Package /Odin/Odin.zip /Odin.zip
	COPY --from=Package /entrypoint /entrypoint

ENTRYPOINT '/entrypoint'

