-- Awesome Libs
local awful = require("awful")
local gears = require("gears")

local modkey = user_vars.modkey

return gears.table.join(
  
  awful.key(
    { modkey },
    "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "Toggle fullscreen", group = "Client" }
  ),

  awful.key(
    { modkey },
    "w",
    function(c)
      c:kill()
    end,
    { description = "Close focused client", group = "Client" }
  ),

  --awful.key(
  --  { modkey },
  --  "t",
  --  awful.client.floating.toggle,
  --  { description = "Toggle floating window", group = "Client" }
  --),

  --awful.key(
  --  { modkey },
  --  "m",
  --  function(c)
  --    c.maximized = not c.maximized
  --    c:raise()
  --  end,
  --  { description = "(un)maximize", group = "Client" }
  --),
  
  --Minize window
  awful.key(
    { modkey },
    "n",
    function(c)
      if c == client.focus then
        c.minimized = true
      else
        c.minimized = false
        if not c:isvisible() and c.first_tag then
          c.first_tag:view_only()
        end
        c:emit_signal('request::activate')
        c:raise()
      end
    end,
    { description = "(un)hide", group = "Client" }
  )
)
