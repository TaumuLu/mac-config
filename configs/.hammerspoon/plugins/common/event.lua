Event = {
  list = {},
  keys = {
    'connectAirPods',
  }
}

function Event:on(key, callback)
  self.list[key] = callback
end

function Event:off(key)
  self.list[key] = nil
end

function Event:emit(key, ...)
  local args = {...}
  for k, v in pairs(self.list) do
    print(k, v)
    if k == key then
      return v(table.unpack(args))
    end
  end
  print('not found key: '..key)
end

