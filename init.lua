hs.window.animationDuration = 0
HYPER = {"cmd", "alt", "ctrl"}

tiling = require "hs.tiling"
hotkey = require "hs.hotkey"
drt = require "hs.drt"
qs = require "hs.quickshift"


function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    return hours..":"..mins
  end
end

hotkey.bind(HYPER, "c", function() tiling.cycleLayout() end)
hotkey.bind(HYPER, "w", function() tiling.cycle(-1) end)
hotkey.bind(HYPER, "e", function() tiling.cycle(1) end)
hotkey.bind(HYPER, "s", function() tiling.switch(-1) end)
hotkey.bind(HYPER, "d", function() tiling.switch(1) end)
hotkey.bind(HYPER, "space", function() tiling.promote() end)
hotkey.bind(HYPER, "f", function() tiling.goToLayout("fullscreen") end)
hotkey.bind(HYPER, "r", function() tiling.retile() end)

-- Quick display for time & battery info
hotkey.bind(HYPER, "t", function()
	local battery_level = math.floor(hs.battery.percentage())
	local time_seconds = hs.timer.localTime()
	time = SecondsToClock(time_seconds) 
	hs.alert.show(time .. " [" .. battery_level .. "]") 
end)

-- Bus stops
-- bus_routes = {'416'}
-- bus_stop_per_wifi = 698 -- Defaults to UOIT
-- wifi_mon = hs.wifi.watcher.new(function(evt, msg, interface)
--   local network = hs.wifi.currentNetwork(interface)
--   if network == 'CAMPUS-AIR' then
--     bus_stop_per_wifi = 698
--   elseif network == 'dimitri' or network == 'dimitri5' then
--     bus_stop_per_wifi = 677
--   end
-- end)
-- wifi_mon:start()
-- hs.hotkey.bind(HYPER, 'B', function() show_bustimes(bus_stop_per_wifi, bus_routes) 
-- end)
bus_routes = {'915'}
bus_stop_per_wifi = 698
hs.hotkey.bind(HYPER, 'B', function() show_bustimes(bus_stop_per_wifi, bus_routes) 
end)

-- Finder mover
qs_move_hk = hs.hotkey.bind(HYPER, 'M', quickshift_move_files)
qs_move_hk:disable()
qs_move = quickshift_watch_finder(qs_move_hk):start()

hotkey.bind(HYPER, "x", function()
	local win = hs.window.focusedWindow()
	local frame = win:frame()

	local screen = win:screen()
  local max = screen:frame()

	frame.x = max.x + (max.w / 2) - (frame.w / 2)
	frame.y = max.y + (max.h / 2) - (frame.h / 2)

	win:setFrame(frame)
end)

Miro = hs.loadSpoon("MiroWindowsManager")

Miro:bindHotkeys({
	up = {HYPER, "up"},
	left = {HYPER, "left"},
	down = {HYPER, "down"},
	right = {HYPER, "right"},
	fullscreen = {HYPER, "space"}
})