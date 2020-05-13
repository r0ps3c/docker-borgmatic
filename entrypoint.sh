#!/bin/sh

if [ "`echo ${1} | cut -c 1`" == "-" ]
then
	exec /usr/local/bin/borgmatic "$@"
fi

exec "$@"
