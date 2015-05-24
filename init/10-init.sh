#!/bin/bash -ex

if [ "${scripts_directory}" != "scripts/" ]; then
    cp scripts/* ${scripts_directory}
fi