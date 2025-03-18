FROM alpine

RUN \
	apk --no-cache add borgmatic && \
    rm -fr /var/cache/apk/* /wheels /.cache

WORKDIR /
ENTRYPOINT ["/usr/bin/borgmatic"]
