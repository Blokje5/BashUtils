#!/usr/bin/env bash

# Setup environment variables
VERBOSITY=3 #INFO
LOGFILE="~/.maintenance_logfile.txt"
FORCED=1

#Create logfile
touch $LOGFILE

# Source utilities
for f in $(pwd)/lib/*.sh;
do
    source $f;
done;

info "Running maintenance on brew and dotfiles"

# Assume git is setup in this directory
git pull

# Run brew maintenance
brewMaintenance

# Setup dotfiles
setupDotFiles