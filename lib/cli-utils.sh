#!/usr/bin/env bash

# ##################################################
# CLI utilities for Bash
#
# VERSION 1.0.0
#
# HISTORY
#
# * 2018-04-04 - v1.0.0  - Initial version
#
# CONTRIBUTORS
#
# * Lennard Eijsackers
#
# DEPENDENCIES
#
# * var-utils.sh
# ##################################################

# ##################################################
# USER INPUT FUNCTIONS
# ##################################################


# Check if the confirmation (user_reply) is yes (y or Y)
# Usage: 
# if $(is_confirmed); then
# Return: Boolean
is_confirmed() {
    if [[ "$user_reply" =~ ^[Yy]$ ]]; 
    then
        echo true
    else
        echo false
    fi    
}

# Ask a user for confirmation
# Usage: 
# seek_confirmation "string message as question"
# if $(is_confirmed); then
# Return: Boolean
seek_confirmation() {
    echo "$@"
    read -p " (y/n) " -n 1 user_reply
    echo ""
}

#TODO forceable needs to be changed in forceable confirmation

# Ask a user for confirmation but checks for FORCED variable
# Usage: 
# forceable_confirmation "string message as question"
# if $(is_confirmed); then
# Return: Boolean
forceable_confirmation() {
    if $(is_var_set $FORCED); 
    then
        user_reply=y
    else
        seek_confirmation "$@"
    fi        
}