-- local date = os.date("*t")
-- hs.alert(os.date("%Y-%m-%d %H:%M:%S", os.time()))
-- for k,v in pairs(date) do
--   print(k,v)
-- end
-- hs.execute('osascript -e "set volume 10"')

local function setVolumeOutput(value)
  hs.execute('osascript -e "set volume output volume "'..value)
end

local function setVolumeMuted(value)
  local muted = 1
  if not value then
    muted = 0
  end
  hs.execute('osascript -e "set volume output muted "'..muted)
end

local function getVolume(isConnected, volume)
  if volume == nil then
    return volume
  end
  if not not isConnected then
    return 50
  end
  return 30
end

local function hasConnected()
  local id = BlueutiRecentGrep('connected ')
  return string.len(id) ~= 0
end

local function setVolume(isMute, volume)
  local isConnected = hasConnected()
  volume = getVolume(isConnected, volume)

  if isMute then
    if not isConnected then
      setVolumeMuted(true)
    end
  else
    setVolumeMuted()
    setVolumeOutput(volume)
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
  hs.timer.doAfter(2, function()
    local volume = getVolume(isConnected)
    setVolumeOutput(volume)
  end)
end)

return {
  screensDidWake = function ()
    nameTrigger()
  end,
  screensDidUnlock = function ()
    nameTrigger()
  end
}
