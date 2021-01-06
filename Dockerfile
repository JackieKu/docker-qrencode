FROM alpine:latest AS builder

RUN apk add --no-cache \
	build-base \
	automake \
	autoconf \
	libtool \
	popt-dev \
	git
RUN git clone --depth=1 https://github.com/rdoeffinger/iec16022 \
	&& cd iec16022 \
	&& ./autogen.sh \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install DESTDIR=/out

FROM alpine:latest

RUN apk add --no-cache libqrencode popt
COPY --from=builder /out /
