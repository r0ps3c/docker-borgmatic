ARG BORGMATIC_VER=1.9.14 # set default value
FROM ghcr.io/r0ps3c/docker-borgbackup AS build
ARG BORGMATIC_VER # Redeclare to make it available
ENV PYTHONUNBUFFERED=1
RUN \
	apk --no-cache add python3-dev py3-pip py3-wheel py3-packaging py3-build git && \
	wget -q https://projects.torsion.org/borgmatic-collective/borgmatic/archive/${BORGMATIC_VER}.tar.gz && \
	tar xf ${BORGMATIC_VER}.tar.gz && \
	cd borgmatic && \
	python3 -m build

FROM ghcr.io/r0ps3c/docker-borgbackup
COPY --from=build /borgmatic/dist /dist
RUN \
	apk --no-cache add py3-pip  && \
    pip install --break-system-packages --find-links /dist borgmatic  && \
	apk del py3-pip py3-pip-pyc && \
    rm -fr /var/cache/apk/* /dist /.cache

WORKDIR /
ENTRYPOINT ["/usr/bin/borgmatic"]
