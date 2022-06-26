local awful = require("awful")

-- Autostart
-- {{{
awful.screen.focus_relative(1)
awful.spawn.with_shell("noisetorch -i")
awful.spawn.with_shell("openrgb -p Huntsman")
awful.spawn.with_shell("picom --experimental-backends -b")
awful.spawn.with_shell("discord")
awful.spawn.with_shell("~/.screenlayout/enable_second_monitor.sh")
-- }}}

