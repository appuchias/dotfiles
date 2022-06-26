---------------------------
-- Appu awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
-- local themes_path = gfs.get_themes_dir()
local themes_path = "/home/appu/.config/awesome/themes/"

local background = "#1d1f21"
local current_line = "#282a2e"
local selection = "#373b41"
local foreground = "#c5c8c6"
local comment = "#969896"
local red = "#cc6666"
local orange = "#de935f"
local yellow = "#f0c674"
local green = "#b5bd68"
local aqua = "#8abeb7"
local blue = "#81a2be"
local purple = "#b294bb"

local theme = {}

theme.font          = "Fira Sans 8"

theme.bg_normal     = background
theme.bg_focus      = selection
theme.bg_urgent     = red
theme.bg_minimize   = current_line
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = foreground
theme.fg_focus      = foreground
theme.fg_urgent     = foreground
theme.fg_minimize   = comment

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = current_line
theme.border_focus  = blue
theme.border_marked = orange

-- There are other variable sets
-- overriding the appu one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
theme.taglist_bg_focus = yellow
theme.taglist_fg_focus = current_line

-- Generate taglist squares:
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.taglist_fg_focus
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_fg     = theme.fg_normal
theme.notification_bg     = theme.bg_normal
-- theme.notification_width  = dpi(200)
-- theme.notification_height = dpi(100)
theme.notification_margin = dpi(4)
theme.notification_border_color = red
theme.notification_border_width = dpi(2)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."appu/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)
theme.menu_border_width = dpi(0)

-- -- Define the image to load
-- theme.titlebar_close_button_normal = themes_path.."appu/titlebar/close_normal.png"
-- theme.titlebar_close_button_focus  = themes_path.."appu/titlebar/close_focus.png"
--
-- theme.titlebar_minimize_button_normal = themes_path.."appu/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus  = themes_path.."appu/titlebar/minimize_focus.png"
--
-- theme.titlebar_ontop_button_normal_inactive = themes_path.."appu/titlebar/ontop_normal_inactive.png"
-- theme.titlebar_ontop_button_focus_inactive  = themes_path.."appu/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_active = themes_path.."appu/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_active  = themes_path.."appu/titlebar/ontop_focus_active.png"
--
-- theme.titlebar_sticky_button_normal_inactive = themes_path.."appu/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive  = themes_path.."appu/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active = themes_path.."appu/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active  = themes_path.."appu/titlebar/sticky_focus_active.png"
--
-- theme.titlebar_floating_button_normal_inactive = themes_path.."appu/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = themes_path.."appu/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = themes_path.."appu/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  = themes_path.."appu/titlebar/floating_focus_active.png"
--
-- theme.titlebar_maximized_button_normal_inactive = themes_path.."appu/titlebar/maximized_normal_inactive.png"
-- theme.titlebar_maximized_button_focus_inactive  = themes_path.."appu/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_active = themes_path.."appu/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_active  = themes_path.."appu/titlebar/maximized_focus_active.png"

-- theme.wallpaper = themes_path.."appu/background.png"
theme.wallpaper = "/home/appu/Pictures/backgrounds/Mountains/geoffrey-price-8CuVNSQ3RS4-unsplash.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."appu/layouts/fairhw.png"
theme.layout_fairv = themes_path.."appu/layouts/fairvw.png"
theme.layout_floating  = themes_path.."appu/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."appu/layouts/magnifierw.png"
theme.layout_max = themes_path.."appu/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."appu/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."appu/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."appu/layouts/tileleftw.png"
theme.layout_tile = themes_path.."appu/layouts/tilew.png"
theme.layout_tiletop = themes_path.."appu/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."appu/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."appu/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."appu/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."appu/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."appu/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."appu/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_normal, theme.fg_normal
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
