#!/usr/bin/env bash

# ##################################################
# Bash Logger
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
#
# DEPENDENCIES
#
# * var-utils
# * string-utils
# ##################################################

#Optional global variables
#LOGFILE: Location of file to place logs in
#VERBOSITY: Int level from 0-5 to indicate verbosity to log on

# Log levels
quiet_level=0
error_level=1
warn_level=2
info_level=3
debug_level=4
trace_level=5

# Private function Log message
# Usage: 
# local __message="log message";
# log 1
# Return: Unit
log() {
    local verbosity=$(__verbosity_level)
    # Only log if log verbosity is higher then verbosity level
    if [ $verbosity -ge $1 ]; then
        local logmessage=$(__log_format $1 "${__message}")
        #if LOGFILE is not empty or space, append
        if $(is_string_non_empty $LOGFILE); 
            then echo -e  $logmessage >> $LOGFILE
        else
            # to stdout
            echo -e $logmessage >&1
        fi
    fi
}

# Helper functions
# Usage:
# function logMessage
error() { local __message=${*}; log 1; }
warn() { local __message=${*}; log 2; }
info() { local __message=${*}; log 3; }
debug() { local __message=${*}; log 4; }
trace() { local __message=${*}; log 5; }

# Private function, format log
__log_format() {
    local currentdate=`date +'%Y-%m-%d %H:%M:%S'`
    local verbosity=$(__log_level $1)
    echo "$currentdate $verbosity $2"
}

# Private function, return the correct log level tag
__log_level() {
    local verbosity="$(__verbosity_level)"
    if [ $1 -eq $error_level ]; then local verbosity="ERROR"; fi
    if [ $1 -eq $warn_level ]; then local verbosity="WARNING"; fi
    if [ $1 -eq $info_level ]; then local verbosity="INFO"; fi
    if [ $1 -eq $debug_level ]; then local verbosity="DEBUG"; fi
    if [ $1 -eq $trace_level ]; then local verbosity="TRACE"; fi
    echo $verbosity
}

#private function, check if VERBOSITY is set, otherwise return default
__verbosity_level() {
    local verbosity=3;
    if $(is_var_set $VERBOSITY); 
        then echo $VERBOSITY
    else    
        echo $verbosity
    fi
}

