local Class = require "libraries/hump.class"
local Vector = require "libraries/hump.vector"

require "classes/Consumable"

local bodyPartsList = {
  "head",
  "body",
  "eyes",
  "arms",
  "legs",
  "ears",
  "nose",
  "wings",
  "tail",
  "feet",
  "hands",
  "mouth"
}

local RED = 1
local GREEN = 2
local BLUE = 3
local ALPHA = 4

local BODY = 1
local SHAPE = 2

Creature = Class { __includes = Consumable,
  init = function(self, name, width, height, x, y, world, body, shape, fixture, imageData, color, fillType)
    GameObject.init(self, name, width, height, x, y, body, shape, fixture, imageData, color, fillType)

    self.world = world or nil

    self.arms = {}
    self.legs = {}
    self.eyes = {}
    self.mouth = self.body or nil
    if self.body then
      self.body = nil
    end
    self.heads = nil
    self.bodies = nil
    self.bodyParts = {}

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
  love.graphics.setColor(unpack(self.color))
  for index, part in ipairs(self.bodyParts) do
    --print(unpack(part))

    if tostring(part[SHAPE]):find("Circle") then
      love.graphics.circle("fill", part[BODY]:getX(), part[BODY]:getY(), part[SHAPE]:getRadius())
    else
      love.graphics.polygon("fill", part[BODY]:getWorldPoints(part[SHAPE]:getPoints()))
    end
  end

  love.graphics.setColor(255, 255, 255, 255)

  if self.filename:find("triangle") then
    love.graphics.draw(self.image, self.mouth:getX(), self.mouth:getY(), self.mouth:getAngle(), 1, 1)
  else
    love.graphics.draw(self.image, self.mouth:getX(), self.mouth:getY(), self.mouth:getAngle(), 1, 1, self.width / 2.0, self.height / 2.0)
  end

  isShowingBounds = false

  --print out the bounding area for the shape
  if isShowingBounds then
    love.graphics.setColor(unpack(self.color))
    if self.filename:find("circle") then
      love.graphics.circle("line", self.mouth:getX(), self.mouth:getY(), self.shape:getRadius())
    else
      love.graphics.polygon("line", self.mouth:getWorldPoints(self.shape:getPoints()))
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
      self.mouth:applyForce(-1.0 * force.x, 0)
    elseif direction < .5 then
      --self.pos.x = self.pos.x + METER_HEIGHT
      self.mouth:applyForce(force.x, 0)
    elseif direction < .75 then
      --self.pos.y = self.pos.y - METER_HEIGHT
      self.mouth:applyForce(0, -1.0 * force.y)
    else
      --self.pos.y = self.pos.y + METER_HEIGHT
      self.mouth:applyForce(0, 1.0 * force.y)
    end

  elseif randomNum > .9 then
    -- grow the creature
    local bodyPartDecision = self.rng:random()
    local partsPercent = 1.0 / (#bodyPartsList * 1.0)

    for i = 1, #bodyPartsList do
      local currPart = bodyPartsList[i]

      if bodyPartDecision < i * partsPercent and self[currPart.."Create"] ~= nil then
        self[currPart.."Create"](self)
      end
    end
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

  -- NOTE Mouth should ALWAYS be drawn last

  -- this is instead of buildshape...
  if self.mouth == nil then
    self.mouth = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic")
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

  table.insert(self.fixtures, love.physics.newFixture(self.mouth, self.shape, self.density))
  table.insert(self.bodyParts, {self.mouth, self.shape})
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

function Creature:headCreate()

  -- algorithm:
  -- 0. determine max size of body part
  -- 1. determine if body part is mirrored or not through random (90% mirrored chance)
  -- 2. build the body part by selecting random points (up to 4 points if mirrored, 8 if not)
    -- shift the points so that x
  -- 3. select one of the body parts to connect to. If it's eyes or arms or something, it'll mirror the other part of the newly created shape to the other side of the body part being attached to
    -- note that there are restrictions on what kinds of body parts can be connected to depending on the newly created body part's type
  -- 4. Use the appropriate connecting joint
  -- 5. add part to table(s)

  if self.heads == nil then
    self.heads = {}
  elseif #self.heads >= 2 then
    return
  end

  print(self.name.." is creating a head!")
  local headMaxDimensions = Vector(16, 16) -- 16 x 16 space for a head

  local isCircle = self.rng:random() < .5
  local newHeadShape

  if not isCircle then
    local isMirrored = self.rng:random() < .9
    local numVertices = isMirrored and MAX_VERTICES / 2 or MAX_VERTICES
    numVertices = self.rng:random(3, numVertices) -- we don't ALWAYS want the max amount of vertices, so yeah. but can't be a line, either

    local maxDimensions = Vector(isMirrored and headMaxDimensions.x / 2 or headMaxDimensions.x, isMirrored and headMaxDimensions.y / 2 or headMaxDimensions.y)

    local vertices = {}
    for i = 1, numVertices do
      local newVertex = Vector(self.rng:random(maxDimensions.x) - 1, self.rng:random(maxDimensions.y) - 1)

      if not table.contains(vertices, newVertex) then
        table.insert(vertices, newVertex)
      else
        i = i - 1
      end
    end

    if isMirrored then
      for i = #vertices, 1, -1 do
        local addVertex = Vector(headMaxDimensions.x, 0.0)
        table.insert(vertices, addVertex - vertices[i])
      end
    end

    -- set the vertices so that the vectors are unpacked
    local trueVertices = {}
    for i = 1, #vertices do
      table.insert(trueVertices, vertices[i].x)
      table.insert(trueVertices, vertices[i].y)
    end

    -- make the polygon shape
    --print("isMirrored?"..tostring(isMirrored).."; numVertices:"..tostring(#trueVertices).."vs. "..tostring(#vertices))
    newHeadShape = love.physics.newPolygonShape(trueVertices)
  else
    local radius = self.rng:random(headMaxDimensions.x / 2)
    newHeadShape = love.physics.newCircleShape(radius)
  end

  -- make the body and determine where it'll go
  local x, y, joinedBody
  for index, part in ipairs(self.bodyParts) do
    if self.rng:random() < .5 then
      x = part[BODY]:getX()
      y = part[BODY]:getY()
      joinedBody = part[BODY]
      break
    end
  end

  if x == nil or y == nil then
    x = self.bodyParts[1][BODY]:getX()
    y = self.bodyParts[1][BODY]:getY()
    joinedBody = self.bodyParts[1][BODY]
  end

  local newHead = love.physics.newBody(self.world, x, y, "dynamic")
  table.insert(self.fixtures, love.physics.newFixture(newHead, newHeadShape, .1))

  love.physics.newWeldJoint(joinedBody, newHead, x, y)

  -- make the imagedata as well... TODO
  table.insert(self.heads, newHead)
  table.insert(self.bodyParts, {newHead, newHeadShape})
end

function table.contains(table, element)
  for _, value in ipairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
