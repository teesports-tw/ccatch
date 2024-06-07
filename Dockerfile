FROM alpine:latest AS build

RUN apk add --no-cache \
	cmake \
	curl-dev \
	g++ \
	gcc \ 
	libpng-dev \
	libwebsockets-dev \
	mariadb-dev \
	ninja \
	python3 \
	sqlite-dev

COPY  . /tw
WORKDIR /tw/build

RUN cmake .. -Wno-dev \
	-DANTIBOT=ON \
	-DAUTOUPDATE=OFF \
	-DCLIENT=OFF \
	-DIPO=ON \
	-DDEV=ON \
	-DPREFER_BUNDLED_LIBS=OFF \
	-DVIDEORECORDER=OFF \
	-DVULKAN=OFF \
	-DWEBSOCKETS=ON \
	-DMYSQL=ON \
	-GNinja

RUN ninja

# ---

FROM alpine:latest

RUN apk update && apk add --no-cache \
	libcurl \
	libstdc++ \
	libwebsockets \
	mariadb-connector-c \
	sqlite-libs
	
COPY --from=build /tw/build /tw

WORKDIR /tw/data

ENTRYPOINT ["/tw/ccatch_srv"]
