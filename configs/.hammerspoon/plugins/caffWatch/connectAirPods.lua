local function bluetoothSwitch(state)
  local paramStr = "--power "
  local value = ExecBlueutilCmd(paramStr)
  if value ~= tostring(state) then
    ExecBlueutilCmd(paramStr..state)
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
    BlueutilIsConnected(name, function (isConnected, id)
      if isConnected == value then
        ExecBlueutilCmd(param.." "..id)

        -- 连接/断开后发布消息
        LoopWait(function ()
          -- 直接修改，避免下面的回调多查询一次
          isConnected = BlueutilIsConnected(name)
          return isConnected ~= value
        end, function ()
          -- 连接返回 true 未连接返回 false
          Event:emit(Event.keys[1], isConnected == '1')
        end)
      end
    end)
  end
end

local connectDevice = handleDevice(true)
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
    LoopWait(function ()
      return ExecBlueutilCmd("--power") == "1"
    end, function ()
      connectDevice()
    end)
  end
}
