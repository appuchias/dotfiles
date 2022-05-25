#!/usr/bin/fish

starship init fish | source

# Custom path folders
fish_add_path ~/custompath/
fish_add_path ~/flutter/bin
fish_add_path ~/.dotfiles/
fish_add_path ~/.local/bin/

# Key bindings
# bind \e\[3\;5~ kill-word
# bind \cH backward-kill-word

# Add aliases
if [ -f ~/.shell_aliases ];
    source ~/.shell_aliases
end

# Add scripts
if [ -f ~/.shellrc ];
    source ~/.shellrc
end

# Custom greeting
function fish_greeting
    #colorscript -e colorview
    colorscript random
    #echo ""
end

# ENV
export SUDO_PROMPT='[sudo] %p : '
# export SUDO_PROMPT='sudo passwd: '
