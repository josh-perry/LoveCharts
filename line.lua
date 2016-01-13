local LineGraph = {}
LineGraph.__index = LineGraph

function LineGraph.new(dataY)
  local self = setmetatable({}, LineGraph)

  self.dataY = {}
  self.dataX = {}

  self.maxXDisplay = 8
  self.filled = false
  self.maxY = math.max(unpack(self.dataY))
  self.maxX = nil

  self.verticalGridLines = true
  self.horizontalGridLines = true

  self.gridColor = {255, 255, 255, 50}

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
    love.graphics.setColor(255, 255, 255)
    if i >= #self.dataY - self.maxXDisplay then
      local offsetY = v * baseOffsetY
      local offsetX = count * baseOffsetX

      table.insert(points, {x + offsetX + 0.5, y + h - offsetY + 0.5})
      table.insert(lines, x + offsetX + 0.5)
      table.insert(lines, y + h - offsetY + 0.5)

      -- if self.verticalGridLines then
      --   love.graphics.setColor(self.gridColor)
      --   love.graphics.line(x + offsetX + 0.5, y, x + offsetX + 0.5, y + h)
      -- end

      count = count + 1
    end
  end

  love.graphics.setColor(self.gridColor)
  local horizontalGridSpacing = math.floor(h / 5)
  if self.horizontalGridLines then
    for i = 0, h / horizontalGridSpacing do
      love.graphics.line(x, y + (i * horizontalGridSpacing), x + w, y + (i * horizontalGridSpacing))
    end
  end

  love.graphics.setColor(255, 255, 0)
  local verticalGridSpacing = math.floor(w / 5)
  if self.verticalGridLines then
    for i = 0, w / verticalGridSpacing do
      love.graphics.setColor(self.gridColor)
      love.graphics.line(x + (i * verticalGridSpacing), y, x + (i * verticalGridSpacing), y + h)
      -- love.graphics.line(x + offsetX + 0.5, y, x + offsetX + 0.5, y + h)
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
