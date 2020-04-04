-- hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
--     hs.alert.show("App path:        "
--     ..hs.window.focusedWindow():application():path()
--     .."\n"
--     .."App name:      "
--     ..hs.window.focusedWindow():application():name()
--     .."\n"
--     .."IM source id:  "
--     ..hs.keycodes.currentSourceID())
-- end)

-- function trim(text)
--     if text ~= nil then
--         return string.gsub(text, "[%s]+", "")
--     end
--     return text
-- end

local app = 'com.apple.Safari'
local htmlUti = "public.html"
local textUti = "public.utf8-plain-text"

function setPlainText()
    local text = hs.pasteboard.readString()
    if text ~= nui then
        local content = string.gsub(text, "%s*[\n]+%s*", "\n")
        hs.pasteboard.setContents(content)
    end
end

function setUrlHtml(url, text)
    local table = {}
    local html = string.format([[
    <meta charset="utf-8" />
    <a
      href="%s"
      >%s</a
    >
    ]], url, text)
    table[htmlUti] = html
    table[textUti] = text
    hs.pasteboard.writeAllData(table)
end

-- k = hs.hotkey.new({'cmd'}, 'v', function()
--     -- hs.eventtap.event.newKeyEvent({'cmd','option','shift'}, 'v', true):post()
--     hs.eventtap.keyStrokes(hs.pasteboard.getContents())
--     -- hs.eventtap.keyStroke({'cmd','option','shift'}, 'v')
-- end)

function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        local bundleID = appObject:bundleID()
        if bundleID == app then
            -- hs.alert(bundleID)
            -- k:enable()
            local contentTypes = hs.pasteboard.contentTypes()
            local utiType = contentTypes[1]
            if utiType == textUti then
                setPlainText()
            elseif utiType == htmlUti then
                local data = hs.pasteboard.readAllData()
                local html = data[htmlUti]
                local iter = string.gmatch(html, "\"(https?://[^\"]*)\"")

                local url
                for w, v in iter do
                    if url ~= nil then
                        url = nil
                        break
                    end
                    url = w
                end
                local urlText = string.gsub(html, "<[^<>]*>", "")
                local text = hs.pasteboard.readString()
                if url ~= nui and urlText == text then
                    setUrlHtml(url, text)
                else
                    setPlainText()
                end
            else
            end
            -- for index, uti in ipairs(contentTypes) do
            --     if uti == "public.utf8-plain-text" then
            --         break
            --     end
            -- end
            -- print(hs.inspect.inspect(utiType))
        else
            -- k:disable()
        end
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
