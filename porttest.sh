#!/bin/sh

set -ex

pwd

cd /usr
svnlite co svn://svn.freebsd.org/ports/head ports

df -h

cd /usr/ports/editors/libreoffice
make all-depends-list | awk -F'/' '{print $4"/"$5}' | xarge pkg install -y
