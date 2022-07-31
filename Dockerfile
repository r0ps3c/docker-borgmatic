FROM alpine as build
ENV PYTHONUNBUFFERED 1
RUN \
	apk --no-cache add build-base python3-dev py3-pip pkgconfig && \
	pip3 install wheel && \
	pip3 wheel -w /wheels borgmatic

FROM ghcr.io/r0ps3c/docker-borgbackup:master
COPY --from=build /wheels /wheels

RUN \
    	pip3 install --find-links /wheels borgmatic && \
    	rm -fr /var/cache/apk/* /wheels /.cache

WORKDIR /
ENTRYPOINT ["/usr/bin/borgmatic"]
