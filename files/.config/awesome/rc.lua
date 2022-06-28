-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Dpi setting
local dpi = require('beautiful').xresources.apply_dpi
-- Lain
local lain = require("lain")

-- {{{ My imports
require("autostart")
-- local spotify = require("modules.spotify")
local vars = require("modules.rc_vars")
-- local globalkeys = require("modules.rc_keys")
-- }}}


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- Themes define colours, icons, font and wallpapers.
local theme_path = string.format("%s/.config/awesome/themes/appu/theme.lua", os.getenv("HOME"))
beautiful.init(theme_path)

-- local terminal = "kitty"
-- local editor = os.getenv("EDITOR") or "nvim"
-- local cmd_editor = terminal .. " -e " .. editor
-- local cmd_spotify = "spotify"
-- local cmd_file_explorer = "thunar"
-- local cmd_browser = "firefox"
-- local cmd_discord = "discord"
-- local cmd_screenshot = "flameshot gui"
-- local cmd_rofi = "rofi -show run"
-- local cmd_rofi_combi = "rofi -show combi"

local terminal = vars.terminal
-- local editor = vars.editor
local cmd_browser = vars.cmd_browser
local cmd_spotify = vars.spotify
local cmd_file_explorer = vars.cmd_file_explorer
local cmd_discord = vars.cmd_discord
-- local cmd_screenshot = vars.cmd_screenshot
local cmd_rofi = vars.cmd_rofi
local cmd_rofi_combi = vars.cmd_rofi_combi

-- Default modkey.
-- modkey = "Mod4"
local modkey = vars.modkey

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
keyboard_layout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create widgets

-- Create a wibox for each screen and add it
taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
                )

tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 2, function (c) c:kill() end),
                     awful.button({ }, 3, function ()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))


mytextclock = wibox.widget{
   widget = wibox.widget.textclock,
   format = " %d %b %H:%M (%a) ",
   refresh = 30
}
calendarwidget = lain.widget.cal({
  followtag = true,
  week_number = "left",
  attach_to = { mytextclock },
  notification_preset = {
    font = beautiful.font_big,
    fg = beautiful.fg_focus,
    bg = beautiful.bg_focus,
    border_color = beautiful.separator,
  }
})

separator = wibox.widget {
  widget       = wibox.widget.separator,
  orientation  = "horizontal",
  forced_width = 30,
  color        = beautiful.separator,
  shape        = gears.shape.powerline
}

separator_empty = wibox.widget {
  widget       = wibox.widget.separator,
  orientation  = "horizontal",
  forced_width = 10,
  color        = beautiful.bg_normal,
}

separator_flex = wibox.widget {
  widget       = wibox.widget.separator,
  orientation  = "horizontal",
  color        = beautiful.bg_normal,
  layout       = wibox.layout.flex.horizontal
}

separator_reverse = wibox.widget {
  widget       = wibox.widget.separator,
  orientation  = "horizontal",
  forced_width = 30,
  span_ratio   = 0.7,
  color        = beautiful.separator,
  set_shape    = function(cr, width, height)
    gears.shape.powerline(cr, width, height, (height / 2) * (-1))
  end
}

-- Wallpaper painter function
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Tags
    local names = { "I", "II", "III", "IV", "V" }
    local l = awful.layout.suit
    awful.tag(names, s, l.tile)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    taglist_width = dpi(200)
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      style   = {
          shape = gears.shape.powerline,
      },
      layout   = {
          spacing = -10,
          spacing_widget = {
              color  = beautiful.bg_normal,
              shape  = gears.shape.powerline,
              widget = wibox.widget.separator,
          },
          layout  = wibox.layout.flex.horizontal,
          forced_width = taglist_width
      },
      widget_template = {
          {
              {
                  {
                      id     = 'text_role',
                      widget = wibox.widget.textbox,
                  },
                  layout = wibox.layout.flex.horizontal,
              },
              left  = 20,
              right = 10,
              widget = wibox.container.margin
          },
          id     = 'background_role',
          widget = wibox.container.background,
      },
      buttons = taglist_buttons
    }

    -- create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      style   = {
          shape = gears.shape.powerline
      },
      layout   = {
          spacing = -10,
          spacing_widget = {
              color  = beautiful.bg_normal,
              shape  = gears.shape.powerline,
              widget = wibox.widget.separator,
          },
          -- forced_width = taglist_width * 5,
          layout  = wibox.layout.fixed.horizontal,
      },
      widget_template = {
          {
              {
                  {
                      {
                          id     = "icon_role",
                          widget = wibox.widget.imagebox,
                      },
                      margins = 2,
                      widget  = wibox.container.margin,
                  },
                  {
                      id     = 'text_role',
                      widget = wibox.widget.textbox,
                  },
                  layout = wibox.layout.fixed.horizontal,
              },
              left  = 12,
              right = 18,
              widget = wibox.container.margin,
          },
          id     = 'background_role',
          widget = wibox.container.background,
      },
      buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- awesome_launcher,
            separator,
            s.mytaglist,
            s.mypromptbox,
            -- separator,
            -- s.mytasklist,
        },
        {
            layout = wibox.layout.align.horizontal,
            separator,
            s.mytasklist,
            separator_flex,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            separator_reverse,
            wibox.widget.systray(),
            separator_reverse,
            keyboard_layout,
            mytextclock,
            separator_reverse,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- -- {{{ Mouse bindings
-- root.buttons(gears.table.join(
--     awful.button({ }, 3, function () right_menu:toggle() end),
--     awful.button({ }, 4, awful.tag.viewnext),
--     awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- -- }}}

-- Key bindings {{{
globalkeys = gears.table.join(
    -- Standard programss
    awful.key({ modkey,           }, "Return",  function () awful.spawn(terminal)                       end,
              {description = "Open Terminal",                   group = "programs"}),
    awful.key({ modkey,           }, "f",       function () awful.spawn(cmd_browser)                    end,
              {description = "Open Web browser",                group = "programs"}),
    awful.key({ modkey,           }, "e",       function () awful.spawn(cmd_file_explorer)              end,
              {description = "Open File explorer",              group = "programs"}),
    awful.key({ modkey,           }, "s",       function () awful.spawn(cmd_spotify)                    end,
              {description = "Open Spotify",                    group = "programs"}),
    awful.key({ modkey,           }, "d",       function () awful.spawn(cmd_discord)                    end,
              {description = "Open Discord",                    group = "programs"}),
    awful.key({ modkey,           }, "v",       function () awful.spawn("code")                         end,
              {description = "Open VS Code",                    group = "programs"}),
    awful.key({ modkey            },  "r",      function () awful.spawn(cmd_rofi)                       end,
              {description = "Run rofi",                        group = "programs"}),
    awful.key({ modkey, "Shift"   }, "Return",  function () awful.spawn(cmd_rofi_combi)                 end,
              {description = "Run rofi-multi",                  group = "programs"}),
    -- awful.key({ modkey, "Shift"    }, "s",      function () awful.spawn(cmd_screenshot)                 end,
    --           {description = "Take a screenshot",               group = "programs"}),
    awful.key({                    }, "Print",  function () awful.spawn("flameshot gui")                end,
              {description = "Region screenshot using fs GUI",  group = "programs"}),
    awful.key({ modkey,            }, "Print",  function () awful.spawn("flameshot full")                 end,
              {description = "Screenshot the full desktop",     group = "programs"}),
    -- awful.key({ modkey, "Control"  }, "Print",  function () awful.spawn(cmd_screenshot)                 end,
    --           {description = "Screenshot the current screen",   group = "programs"}),
    awful.key({ modkey, "Shift"    }, "r",      function () awful.spawn("openrgb -p Huntsman")          end,
              {description = "Set the keyboard properly",       group = "programs"}),
    awful.key({ modkey,            }, "b",      function () awful.spawn("kitty -e btop")                end,
              {description = "Open btop in a kitty term",       group = "programs"}),

    -- Tag toggling
    awful.key({ modkey,           }, "Left",    awful.tag.viewprev,
              {description = "Move to next tab",                group = "tag"}),
    awful.key({ modkey,           }, "Right",   awful.tag.viewnext,
              {description = "Move to prev tab",                group = "tag"}),
    awful.key({ modkey,           }, "Escape",  awful.tag.history.restore,
              {description = "Go to prev tab",                  group = "tag"}),

    -- Client cycling
    awful.key({ modkey,           }, "Up",      function () awful.client.focus.byidx(-1)                end,
              { description = "Cycle through clients",          group = "client"}),
    awful.key({ modkey,           }, "Down",    function () awful.client.focus.byidx( 1)                end,
              { description = "Cycle through clients",          group = "client"}),
    awful.key({ "Mod1",           }, "Tab",     function () awful.client.focus.byidx( 1)                end,
              { description = "Cycle through clients",          group = "client"}),

    -- Layout manipulation
    awful.key({ modkey, "Control" }, "Left",    function () awful.client.swap.byidx(  1)                end,
              {description = "Swap client with next one",       group = "client"}),
    awful.key({ modkey, "Control" }, "Right",   function () awful.client.swap.byidx( -1)                end,
              {description = "Swap client with previous one",   group = "client"}),
    awful.key({ modkey, "Control" }, "j",       function () awful.client.swap.byidx( 1)                 end,
              {description = "Swap with next client",           group = "client"}),
    awful.key({ modkey, "Control" }, "k",       function () awful.client.swap.byidx(-1)                 end,
              {description = "Swap with previous client",       group = "client"}),
    awful.key({ modkey,           }, "space",   function () awful.layout.inc(1)                         end,
              {description = "Change layout",                   group = "client"}),
    awful.key({ modkey,           }, "u",       function () awful.client.urgent:jumpto()                end,
              {description = "Jump to urgent client",           group = "client"}),

    -- Awesome
    awful.key({ modkey, "Control" }, "r",       awesome.restart,
              {description = "Reload awesome",                  group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "c",       awesome.quit,
              {description = "Quit awesome",                    group = "awesome"}),
    awful.key({ modkey, "Control" }, "s",       hotkeys_popup.show_help,
              {description="Show help",                         group="awesome"}),
    awful.key({ modkey, "Shift"   }, "Up",      function () awful.screen.focus_relative(1)              end,
              {description = "Toggle focused screen",           group = "awesome"}),
    awful.key({ modkey,           }, "l",       function () awful.spawn("lock")                         end,
              {description = "Lock screen",                     group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "l",       function () awful.spawn("qlock")                         end,
              {description = "Quickly lock screen",             group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "x",       function () awful.spawn("systemctl suspend")            end,
              {description = "Suspend pc",                      group = "awesome"}),

    -- Music controls
    awful.key({ }, "XF86AudioPlay",             function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause", false) end,
              {description = "Play/Pause - Spotify",            group = "media"}),
    awful.key({ }, "XF86AudioNext",             function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next", false) end,
              {description = "Next song - Spotify",             group = "media"}),
    awful.key({ }, "XF86AudioPrev",             function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous", false) end,
              {description = "Prev song - Spotify",             group = "media"}),
    awful.key({ }, "XF86AudioStop",             function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop", false) end,
              {description = "Stop playback - Spotify",         group = "media"}),
    awful.key({ }, "XF86MonBrightnessUp",       function() set_brightness('5%+') end),
    awful.key({ }, "XF86MonBrightnessDown",     function() set_brightness('5%-') end),

    -- Restore minimized window
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "Restore minimized",               group = "client"}),

  -- Win+SHift+Left/Right: move client to prev/next tag and switch to it
  awful.key({ modkey, "Shift" }, "Left",
      function ()
          -- get current tag
          local t = client.focus and client.focus.first_tag or nil
          if t == nil then
              return
          end
          -- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
          local tag = client.focus.screen.tags[(t.index - 2) % 5 + 1]
          awful.client.movetotag(tag)
          awful.tag.viewprev()
      end,
          {description = "Move client to prev tag and switch",  group = "client"}),
  awful.key({ modkey, "Shift" }, "Right",
      function ()
          -- get current tag
          local t = client.focus and client.focus.first_tag or nil
          if t == nil then
              return
          end
          -- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
          local tag = client.focus.screen.tags[(t.index % 5) + 1]
          awful.client.movetotag(tag)
          awful.tag.viewnext()
      end,
          {description = "Move client to next tag and switch",  group = "client"})
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "View tag #"..i,               group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                     end
                  end,
                  {description = "Move client to tag #"..i,     group = "tag"})
    )
end

clientkeys = gears.table.join(
    awful.key({ modkey, "Shift"   }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "Toggle fullscreen",                     group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "Close client",                    group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "Toggle floating",                 group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "Move to master",                  group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "Toggle screen",                   group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top",              group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"})
)

-- Mouse + Keyboard
clientbuttons = gears.table.join(
    awful.button({ }, 1,                        function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1,                 function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 2,                 function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     titlebars_enabled = false,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},



    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "dialog" } -- It included "normal" too
      }, properties = { titlebars_enabled = true }
    },

    -- Center floating windows
    { rule = { instance = "bashrun" },
       properties = { floating = true },
       callback = function (c)
         awful.placement.centered(c,nil)
       end
     },

    -- Set Spotify to always map on the tag named "2" on screen 1.
    { rule = { class = "Spotify" },
      properties = { screen = 2, tag = "II" } },
}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave -> put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Change border color on changed focus
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

