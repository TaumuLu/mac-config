require 'plugins.caffWatch.connectAirPods'

local date = os.date("*t")
local hour = date.hour
local min = date.min

-- hs.alert(os.date("%Y-%m-%d %H:%M:%S", os.time()))
-- for k,v in pairs(date) do
--   print(k,v)
-- end

local function triggerVolume()
  if (9 <= hour and hour < 19) then
    local id = findDeviceId('connected ')
    if (string.len(id) == 0) then
      hs.execute('osascript -e "set volume output muted 1"')
    end
  else
    hs.execute('osascript -e "set volume output muted 0"')
  end
end

return {
  screensDidUnlock = function ()
    triggerVolume()
  end
}
