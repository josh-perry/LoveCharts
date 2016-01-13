local LineGraph = {}
LineGraph.__index = LineGraph

function LineGraph.new(dataY)
  local self = setmetatable({}, LineGraph)

  self.dataY = {}
  self.maxXDisplay = 8
  self.filled = true
  self.maxY = math.max(unpack(self.dataY))
  self.maxX = nil

  return self
end

function LineGraph:draw(x, y, w, h)
  if #self.dataY <= 2 then
    return
  end

  love.graphics.setColor(255, 255, 255)

  -- Vertical line
  love.graphics.line(x, y, x, y + h)

  -- Horizontal line
  love.graphics.line(x, y + h, x + w, y + h)

  -- Draw data points
  local baseOffsetY = h / self.maxY
  local baseOffsetX = w / self.maxXDisplay

  local points = {}
  local lines = {}
  local count = 0
  for i, v in ipairs(self.dataY) do
    if i >= #self.dataY - self.maxXDisplay then
      local offsetY = v * baseOffsetY
      local offsetX = count * baseOffsetX

      table.insert(points, {x + offsetX + 0.5, y + h - offsetY + 0.5})
      table.insert(lines, x + offsetX + 0.5)
      table.insert(lines, y + h - offsetY + 0.5)

      count = count + 1
    end
  end

  love.graphics.setColor(255, 0, 0)
  love.graphics.points(points)
  love.graphics.line(lines)

  -- Filled area
  if self.filled then
    local polygon = {x, y + h}

    for i, v in ipairs(lines) do
      table.insert(polygon, v)
    end

    table.insert(polygon, x + w)
    table.insert(polygon, y + h)

    love.graphics.polygon("fill", polygon)
  end
end

function LineGraph:update()
  self.maxY = math.max(unpack(self.dataY))
end

return LineGraph
