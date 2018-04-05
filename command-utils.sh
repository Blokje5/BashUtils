#!/usr/bin/env bash

# ##################################################
# Command utilities for Bash
#
# VERSION 1.0.0
#
# HISTORY
#
# * 2018-04-03 - v1.0.0  - Initial version
#
# CONTRIBUTORS
#
# * Lennard Eijsackers
# ##################################################

# Check if a command is available or not
# See https://unix.stackexchange.com/questions/101599/bash-what-is-the-use-of-type-bash-builtins
# Usage: command_exists $command
# Return: Boolean
command_exists() {
  if [ ! -z "$(type -P "$1")" ]; 
    then echo true
  else
    echo false
  fi
}