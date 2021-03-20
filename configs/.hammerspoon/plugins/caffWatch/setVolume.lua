require 'plugins.caffWatch.connectAirPods'

-- local date = os.date("*t")
-- hs.alert(os.date("%Y-%m-%d %H:%M:%S", os.time()))
-- for k,v in pairs(date) do
--   print(k,v)
-- end
-- hs.execute('osascript -e "set volume 10"')

local function setVolume(isMute, volume)
  if volume == nil then
    volume = 30
  end
  if isMute then
    local id = FindDeviceId('connected ')
    if (string.len(id) == 0) then
      hs.execute('osascript -e "set volume output muted 1"')
    end
  else
    hs.execute('osascript -e "set volume output muted 0"')
    hs.execute('osascript -e "set volume output volume "'..volume)
  end
end

-- 根据时间判断是否静音
local function timeTrigger()
  local date = os.date("*t")
  local hour = date.hour
  local min = date.min
  local wday = date.wday
  local isMute = false

  if (
    wday > 1 and
    wday < 7 and
    hour >= 9 and
    hour < 19
  ) then
    isMute = true
  end

  setVolume(isMute)
end

local muteWifi = {
  "bytedance",
  "Nanshan"
}

-- 根据 wifi 名判断是否静音
local function nameTrigger()
  local ssid = hs.wifi.currentNetwork()
  local isMute = false
  if ssid then
    for _, value in pairs(muteWifi) do
      if string.find(ssid:lower(), value:lower()) then
        isMute = true
        break
      end
    end
  end

  setVolume(isMute)
end

return {
  screensDidWake = function ()
    nameTrigger()
  end,
  screensDidUnlock = function ()
    nameTrigger()
  end
}
