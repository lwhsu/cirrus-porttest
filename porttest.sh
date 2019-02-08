#!/bin/sh

set -ex

pwd

#cd /usr
#ls -a ports
#svnlite co svn://svn.freebsd.org/ports/head ports
cd /usr/ports
make update

df -h

cd /usr/ports/editors/libreoffice
make all-depends-list | awk -F'/' '{print $4"/"$5}' | xargs pkg install -y
