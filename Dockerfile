FROM python:alpine as builder
ENV PYTHONUNBUFFERED 1
ENV VER 1.1.11
RUN \
	apk --no-cache add build-base python3-dev acl-dev attr-dev openssl-dev linux-headers libffi-dev && \
	wget https://github.com/borgbackup/borg/releases/download/$VER/borgbackup-$VER.tar.gz && \
	tar xf borgbackup-$VER.tar.gz && \
	cd borgbackup-$VER && \
	pip3 install -r requirements.d/development.txt && \
	pip3 wheel -w /wheels . && \
	pip3 wheel -w /wheels borgmatic

FROM python:alpine
COPY --from=builder /wheels /wheels

RUN \
	apk --no-cache add openssh-client libacl && \
    	pip3 install -f /wheels borgbackup borgmatic && \
    	rm -fr /var/cache/apk/* /wheels /.cache

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]
