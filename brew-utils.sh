#!/usr/bin/env bash

# ##################################################
# Brew utilities for Bash
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
#
# DEPENDENCIES
#
# * command-util.sh
# * logger.sh
# * cli-utils.sh
# ##################################################

# Source utilities
source $(pwd)/command-utils.sh #command utilities
source $(pwd)/logger.sh #logger
source $(pwd)/cli-utils.sh #cli utilities

brew_installed() {
    if $(command_exists 'brew');
        then echo true
    else
        echo false    
    fi    
}

install_brew() {
    info "Starting brew installation process"
    if $(brew_installed);
    then
        info "Brew is already installed"
    else
        debug "seeking confirmation for brew installation"
        forceable_confirmation "Install Homebrew?"
        if $(is_confirmed); 
        then
            if [[ ! $(command_exists 'gcc') ]];
            then
                debug "seeking confirmation for Xcode installation"
                info "XCode is needed before Homebrew can be installed"
                forceable_confirmation "Install XCode?"
                if $(is_confirmed); 
                then
                    trace "Xcode install"
                    xcode-select --install
                    trace "Xcode install ended"
                else
                    # TODO neat exit
                    debug "user declined installation"
                    exit 1
                fi
            fi    
            # TODO Brew Taps?
            trace "Homebrew install"
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            trace "Homebrew install ended"
        else
            # TODO neat exit
            debug "user declined installation"
            exit 1
        fi 
    fi
}
