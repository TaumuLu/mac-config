local function reloadApp(paths)
  local isChange = false
  for _, file in pairs(paths) do
    local count = 0

    for _ in file:gmatch("/") do
      count = count + 1
    end

    local isApp = file:sub(-4) == ".app"
    if count == 2 and isApp then
      -- hs.alert.show(file)
      isChange = true
      break
    end
  end

  if isChange == true then
    hs.alert.show("app change")
    -- print(hs.inspect.inspect(paths))

    hs.execute("defaults write com.apple.dock ResetLaunchPad -bool true")
    hs.execute("killall Dock")
  end
end

local timer = nil
AppChangeWatcher = hs.pathwatcher.new("/Applications", function (paths)
  if timer then
    timer:stop()
    timer = nil
  end
  timer = hs.timer.doAfter(5, function()
    reloadApp(paths)
  end)
end)
AppChangeWatcher:start()
