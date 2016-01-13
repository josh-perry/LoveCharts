## LoveCharts

### Example
'''lua
local LineGraph = require("lovecharts/line")
local time = 0

local line

function love.load()
  love.window.setMode(640, 480)

  line = LineGraph.new({})
end

function love.draw()
  line:draw(20, 20, 600, 440)
end

function love.update(dt)
  time = time + dt
  if time > 0.1 then
    time = 0

    table.insert(line.dataY, dt)
  end

  line:update()
end'''
