local Class = require "libraries/hump.class"
local Vector = require "libraries/hump.vector"

require "constants"

GameObject = Class {
  index = 1,

  init = function(self, name, width, height, x, y, body, shape, fixture, imageData, color, fillType)
    self.name = name or "GameObject"..GameObject.index
    self.width = width or 1
    self.height = height or 1
    self.body = body or nil
    self.shape = shape or nil
    self.fixtures = {}
    if fixture ~= nil then table.insert(self.fixtures, fixture) end

    self.color = color or GB_COLORS[DRK_COLOR]
    self.fillType = fillType or "fill"

    self.pos = Vector(0,0)
    self.pos.x = x or 0
    self.pos.y = y or 0
    self.rotation = 0

    self.imageData = imageData or nil
    self.image = imageData and love.graphics.newImage(imageData) or nil

    self.rng = love.math.newRandomGenerator(os.time()) --change the seed later
    self.rng:random()
    self.index = GameObject.index

    GameObject.index = GameObject.index + 1
  end
}

function GameObject:update(dt)
end

function GameObject:draw()
  local r,g,b,a = love.graphics.getColor()

  if self.body and self.shape then
    self:drawPhysicsShape()
  elseif self.image then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.image, self.pos.x, self.pos.y, self.rotation)
  end

  love.graphics.setColor(r,g,b,a)
end

function GameObject:__tostring()
  return self.name..": WH="..self.width..","..self.height.."; XY="..tostring(self.pos)
end

function GameObject:drawPhysicsShape()
  love.graphics.setColor(unpack(self.color))
  love.graphics.polygon(self.fillType, self.body:getWorldPoints(self.shape:getPoints()))
end

function GameObject:setImageData(world, imageData)
  self.imageData = imageData
  self.image = love.graphics.newImage(imageData)
end

function GameObject:newBody(world)
  self.body = love.physics.newBody(world, self.pos:unpack())
end
