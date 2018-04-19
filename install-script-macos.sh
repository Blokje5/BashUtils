#!/usr/bin/env bash

# Setup environment variables
VERBOSITY=3 #INFO
LOGFILE="~/.installation_logfile.txt"
FORCED=1

#Create logfile
touch $LOGFILE

# Source utilities
for f in $(pwd)/lib/*.sh;
do
    source $f;
done;

info "This script will setup a new OSX environment"

# installing ruby before brew
install_ruby

# installing brew
install_brew

# installing brews
function installHomebrewPackages() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    notice "Checking for Homebrew packages to install..."

    LISTINSTALLED="brew list"
    INSTALLCOMMAND="brew install"

    RECIPES=(
        p7zip
        awscli
        git
        jq
        node
        sbt@1
        springboot
        wget
    )
    doInstall

    info "Done installing Homebrew packages"
}

installHomebrewPackages

# installing casks
function installCaskApps() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    info "Checking for casks to install..."

    LISTINSTALLED="brew cask list"
    INSTALLCOMMAND="brew cask install --appdir=/Applications"
    RECIPES=(
        docker
        firefox
        flux
        google-chrome
        intellij-idea
        iterm2
        java
        postman
        python
        visual-studio-code
        visualvm
    )

    doInstall

    info "Done installing cask apps"
}

installCaskApps

# installing npm libraries
function installNPMLibraries() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    info "installing global npm packages"

    LISTINSTALLED="npm list -g --depth 0"
    INSTALLCOMMAND="npm install -g"
    RECIPES=(
        typescript
        @angular/cli
    )

    doInstall

    info "Done installing npm libraries"
}

installNPMLibraries

#Configure git
configureGit

# Setup VSCode packages
function installVSCodeExtensions() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    info "installing VS Code extensions"

    LISTINSTALLED="code --list-extensions"
    INSTALLCOMMAND="code --install-extension"
    RECIPES=(
        docsmsft.docs-authoring-pack
        docsmsft.docs-markdown
        steoates.autoimports
    )

    doInstall

    info "Done installing VS Code extensions"
}

installVSCodeExtensions

# Setup DotFiles
setupDotFiles