#!/usr/bin/fish

starship init fish | source

# Custom greeting
function fish_greeting
    colorscript random
end

# Key bindings
bind \e\[3\;5~ kill-word
bind \e\[3\;3~ kill-word
bind \cH backward-kill-word

# Custom path folders
if [ -f ~/.shell_env ];
    source ~/.shell_env
end

# Add aliases
if [ -f ~/.shell_aliases ];
    source ~/.shell_aliases
end

# Add scripts
if [ -f ~/.shellrc ];
    source ~/.shellrc
end

