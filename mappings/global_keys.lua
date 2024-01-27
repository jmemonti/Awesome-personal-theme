-- Awesome Libs
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local ruled = require("ruled")

local modkey = user_vars.modkey

return gears.table.join(
  
  awful.key(
    { modkey },
    "#39",
    hotkeys_popup.show_help,
    { description = "Cheat sheet", group = "Awesome" }
  ),

  -- Escritories browsing
  awful.key(
    { modkey },
    "j",
    awful.tag.viewprev,
    { description = "View previous tag", group = "Tag" }
  ),

  awful.key(
    { modkey },
    "l",
    awful.tag.viewnext,
    { description = "View next tag", group = "Tag" }
  ),

  awful.key(
    { modkey },
    "k",
    awful.tag.history.restore,
    { description = "Go back to last tag", group = "Tag" }
  ),

  --Open terminal
  awful.key(
    { modkey },
    "#36",
    function()
      awful.spawn(user_vars.terminal)
    end,
    { description = "Open terminal", group = "Applications" }
  ),

  --Reload awesome
  awful.key(
    { modkey, "Control" },
    "r",
    awesome.restart,
    { description = "Reload awesome", group = "Awesome" }
  ),

  --Change layout distribution
  awful.key(
    { modkey, "Shift" },
    "q",
    function()
      awful.layout.inc(1)
    end,
    { description = "Select next layout", group = "Layout" }
  ),

  --Rofi application menu
  awful.key(
    { modkey },
    "a",
    function()
      awful.spawn("rofi -show drun -theme ~/.config/rofi/rofi.rasi")
    end,
    { descripton = "Application launcher", group = "Application" }
  ),
  
  --Rofi alt+tab selector
  awful.key(
    { modkey },
    "#23",
    function()
      awful.spawn("rofi -show window -theme ~/.config/rofi/window.rasi")
    end,
    { descripton = "Client switcher (alt+tab)", group = "Application" }
  ),

  awful.key(
    { "Mod1" },
    "#23",
    function()
      awful.spawn("rofi -show window -theme ~/.config/rofi/window.rasi")
    end,
    { descripton = "Client switcher (alt+tab)", group = "Application" }
  ),
  
  --Open file manager
  awful.key(
    { modkey },
    "e",
    function()
      awful.spawn(user_vars.file_manager)
    end,
    { descripton = "Open file manager", group = "System" }
  ),

  --Open browser
  awful.key(
    { modkey }, 
    "b",
    function ()
      awful.spawn(user_vars.browser) 
    end,
    {description = "Open browser", group = "Application" }
  ),


  awful.key(
    { modkey, "Shift" },
    "#26",
    function()
      awesome.emit_signal("module::powermenu:show")
    end,
    { descripton = "Session options", group = "System" }
  ),
  
  --Screenshot
  awful.key(
    {},
    "#107",
    function()
      awful.spawn(user_vars.screenshot_program)
    end,
    { description = "Screenshot", group = "Applications" }
  ),
 
  --VolumeControl
  awful.key(
    {},
    "XF86AudioLowerVolume",
    function(c)
      awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%", function()
        awesome.emit_signal("module::volume_osd:show", true)
        awesome.emit_signal("module::slider:update")
        awesome.emit_signal("widget::volume_osd:rerun")
      end)
    end,
    { description = "Lower volume", group = "System" }
  ),

  awful.key(
    {},
    "XF86AudioRaiseVolume",
    function(c)
      awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%", function()
        awesome.emit_signal("module::volume_osd:show", true)
        awesome.emit_signal("module::slider:update")
        awesome.emit_signal("widget::volume_osd:rerun")
      end)
    end,
    { description = "Increase volume", group = "System" }
  ),

  awful.key(
    {},
    "XF86AudioMute",
    function(c)
      awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
      awesome.emit_signal("module::volume_osd:show", true)
      awesome.emit_signal("module::slider:update")
      awesome.emit_signal("widget::volume_osd:rerun")
    end,
    { description = "Mute volume", group = "System" }
  ),
 
  --BrightControl
  awful.key(
    {},
    "XF86MonBrightnessUp",
    function(c)
      --awful.spawn("xbacklight -time 100 -inc 10%+")
      awful.spawn.easy_async_with_shell(
        "pkexec xfpm-power-backlight-helper --get-brightness",
        function(stdout)
          awful.spawn.easy_async_with_shell("pkexec xfpm-power-backlight-helper --set-brightness " .. tostring(tonumber(stdout) + BACKLIGHT_SEPS), function(stdou2)

          end)
          awesome.emit_signal("module::brightness_osd:show", true)
          awesome.emit_signal("module::brightness_slider:update")
          awesome.emit_signal("widget::brightness_osd:rerun")
        end
      )
    end,
    { description = "Raise backlight brightness", group = "System" }
  ),

  awful.key(
    {},
    "XF86MonBrightnessDown",
    function(c)
      awful.spawn.easy_async_with_shell(
        "pkexec xfpm-power-backlight-helper --get-brightness",
        function(stdout)
          awful.spawn.easy_async_with_shell("pkexec xfpm-power-backlight-helper --set-brightness " .. tostring(tonumber(stdout) - BACKLIGHT_SEPS), function(stdout2)

          end)
          awesome.emit_signal("module::brightness_osd:show", true)
          awesome.emit_signal("module::brightness_slider:update")
          awesome.emit_signal("widget::brightness_osd:rerun")
        end
      )
    end,
    { description = "Lower backlight brightness", group = "System" }
  ),

  --Toggle keyboard layout
  awful.key(
    { modkey },
    "#65",
    function()
      awesome.emit_signal("kblayout::toggle")
    end,
    { description = "Toggle keyboard layout", group = "System" }
  ),

  awful.key(
    { modkey },
    "#22",
    function()
      awful.spawn.easy_async_with_shell(
        [[xprop | grep WM_CLASS | awk '{gsub(/"/, "", $4); print $4}']],
        function(stdout)
          if stdout then
            ruled.client.append_rule {
              rule = { class = stdout:gsub("\n", "") },
              properties = {
                floating = true
              },
            }
            awful.spawn.easy_async_with_shell(
              "cat ~/.config/awesome/src/assets/rules.txt",
              function(stdout2)
                for class in stdout2:gmatch("%a+") do
                  if class:match(stdout:gsub("\n", "")) then
                    return
                  end
                end
                awful.spawn.with_shell("echo -n '" .. stdout:gsub("\n", "") .. ";' >> ~/.config/awesome/src/assets/rules.txt")
                local c = mouse.screen.selected_tag:clients()
                for j, client in ipairs(c) do
                  if client.class:match(stdout:gsub("\n", "")) then
                    client.floating = true
                  end
                end
              end
            )
          end
        end
      )
    end
  ),

  awful.key(
    { modkey, "Shift" },
    "#22",
    function()
      awful.spawn.easy_async_with_shell(
        [[xprop | grep WM_CLASS | awk '{gsub(/"/, "", $4); print $4}']],
        function(stdout)
          if stdout then
            ruled.client.append_rule {
              rule = { class = stdout:gsub("\n", "") },
              properties = {
                floating = false
              },
            }
            awful.spawn.easy_async_with_shell(
              [[
                                REMOVE="]] .. stdout:gsub("\n", "") .. [[;"
                                STR=$(cat ~/.config/awesome/src/assets/rules.txt)
                                echo -n ${STR//$REMOVE/} > ~/.config/awesome/src/assets/rules.txt
                            ]],
              function(stdout2)
                local c = mouse.screen.selected_tag:clients()
                for j, client in ipairs(c) do
                  if client.class:match(stdout:gsub("\n", "")) then
                    client.floating = false
                  end
                end
              end
            )
          end
        end
      )
    end
  )
)
