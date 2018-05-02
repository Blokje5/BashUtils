#!/usr/bin/env bash

# ##################################################
# Install utilities for Bash
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

# Usage: Check if brew exists
# Returns: Boolean
brew_installed() {
    if $(command_exists 'brew');
        then echo true
    else
        echo false    
    fi    
}

# Usage: maintain brew
brewMaintenance () {
  forceable_confirmation "Run Homebrew maintenance?"
  if is_confirmed; then
    brew doctor
    brew update
    brew upgrade --all
  fi
}

# Usage: Installs homebrew and its needed dependecies
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
            installXCodeCLI
            trace "Homebrew install"
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            trace "Homebrew install ended"
            trace "tapping brews"
            tapBrews
            trace "brews tapped"
        else
            # TODO neat exit
            debug "user declined installation"
            exit 1
        fi 
    fi
}

# Usage checks for the xcode cli tools
installXCodeCLI() {
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
}

# Usage: Tap into more brews
tapBrews() {
    brew tap caskroom/cask
    brew tap pivotal/tap #springboot
    brew tap caskroom/versions #java 8
}

# Usage: install ruby
install_ruby() {
    info "Checking for RVM (Ruby Version Manager)..."

    local RUBYVERSION="2.1.2" # Version of Ruby to install via RVM

    # Check for RVM
    if [ ! "$(command_exists rvm)" ]; then
        forceable_confirmation "Couldn't find RVM. Install it?"
        if is_confirmed; then
        curl -L https://get.rvm.io | bash -s stable
        source "${HOME}/.rvm/scripts/rvm"
        source "${HOME}/.bash_profile"
        #rvm get stable --autolibs=enable
        rvm install ${RUBYVERSION}
        rvm use ${RUBYVERSION} --default
        fi
    fi

    info "RVM and Ruby are installed"
}

  function doInstall () {
    # Reads a list of items, checks if they are installed, installs
    # those which are needed.
    #
    # Variables needed are:
    # LISTINSTALLED:  The command to list all previously installed items
    #                 Ex: "brew list" or "gem list | awk '{print $1}'"
    #
    # INSTALLCOMMAND: The Install command for the desired items.
    #                 Ex:  "brew install" or "gem install"
    #
    # RECIPES:      The list of packages to install.
    #               Ex: RECIPES=(
    #                     package1
    #                     package2
    #                   )
    #
    # Credit: https://github.com/cowboy/dotfiles
    # Credit: https://github.com/natelandau/shell-scripts
    function isAppInstalled() {
    # Feed this function either the bundleID (com.apple.finder) or a name (finder) for a native
    # mac app and it will determine whether it is installed or not
    #
    # usage: if isAppInstalled 'finder' &>/dev/null; then ...
    #
    # http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os

  local appNameOrBundleId="$1" isAppName=0 bundleId
    # Determine whether an app *name* or *bundle ID* was specified.
    [[ $appNameOrBundleId =~ \.[aA][pP][pP]$ || $appNameOrBundleId =~ ^[^.]+$ ]] && isAppName=1
    if (( isAppName )); then # an application NAME was specified
      # Translate to a bundle ID first.
      bundleId=$(osascript -e "id of application \"$appNameOrBundleId\"" 2>/dev/null) ||
        { echo "$FUNCNAME: ERROR: Application with specified name not found: $appNameOrBundleId" 1>&2; return 1; }
    else # a BUNDLE ID was specified
      bundleId=$appNameOrBundleId
    fi
      # Let AppleScript determine the full bundle path.
    osascript -e "tell application \"Finder\" to POSIX path of (get application file id \"$bundleId\" as alias)" 2>/dev/null ||
      { echo "$FUNCNAME: ERROR: Application with specified bundle ID not found: $bundleId" 1>&2; return 1; }
    }

    function to_install() {
      local desired installed i desired_s installed_s remain
      # Convert args to arrays, handling both space- and newline-separated lists.
      read -ra desired < <(echo "$1" | tr '\n' ' ')
      read -ra installed < <(echo "$2" | tr '\n' ' ')
      # Sort desired and installed arrays.
      unset i; while read -r; do desired_s[i++]=$REPLY; done < <(
        printf "%s\n" "${desired[@]}" | sort
      )
      unset i; while read -r; do installed_s[i++]=$REPLY; done < <(
        printf "%s\n" "${installed[@]}" | sort
      )
      # Get the difference. comm is awesome.
      unset i; while read -r; do remain[i++]=$REPLY; done < <(
        comm -13 <(printf "%s\n" "${installed_s[@]}") <(printf "%s\n" "${desired_s[@]}")
      )
      echo "${remain[@]}"
    }

    function checkInstallItems() {
      # If we are working with 'cask' we need to dedupe lists
      # since apps might be installed by hand
      if [[ $INSTALLCOMMAND =~ cask ]]; then
        if isAppInstalled "${item}" &>/dev/null; then
          continue
        fi
      fi
      # If we installing from mas (mac app store), we need to dedupe the list AND
      # sign in to the app store
      if [[ $INSTALLCOMMAND =~ mas ]]; then
        # Lookup the name of the application being installed
        appName="$(curl -s https://itunes.apple.com/lookup?id=$item | jq .results[].trackName)"
        if isAppInstalled "${appName}" &> /dev/null; then
          continue
        fi
      # Tell the user the name of the app
      info "$item --> $appName"
      fi
    }

    # Log in to the Mac App Store if using mas
    if [[ $INSTALLCOMMAND =~ mas ]]; then
        mas signout
        input "Please enter your Mac app store username: "
        read macStoreUsername
        input "Please enter your Mac app store password: "
        read -s macStorePass
        echo ""
        mas signin $macStoreUsername "$macStorePass"
    fi

    list=($(to_install "${RECIPES[*]}" "$(${LISTINSTALLED})"))

    if [ ${#list[@]} -gt 0 ]; then
      forceable_confirmation "Confirm each package before installing?"
      if $(is_confirmed); then
        for item in "${list[@]}"; do
          checkInstallItems
          forceable_confirmation "Install ${item}?"
          if $(is_confirmed); then
            info "Installing ${item}"
            ${INSTALLCOMMAND} "${item}"
          fi
        done
      else
        for item in "${list[@]}"; do
          checkInstallItems
          info "Installing ${item}"
          ${INSTALLCOMMAND} "${item}"
        done
      fi
    fi
  }

configureGit() {
  info "configuring Git settings"
  local directory="~/Git" # Personal preference.
  if [ ! -d "$directory" ]; then
    debug "Git directory made"
    mkdir -p $directory
  fi
  
  # Setup Git config  globally
  if $(command_exists 'git'); then
    debug "requesting git username & email"
    local git_user_name git_user_email
    read -p " enter your git username: " git_user_name
    echo ""
    read -p " enter your git email: " git_user_email
    echo ""
    debug "Setting git config"
    git config --global user.name "$git_user_name"
    git config --global user.email "$git_user_email"
    # Git password caching
    git config --global credential.helper osxkeychain
    info "Git is configured"
  else
    error "git is not available, please check git installation"
    exit 1
  fi
}

setupDotFiles() {
  info "setting up dotfiles"
  debug "symlink sources directory"
  local SOURCES_DIR=$(pwd)/.dotfiles
  for SOURCE in $(find "$SOURCES_DIR/sources" -name ".*");
  do
    ln -sfv $SOURCE ~
  done
  debug "symlink dotfiles directory"
  ln -sfv $SOURCES_DIR ~
  info "dotfiles linked"
}

setupMacOSDefaults() {
  info "setting up mac defaults"
  local SOURCES_DIR=$(pwd)/.dotfiles
  for MACOS_DEFAUTLS_FILE in $(find "$SOURCES_DIR/macos" -name "*.sh");
  do
    source $MACOS_DEFAUTLS_FILE
  done
  info "Finished setting up MACOS Defaults file"
}