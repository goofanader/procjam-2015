local Class = require "libraries/hump.class"
local Vector = require "libraries/hump.vector"

require "classes/GameObject"

local RED = 1
local GREEN = 2
local BLUE = 3
local ALPHA = 4

Creature = Class { __includes = GameObject,
  init = function(self, name, width, height, x, y, body, shape, fixture, imageData, color, fillType)
    GameObject.init(self, name, width, height, x, y, body, shape, fixture, imageData, color, fillType)

    self.imageArray = {}
    if self.imageData then
      self:buildImageArray()
      self:buildShape()
    end

    self.filename = ""
    self.density = .1

    self.rng = love.math.newRandomGenerator(self:getNumericalString(self.name..self.index..os.time()))
    self.rng:random()
  end
}

function Creature:getNumericalString(str)
  local ans = 0

  for i = 1, #str do
    local char = str:sub(i,i)
    ans = ans + string.byte(char)
  end

  return ans
end

function Creature:draw()
    love.graphics.setColor(255, 255, 255, 255)

    if self.filename:find("triangle") then
      love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1)
    else
      love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, self.width / 2.0, self.height / 2.0)
    end

    isShowingBounds = false

    --print out the bounding area for the shape
    if isShowingBounds then
      love.graphics.setColor(unpack(self.color))
      if self.filename:find("circle") then
        love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
      else
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
      end
    end
end

function Creature:update(dt)
  local randomNum = self.rng:random()

  if randomNum < .5 then
    -- move the creature
    local direction = self.rng:random()
    local force = Vector(500, 200)

    if direction < .25 then
      --self.pos.x = self.pos.x - METER_HEIGHT
      self.body:applyForce(-1.0 * force.x, 0)
    elseif direction < .5 then
      --self.pos.x = self.pos.x + METER_HEIGHT
      self.body:applyForce(force.x, 0)
    elseif direction < .75 then
      --self.pos.y = self.pos.y - METER_HEIGHT
      self.body:applyForce(0, -1.0 * force.y)
    else
      --self.pos.y = self.pos.y + METER_HEIGHT
      self.body:applyForce(0, 1.0 * force.y)
    end

  elseif randomNum > .9 then
    -- grow the creature
  end

  --[[randomNum = self.rng:random()
  if randomNum < .5 then
    -- rotate the creature
    self.rotation = self.rotation + .1
  else
    self.rotation = self.rotation - .1
  end]]
end

function Creature:setImageData(world, imageData, filename)
  GameObject.setImageData(self, world, imageData)

  filename = filename or ""
  self.filename = filename

  self:buildImageArray()
  --self:buildShape(world)

  -- this is instead of buildshape...
  if self.body == nil then
    self.body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic")
  end

  if filename:find("circle") then
    self.shape = love.physics.newCircleShape(self.width / 2.0)
  elseif filename:find("triangle") then
    self.shape = love.physics.newPolygonShape({
      0, self.height,
      self.width / 2.0, 0,
      self.width, self.height
    })
  else
    self.shape = love.physics.newRectangleShape(self.width, self.height)
  end

  table.insert(self.fixtures, love.physics.newFixture(self.body, self.shape, self.density))
end

function Creature:buildImageArray()
  for i = 0, self.imageData:getWidth() - 1 do
    self.imageArray[i] = {}

    for j = 0, self.imageData:getHeight() - 1 do
      self.imageArray[i][j] = {self.imageData:getPixel(i, j)}
      --print("i, j: "..i..","..j.."; colors: "..self:getColorString(i,j))
    end
  end
end

function Creature:getColorString(x, y)
  local r, g, b, a = unpack(self.imageArray[x][y])

  return r.." "..g.." "..b.." "..a
end
