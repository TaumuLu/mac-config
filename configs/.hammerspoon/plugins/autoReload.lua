local function reloadConfig(paths)
  local doReload = false
  for _, file in pairs(paths) do
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

ConfigFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
ConfigFileWatcher:start()

hs.alert.show("Hammerspoon Config loaded")
