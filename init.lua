local canvas, timer, showing = nil, nil, true
local hotkey                 = { "cmd", "alt" }

local function cpuPercent()
  local t = 0
  for _, c in ipairs(hs.host.cpuUsage()) do t = t + c.active end
  return t / #hs.host.cpuUsage()
end

local function memStats()
  local vm       = hs.host.vmStat()
  local pg       = vm.pagesize or 4096
  local active   = vm.active_count      or 0
  local wired    = vm.wire_count        or vm.wired_count or 0
  local comp     = vm.compressed_count  or vm.compressor_page_count or 0
  local inactive = vm.inactive_count    or 0
  local spec     = vm.speculative_count or 0
  local free     = vm.free_count        or 0
  local usedB    = (active + wired + comp) * pg
  local cachedB  = (inactive + spec + free) * pg
  local n,u      = hs.execute("sysctl -n vm.swapusage"):match("used%s+=%s+([%d%.]+)([MG])")
  local swapB    = n and tonumber(n)*(u=="G" and 1024^3 or 1024^2) or 0
  return usedB, cachedB, swapB
end
local function idleMinutes()
  return math.floor(hs.host.idleTime() / 60 + 0.5)
end

local function fmtGB(b) return string.format("%.2f GB", b/1073741824) end


local function refresh()
  local cpu = cpuPercent()
  local used, cached, swap = memStats()
  canvas[2].text = string.format("CPU:            %4.1f %%", cpu)
  canvas[3].text = string.format("Swap Used:      %s", fmtGB(swap))
  canvas[4].text = string.format("Idle Time:      %2d min", idleMinutes())
  canvas[5].frame.w   = ("%s%%"):format(math.min(cpu,100))
end

local function build()
  local f = hs.screen.primaryScreen():frame()
  canvas  = hs.canvas.new{ x=f.x+f.w-220, y=f.y+10, w=200, h=80 }
  canvas:level(hs.canvas.windowLevels.overlay)
  canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
  canvas:alpha(0.50)
  canvas:show()

  canvas[1] = {
    type            = "rectangle",
    action          = "fill",
    fillColor       = { white = 0, alpha = 0.60 },
    strokeColor     = { white = 1, alpha = 0.70 },
    strokeWidth     = 1,
    roundedRectRadii= { 12, 12 },
    frame           = { x = 0, y = 0, w = "100%", h = "100%" }
  }


  local y = 8
  for i=2,4 do
    canvas[i] = {
      type            = "text",
      text            = "",
      textSize        = 12,
      textColor       = { white = 1 },
      frame           = { x = 12, y = y, w = 215, h = 18 }
    }
    y = y + 22
  end

  canvas[5] = {
    type            = "rectangle",
    frame           = { x = 12, y = 30, w = "0%", h = 4 },
    fillColor       = { red = 0.2, green = 1, blue = 0.2, alpha = 0.75 },
    roundedRectRadii= { 3, 3 }
  }
end

local function toggle()
  if showing then canvas:hide(); timer:stop() else canvas:show(); timer:start() end
  showing = not showing
end

build()
refresh()
timer = hs.timer.doEvery(1, refresh)
hs.hotkey.bind(hotkey, "S", toggle)

return {
  start = function() if not showing then toggle() end end,
  stop = function() if showing then toggle() end end,
  toggle = toggle
}
