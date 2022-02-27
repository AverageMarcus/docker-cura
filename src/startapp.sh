#!/bin/sh

mkdir -p /app/cura/config
mkdir -p /app/cura/data

export HOME=/home
exec /opt/cura/usr/bin/cura.sh
