#!/usr/bin/env bash

# ##################################################
# String utilities for Bash
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

# Check if a string is empty or not
# Usage: string_non_empty $string
# Return: Boolean
is_string_non_empty() {
    if [ ! -z $1 ] && [ $1 != " " ]; 
        then echo true
    else
        echo false
    fi
}