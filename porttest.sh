#!/bin/sh

set -ex

pwd

#cd /usr
#ls -a ports
#svnlite co svn://svn.freebsd.org/ports/head ports
cd /usr/ports
make update

df -h

#cd /usr/ports/editors/libreoffice
#make all-depends-list | awk -F'/' '{print $4"/"$5}' | xargs pkg install -y

echo "NO_ZFS=yes" >> /usr/local/etc/poudriere.conf
echo "ALLOW_MAKE_JOBS=yes" >> /usr/local/etc/poudriere.conf
sed -i.bak -e 's,FREEBSD_HOST=_PROTO_://_CHANGE_THIS_,FREEBSD_HOST=https://download.FreeBSD.org,' /usr/local/etc/poudriere.conf

poudriere jail -c -j jail -v `uname -r`
poudriere ports -c -f none -m null -M /usr/ports

# use an easy port to bootstrap pkg repo
poudriere bulk -t -j jail net/nc

cd /usr/ports
cd editors/libreoffice
PWD=`pwd -P`
PORTDIR=`dirname ${PWD}`
PORTDIR=`dirname ${PORTDIR}`
make all-depends-list | sed -e "s,${PORTDIR}/,," | xargs sudo pkg fetch -y -o pkgs
mv pkgs/All/* /usr/local/poudriere/data/packages/jail-default/.latest/all/
rm -fr pkgs

poudriere testport -j jail editors/libreoffice
