#!/usr/bin/env bash

# ##################################################
# Variable utilities for Bash
#
# VERSION 1.0.0
#
# HISTORY
#
# * 2018-03-28 - v1.0.0  - Initial version
#
# CONTRIBUTORS
#
# * Lennard Eijsackers
# ##################################################

# Check if a variable is empty or not
# See https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
# Usage: string_non_empty $string
# Return: Boolean
is_var_set() {
    if [ ! -z ${1+x} ]; 
        then echo true
    else    
        echo false
    fi
}

