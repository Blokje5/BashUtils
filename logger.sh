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
# ##################################################

# Source utilities
source $(pwd)/var-utils.sh #variable utilities
source $(pwd)/string-utils.sh #string utilities


# Log levels
quiet_level=0
error_level=1
warn_level=2
info_level=3
debug_level=4
trace_level=5

# Log message
# Usage: log 1 message
# Return: Unit
log() {
    local verbosity=$(__verbosity_level)
    # Only log if log verbosity is higher then verbosity level
    if [ $verbosity -ge $1 ]; then
        local logmessage=$(__log_format $1 $2)
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
error() { log 1 $1; }
warn() { log 2 $1; }
info() { log 3 $1; }
debug() { log 4 $1; }
trace() { log 5 $1; }

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

