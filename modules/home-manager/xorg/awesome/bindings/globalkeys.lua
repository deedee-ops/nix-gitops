local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local home = os.getenv("HOME")
local xdg_config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")

local globalkeys = gears.table.join(
	awful.key({ RC.vars.modkey }, "/", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ RC.vars.modkey }, "Return", function()
		awful.util.spawn(RC.vars.terminal)
	end, { description = "open default terminal", group = "launcher" }),
	awful.key({ RC.vars.modkey, "Shift" }, "Tab", function()
		awful.layout.inc(1)
	end, { description = "select next layout", group = "layout" }),
	awful.key({ RC.vars.modkey }, ".", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ RC.vars.modkey }, ",", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({}, "XF86AudioMute", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/pavolume.sh --toggle-output-mute")
	end, { description = "", group = "media" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/pavolume.sh --down")
	end, { description = "", group = "media" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/pavolume.sh --up")
	end, { description = "", group = "media" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/brightness.sh --lcdDown")
	end, { description = "", group = "media" }),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/brightness.sh --lcdUp")
	end, { description = "", group = "media" }),
	awful.key({}, "XF86KbdBrightnessDown", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/brightness.sh --kbdDown")
	end, { description = "", group = "media" }),
	awful.key({}, "XF86KbdBrightnessUp", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/brightness.sh --kbdUp")
	end, { description = "", group = "media" }),
	awful.key({ RC.vars.modkey, "Shift" }, "x", function()
		awful.util.spawn("xkill")
	end, { description = "kill window", group = "launcher" }),
	awful.key({}, "Print", function()
		awful.util.spawn([[scrot -f "]] .. home .. [[/Pictures/Screenshots/%Y-%m-%d-%H%M%S_\$wx\$h_scrot.png"]])
	end, { description = "whole screen", group = "screenshot" }),
	awful.key({ RC.vars.modkey }, "Print", function()
		awful.util.spawn([[scrot -u -f "]] .. home .. [[/Pictures/Screenshots/%Y-%m-%d-%H%M%S_\$wx\$h_scrot.png"]])
	end, { description = "current window", group = "screenshot" }),
	awful.key({ RC.vars.modkey, "Shift" }, "Print", function()
		awful.util.spawn(
			[[sh -c 'scrot -a "$(slop -f "%x,%y,%w,%h")" -f "]]
				.. home
				.. [[/Pictures/Screenshots/%Y-%m-%d-%H%M%S_\$wx\$h_scrot.png"']]
		)
	end, { description = "region of the screen", group = "screenshot" }),
	awful.key({ RC.vars.modkey, "Shift" }, "y", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/dmenu/dmbrowser.sh invidious")
	end, { description = "invidious", group = "apps" }),
	awful.key({ RC.vars.modkey, "Shift" }, "m", function()
    awful.util.spawn("firefox --class webmail --profile " .. os.getenv("HOME") .. "/.mozilla/firefox/mail")
	end, { description = "invidious", group = "apps" }),
	awful.key({ RC.vars.modkey }, "space", function()
		awful.util.spawn("rofi -show drun -theme " .. xdg_config_home .. "/rofi/drun/config.rasi")
	end, { description = "command runner", group = "apps" }),
	awful.key({ RC.vars.modkey }, "Tab", function()
		awful.util.spawn("rofi -show window -theme " .. xdg_config_home .. "/rofi/drun/config.rasi")
	end, { description = "window switcher", group = "apps" }),
	awful.key({ RC.vars.modkey, "Shift" }, "e", function()
		awful.util.spawn(xdg_config_home .. "/rofi/powermenu/powermenu.sh")
	end, { description = "shutdown menu", group = "apps" }),
	awful.key({ RC.vars.modkey, "Shift" }, "v", function()
		awful.util.spawn(
			"rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}' -theme "
				.. xdg_config_home
				.. "/rofi/generic/config.rasi"
		)
	end, { description = "clipboard menu", group = "apps" }),
	awful.key({ RC.vars.modkey, "Shift" }, "s", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/dmenu/dmssh.sh")
	end, { description = "ssh menu", group = "apps" }),
	awful.key({ RC.vars.modkey, "Shift" }, "b", function()
		awful.util.spawn(xdg_config_home .. "/awesome/scripts/dmenu/dmbrowser.sh")
	end, { description = "webapps menu", group = "apps" }),
	awful.key({ RC.vars.modkey, "Shift" }, "p", function()
		awful.util.spawn(
			"rofi-rbw --selector-args=\"-kb-move-char-back '' -theme "
				.. xdg_config_home
				.. '/rofi/generic/config.rasi" --prompt="󱉼" --keybindings="Control+b:type:username,Control+c:type:password,Control+t:type:totp"'
		)
	end, { description = "password manager", group = "apps" }),
	awful.key(
		{ RC.vars.modkey, "Control" },
		"r",
		awesome.restart,
		{ description = "reload awesome", group = "awesome" }
	)
)

RC.globalkeys = gears.table.join(RC.globalkeys, globalkeys)
