DOTFILES_DIR="$HOME/.dotfiles"
SYMLINK_DIR="$(readlink $DOTFILES_DIR)/bash"

for DOTFILE in "$(find $SYMLINK_DIR -name ".*")"; 
do
    source $DOTFILE
done