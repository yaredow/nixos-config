------------------
---- MONITORS ----
------------------
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------
local terminal = "kitty"
local menu     = "fuzzel"
local browser  = "firefox"

-------------------
---- AUTOSTART ----
-------------------
hl.exec_once("nm-applet --indicator")

---------------------
---- ENVIRONMENT ----
---------------------
hl.env({
    XCURSOR_SIZE = "24",
})

-------------------
---- INPUT --------
-------------------
hl.input({
    kb_layout    = "us",
    follow_mouse = 1,
    sensitivity  = 0,
    touchpad = {
        natural_scroll = true,
    },
})

-------------------
---- GENERAL ------
-------------------
hl.general({
    gaps_in             = 5,
    gaps_out            = 10,
    border_size         = 2,
    ["col.active_border"]   = "rgba(33ccffee) rgba(00ff99ee) 45deg",
    ["col.inactive_border"] = "rgba(595959aa)",
    layout              = "dwindle",
})

----------------------
---- DECORATION ------
----------------------
hl.decoration({
    rounding = 10,
    blur = {
        enabled = true,
        size    = 3,
        passes  = 1,
    },
    shadow = {
        enabled = false,
    },
})

-------------------
---- ANIMATIONS ---
-------------------
hl.animations({
    enabled = true,
    bezier = {
        myBezier = { 0.05, 0.9, 0.1, 1.05 },
    },
    animation = {
        { "windows",     1, 7, "myBezier" },
        { "windowsOut",  1, 7, "default",  "popin 80%" },
        { "border",      1, 10, "default" },
        { "borderangle", 1, 8, "default" },
        { "fade",        1, 7, "default" },
        { "workspaces",  1, 6, "default" },
    },
})

-------------------
---- DWINDLE ------
-------------------
hl.dwindle({
    preserve_split = true,
})

-------------------
---- KEYBINDS -----
-------------------
local mainMod = "SUPER"

-- Terminal (Kitty) on SUPER + Q and SUPER + Return
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

-- App Launcher (Fuzzel) on SUPER + Space
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))

-- Window management
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Focus movement
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse Dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Fn Keys (Audio & Brightness)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set 5%+"),                          { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),                          { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
