#!/bin/bash -ex

mkdir /tmp/eggdrop

cd /tmp/eggdrop

wget ftp://ftp.eggheads.org/pub/eggdrop/source/eggdrop-latest.tar.gz

tar xvf eggdrop-latest.tar.gz --strip 1

./configure --with-tcllib=/usr/lib/x86_64-linux-gnu/libtcl8.6.so --with-tclinc=/usr/include/tcl8.6/tcl.h

make config && make && make install DEST=/home/${eggdrop_user}/

cd /tmp

rm -rf eggdrop

