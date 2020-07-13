local function trim(text)
  return string.gsub(text, "[\t\n\r]+", "")
end

local function getExecBlueutilCmd(params, isExec)
  local execCmd = "/usr/local/bin/blueutil "
  local cmd = "[ -x "..execCmd.." ] && "..execCmd..(params)
  if (isExec ~= nil) then
    return trim(hs.execute(cmd))
  end
  return cmd
end

local function bluetoothSwitch(state)
  getExecBlueutilCmd("--power "..(state), true)
end

local function searchDevice(callback, value, deviceName)
  local id = getExecBlueutilCmd("--recent | grep '"..deviceName.."' | awk '{print $2}' | cut -d ',' -f 1", true)
  if (string.len(id) > 0) then
    local isConnected = getExecBlueutilCmd("--is-connected "..id, true)
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
      getExecBlueutilCmd(param.." "..id, true)
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
    bluetoothSwitch(0)
  end,
  screensDidUnlock = function ()
    bluetoothSwitch(1)
    local timer
    timer = hs.timer.doEvery(1, function ()
      if getExecBlueutilCmd("--power", true) == "1" then
        timer:stop()
        connectDevice()
      end
    end)
  end
}
