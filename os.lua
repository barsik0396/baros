local component = require("component")
local term = require("term")
local fs = require("filesystem")
local shell = {}
local internet = require("internet")

-- встроенные команды
shell.commands = {
  help = function()
    print("Built-in commands: help, echo <text>, shutdown, reinst")
    print("External commands: stored in /bin/")
  end,
  echo = function(args)
    print(table.concat(args, " "))
  end,
  shutdown = function()
    print("Shutting down...")
    os.exit()
  end,
  reinst = function()
    print("Downloading latest BarOS...")
    local url = "https://raw.githubusercontent.com/barsik0396/baros/refs/heads/main/os.lua"
    local handle, err = internet.request(url)
    if not handle then
      print("Download failed: " .. tostring(err))
      return
    end

    local content = ""
    for chunk in handle do
      content = content .. chunk
    end

    local program, reason = load(content)
    if not program then
      print("Error loading BarOS: " .. reason)
      return
    end

    print("Running new BarOS...")
    program()
  end
}

-- основной цикл
term.clear()
print("Welcome to BarOS")
while true do
  io.write("> ")
  local input = io.read()
  local parts = {}
  for word in input:gmatch("%S+") do table.insert(parts, word) end
  local cmd = parts[1]
  table.remove(parts, 1)

  if shell.commands[cmd] then
    shell.commands[cmd](parts)
  else
    print("Unknown command. Type 'help'.")
  end
end
