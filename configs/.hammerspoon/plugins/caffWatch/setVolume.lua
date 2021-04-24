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
    local id = BlueutiRecentGrep('connected ')
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

-- 根据 wifi 名判断是否静音
local function nameTrigger()
  local isWorkEnv = IsWorkEnv()
  setVolume(isWorkEnv)
end

-- 监听蓝牙设备 airpods 的连接变化
Event:on(Event.keys[1], function (isConnected)
  if isConnected then
    hs.execute('osascript -e "set volume output volume 50"')
  end
end)

return {
  screensDidWake = function ()
    nameTrigger()
  end,
  screensDidUnlock = function ()
    nameTrigger()
  end
}
