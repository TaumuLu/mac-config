require 'plugins.caffWatch.connectAirPods'

-- local date = os.date("*t")
-- hs.alert(os.date("%Y-%m-%d %H:%M:%S", os.time()))
-- for k,v in pairs(date) do
--   print(k,v)
-- end
-- hs.execute('osascript -e "set volume 10"')

local function triggerVolume()
  local date = os.date("*t")
  local hour = date.hour
  local min = date.min
  local wday = date.wday

  if (
    wday > 1 and
    wday < 7 and
    hour >= 9 and
    hour < 19
  ) then
    local id = findDeviceId('connected ')
    if (string.len(id) == 0) then
      hs.execute('osascript -e "set volume output muted 1"')
    end
  else
    hs.execute('osascript -e "set volume output muted 0"')
    hs.execute('osascript -e "set volume output volume 30"')
  end
end

return {
  screensDidWake = function ()
    triggerVolume()
  end,
  screensDidUnlock = function ()
    triggerVolume()
  end
}
