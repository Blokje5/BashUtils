#!/usr/bin/env bash

#Source utilities
for f in $(pwd)/lib/*.sh;
do
    source $f;
done;

info "This script will setup a new OSX environment"

# installing brew
install_brew