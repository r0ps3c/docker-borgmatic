FROM python:alpine as builder
ENV PYTHONUNBUFFERED 1
RUN \
	apk --no-cache add build-base python3-dev && \
	pip3 wheel -w /wheels borgmatic

FROM v01d2/borgbackup
COPY --from=builder /wheels /wheels

RUN \
	apk --no-cache add openssh-client python3 && \
    	pip3 install -f /wheels borgmatic && \
    	rm -fr /var/cache/apk/* /wheels /.cache

WORKDIR /
ENTRYPOINT ["/usr/local/bin/borgmatic"]
