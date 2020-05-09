#!/bin/sh

if [ "`echo ${1} | cut -c 1`" == "-" ]
then
	exec /usr/bin/borgmatic "$@"
fi

exec "$@"
