FROM alpine:3.20 AS Base
	RUN apk add --no-cache \
		musl-dev llvm18-dev clang18 git mold zip \
		libxml2-static llvm18-static zlib-static zstd-static

FROM Base AS Build
	WORKDIR /
	RUN git clone 'https://github.com/odin-lang/Odin' Odin
	WORKDIR /Odin
	COPY assets/build_static.sh build_static.sh
	RUN sh build_static.sh

FROM Build AS Package
	WORKDIR /Odin
	RUN mkdir -p ./Odin
	RUN mv odin LICENSE base core vendor Odin
	RUN zip -r Odin.zip Odin

	WORKDIR /
	COPY assets/entrypoint.c /entrypoint.c
	RUN clang-18 -std=c89 entrypoint.c -static -fPIC -o entrypoint

FROM Base AS Output
	WORKDIR /
	COPY --from=Package /Odin/Odin.zip /Odin.zip
	COPY --from=Package /entrypoint /entrypoint

ENTRYPOINT '/entrypoint'

