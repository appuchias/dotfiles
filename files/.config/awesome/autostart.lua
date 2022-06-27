local awful = require("awful")

-- Autostart
-- {{{
awful.spawn.with_shell("~/.screenlayout/enable_second_monitor.sh")
awful.spawn.with_shell("xautolock -time 10 -locker lock &")
awful.spawn.with_shell("noisetorch -i")
awful.spawn.with_shell("openrgb -p Huntsman")
awful.spawn.with_shell("picom --experimental-backends -b")
awful.spawn.with_shell("discord &")
awful.screen.focus_relative(1)
-- }}}

