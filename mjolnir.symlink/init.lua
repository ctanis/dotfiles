
local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local appfinder = require "mjolnir.cmsj.appfinder"
local screenwatcher = require"mjolnir._asm.watcher.screen"
local alert = require"mjolnir.alert"

-- Push the window into the exact center of the screen
local function centerfocused()
   win = window.focusedwindow()

   if (not win) then
      return
   end

   frame = win:screen():frame()
   frame.x = .10*frame.w
   frame.y = 0
   frame.w = .80*frame.w
   frame.h = frame.h
   win:setframe(frame)
end

-- push the window onto the left half of the screen

local function leftify_window()
   local win = window.focusedwindow()

   if not win then
      return
   end   

   local f = win:screen():frame()
   f.w = f.w/2 - 3
   win:setframe(f)
end



-- tiling setup
local tiling = require "mjolnir.tiling"
local tmash = {"ctrl", "cmd"}

local non_tiled_apps = { "Dash", "Howler Pro" }
local function  is_tiled_app(x)
   return  not fnutils.contains(non_tiled_apps, x:application():title())
end

tiling.addlayout('crt-vertical-right', function(windows)

                    windows = fnutils.filter(windows, is_tiled_app)

                    local wincount = #windows

                    for index, win in pairs(windows) do
                       local frame = win:screen():frame()


                       if index == 1 then
                          frame.x = frame.x + frame.w / 2
                          frame.w = frame.w / 2
                       else
                          frame.x = frame.x
                          frame.w = frame.w / 2 - 3
                          frame.h = frame.h / (wincount - 1)
                          frame.y = frame.y + frame.h * (index - 2)
                       end
                       
                       win:setframe(frame)
                    end
end)

-- tiling.addlayout('crt-fullscreen', function(windows)

--                     windows = fnutils.filter(windows, is_tiled_app)
--                     local wincount = #windows

--                     for index, win in pairs(windows) do
--                        local frame = win:screen():frame()

--                        if index == 1 then
--                           win:setframe(frame)
--                        else
--                           frame.x = frame.x
--                           break
--                        end
--                     end
-- end)


-- If you want to set the layouts that are enabled
tiling.set('layouts', {
              'crt-vertical-right' -- , 'crt-fullscreen'
})


-- hotkeys

hotkey.bind(tmash, "up", function() tiling.cycle(-1) end)
hotkey.bind(tmash, "down", function() tiling.cycle(1) end)
hotkey.bind(tmash, "right", function() tiling.promote() end)
hotkey.bind({'alt'}, "tab", function() tiling.cycle(-1) tiling.promote() end)
hotkey.bind(tmash, "return", function() centerfocused() end)
hotkey.bind(tmash, "left", function() leftify_window() end)

-- hotkey.bind({'shift', 'ctrl', 'cmd'},"return", function() tiling.cyclelayout() end)

-- local function changealert()
--    alert.show("a new window")
-- end

-- screenwatcher.new(function() changealert() end)
-- screenwatcher:start()
