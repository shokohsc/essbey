FROM registry.gamestream.biz/dimitri/base-s6:v0.1.0

# install packages
RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
    zlib \
    libzip-dev \
    jpeg \
    jpeg-dev \
    gcc \
    python3-dev \
    python3 \
    sqlite \
    musl-dev \
    sqlite \
	git

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8000
VOLUME /virt
