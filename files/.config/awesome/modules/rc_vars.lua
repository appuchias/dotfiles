
-- Variables

local vars = {}

vars.terminal = "kitty"
-- vars.editor = os.getenv("EDITOR") or "nvim"
vars.editor = "nvim"
vars.cmd_editor = vars.terminal .. " -e " .. vars.editor
vars.cmd_browser = "firefox"
vars.cmd_spotify = "spotify"
vars.cmd_file_explorer = "thunar"
vars.cmd_discord = "discord"
vars.cmd_screenshot = "flameshot gui"
vars.cmd_rofi = "rofi -show run"
vars.cmd_rofi_combi = "rofi -show combi"

-- Default modkey.
vars.modkey = "Mod4"

return vars
