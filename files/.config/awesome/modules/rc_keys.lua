gears = require("gears")
awful = require("awful")
vars = require("modules.vars")

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
    awful.key({ modkey, "Shift"    }, "s",      function () awful.spawn(cmd_screenshot)                 end,
              {description = "Take a screenshot",               group = "programs"}),
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

