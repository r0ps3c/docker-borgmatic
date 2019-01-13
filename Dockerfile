FROM python:alpine as builder
ENV PYTHONUNBUFFERED 1
WORKDIR /wheels
RUN pip3 wheel borgmatic

FROM python:alpine
COPY --from=builder /wheels /wheels

RUN \
	apk --no-cache add borgbackup openssh-client bash && \
    	pip3 install -f /wheels borgmatic && \
    	rm -fr /var/cache/apk/* /wheels /.cache

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]
