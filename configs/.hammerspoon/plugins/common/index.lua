require 'plugins.common.event'

function Trim(text)
  return string.gsub(text, "[\t\n\r]+", "")
end

function Execute(cmd)
  return Trim(hs.execute(cmd))
end

function ExecBlueutilCmd(params, noExec)
  local execCmd = "/usr/local/bin/blueutil "
  local cmd = "[ -x "..execCmd.." ] && "..execCmd..(params)
  if noExec ~= nil then
    return cmd
  end
  return Execute(cmd)
end

function BlueutiRecentGrep(keyword)
  return ExecBlueutilCmd("--recent | grep '"..keyword.."' | awk '{print $2}' | cut -d ',' -f 1")
end

-- 缓存设备 id 信息
local deviceIdMap = {}

function FindDeviceId(name)
  local id = deviceIdMap[name]
  if id == nil then
    id = BlueutiRecentGrep(name)
    deviceIdMap[name] = id
  end
  return id
end

function BlueutilIsConnected(name, callback)
  local id = FindDeviceId(name)
  local isConnected = '0'
  if string.len(id) > 0 then
    isConnected = ExecBlueutilCmd("--is-connected "..id)
    if callback ~= nil then
      callback(isConnected, id)
    end
  end
  return isConnected
end

local workWifi = {
  "bytedance",
  "Nanshan",
  "WIFI-"
}

function IsWorkEnv()
  local ssid = hs.wifi.currentNetwork()
  local flag = false
  if ssid then
    for _, value in pairs(workWifi) do
      if string.find(ssid:lower(), value:lower()) then
        flag = true
        break
      end
    end
  end
  return flag
end

function LoopWait(condition, callback, time)
  if time == nil then
    time = 1
  end
  local timer
  timer = hs.timer.doEvery(time, function ()
    local flag = condition()
    if flag then
      timer:stop()
      callback()
    end
  end)
end
