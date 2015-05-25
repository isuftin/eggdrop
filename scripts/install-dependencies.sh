#!/bin/bash -ex

apt-get update

apt-get install -y wget build-essential libtcl8.6 libtcl8.6-dbg tcl8.6-dev

apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y
