local function reloadConfig(paths)
  doReload = false
  for _,file in pairs(paths) do
    if file:sub(-4) == ".lua" then
      print("A lua config file changed, reload")
      doReload = true
    end
  end
  if not doReload then
    print("No lua file changed, skipping reload")
    return
  end

  hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()
hs.alert.show("Config loaded")

local function reloadApp(paths)
  hs.alert.show("app change")
end

appWatcher = hs.pathwatcher.new("/Applications", reloadApp)
appWatcher:start()
