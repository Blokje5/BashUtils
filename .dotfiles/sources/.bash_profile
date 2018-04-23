DOTFILES_DIR="$HOME/.dotfiles"
SYMLINK_DIR="$(readlink $DOTFILES_DIR)/bash"

for DOTFILE in $SYMLINK_DIR/.{alias,exports,functions}; 
do
    source $DOTFILE
done