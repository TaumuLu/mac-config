require 'plugins.common.index'

local function bluetoothSwitch(state)
  local paramStr = "--power "
  local value = ExecBlueutilCmd(paramStr)
  if value ~= tostring(state) then
    ExecBlueutilCmd(paramStr..state)
  end
end

local function searchDevice(callback, value, deviceName)
  local id = FindDeviceId(deviceName)
  if (string.len(id) > 0) then
    local isConnected = ExecBlueutilCmd("--is-connected "..id)
    if (isConnected == value) then
      callback(id)
    end
  end
end

local name = "Taumu的AirPods"

local function handleDevice(connect)
  local param = "--connect"
  local value = "0"
  if connect == false then
    param = "--disconnect"
    value = "1"
  end

  return function ()
    searchDevice(function(id)
      if connect == true then
        hs.execute('osascript -e "set volume output muted 0"')
      end
      ExecBlueutilCmd(param.." "..id)
    end, value, name)
  end
end

local connectDevice = handleDevice()
local disconnectDevice = handleDevice(false)

local hyper = {'alt'}
hs.hotkey.bind(hyper, 'l', connectDevice)

local hyper = {'alt', 'shift'}
hs.hotkey.bind(hyper, 'l', disconnectDevice)

return {
  screensDidLock = function ()
    -- hs.battery.isCharged 不可靠，会返回 nil
    if (not string.find(Execute('pmset -g batt | head -n 1'), 'AC Power')) then
      local isWorkEnv = IsWorkEnv()
      if isWorkEnv then
        bluetoothSwitch(0)
      end
    end
  end,
  screensDidUnlock = function ()
    bluetoothSwitch(1)
    local timer
    timer = hs.timer.doEvery(1, function ()
      if ExecBlueutilCmd("--power") == "1" then
        timer:stop()
        connectDevice()
      end
    end)
  end
}
