local function command(cmd)
    local items = {}
    local job = io.popen(cmd, "r")
    if job then
      local i = 1
      while true do
        local line = job:read("*l")
        if line == nil then break end
        items[i] = line
        i = i + 1
      end
    end
    return items
end

local function spawn(cmd)
    return vifm.startjob({
        cmd = cmd,
        visible = true,
    })
end

local function system(cmd)
    return vifm.run({
        cmd = cmd,
    })
end

-- Returns { run = cmd, blocking = true/false }
local function get_command(filename)
  local value = {}
  local cmd = command("cat " .. filename .. " | fzf")
  if #cmd > 0 then
    -- Parse command
    local _, _, run, desc, block = cmd[1]:find("run%s*=%s*\"(.-)\"%s*,%s*desc%s*=%s*\"(.-)\"%s*,%s*block%s*=%s*([^%s\n]+)")
    if run and run ~= "" and block and (block == "true" or block == "false") then
      value.run = run
      if block == "true" then
        value.block = true
      else
        value.block = false
      end
    end
  end
  return value
end

local function shell_fzf(info)
  local interactive = false
  if info.args and info.argv[1] == "true" then
    interactive = true
  end
  local cmd = get_command(vifm.expand("$VIFM/shellfzf_commands.txt"))
  if cmd.run then
    local run = vifm.expand(cmd.run)
    if interactive then
      run = vifm.input({ prompt = "ShellFzf Run: ", initial = run, complete = "file" })
    end
    if cmd.block then
      system(run)
    else
      spawn(run)
    end
    return true
  end
  vifm.run({ cmd =":", usetermmux = false })
  return false
end


-- this does NOT overwrite pre-existing user command
--local added = vifm.addhandler {
local added = vifm.cmds.add {
    name = "ShellFzf",
    description = "Run selected command",
    handler = shell_fzf,
    minargs = 0,
    maxargs = 1,
}
if not added then
    vifm.sb.error("Failed to register :ShellFzf")
end

return {}

