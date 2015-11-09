
local Gamestate = require "libraries/hump.gamestate"
local Class = require "libraries/hump.class"

require "constants"
require "classes/GameObject"
require "classes/Creature"

isDebugging = true

function love.load()
  local seed = os.time()
  rng = love.math.newRandomGenerator(seed)
  rng:random()
  --rng:random()

  WINDOW_WIDTH = love.graphics.getWidth()
  WINDOW_HEIGHT = love.graphics.getHeight()
  boundaryHeight = WINDOW_HEIGHT / 16.0
  boundaryWidth = WINDOW_WIDTH / 16.0

  love.physics.setMeter(METER_HEIGHT)
  world = love.physics.newWorld(GRAVITY_H, GRAVITY * METER_HEIGHT, true)

  gameObjects = {}

  cageBoundaries = {
    {"Ceiling", WINDOW_WIDTH, boundaryHeight, WINDOW_WIDTH / 2.0, boundaryHeight / 2.0},
    {"Left Wall", boundaryWidth, WINDOW_HEIGHT, boundaryWidth / 2.0, WINDOW_HEIGHT / 2.0},
    {"Right Wall", boundaryWidth, WINDOW_HEIGHT, WINDOW_WIDTH - boundaryWidth / 2.0, WINDOW_HEIGHT / 2.0},
    {"Ground", WINDOW_WIDTH, boundaryHeight, WINDOW_WIDTH / 2.0, WINDOW_HEIGHT - boundaryHeight / 2.0}
  }

  for index, wall in ipairs(cageBoundaries) do
    gameObjects[wall[1]] = GameObject(unpack(wall))
    gameObjects[wall[1]]:newBody(world)
    gameObjects[wall[1]].shape = love.physics.newRectangleShape(gameObjects[wall[1]].width, gameObjects[wall[1]].height)
    gameObjects[wall[1]].fixture = love.physics.newFixture(gameObjects[wall[1]].body, gameObjects[wall[1]].shape)
  end

  -- load starting shapes
  startingShapes = {
    "media/images/square.png",
    "media/images/circle.png",
    "media/images/triangle.png"
  }

  imageIndex = rng:random(#startingShapes)
  print(imageIndex)
  startingShapeData = love.image.newImageData(startingShapes[imageIndex])
  --print(startingShapeData:getString())
  creatureImage = love.graphics.newImage(startingShapeData)

  gameObjects.creature = Creature("Creature", creatureImage:getWidth(), creatureImage:getHeight(), (WINDOW_WIDTH / 2), (WINDOW_HEIGHT / 2))
  gameObjects.creature:setImageData(world, startingShapeData, startingShapes[imageIndex])

  love.graphics.setBackgroundColor(unpack(GB_COLORS[BG_COLOR]))
  love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.push()
  --[[love.graphics.draw(squareShapeImage, 0,0)
  love.graphics.draw(circleShapeImage,10,0)
  love.graphics.draw(triangleShapeImage,20,0)]]
  --love.graphics.draw(creatureImage, (WINDOW_WIDTH / 2) - (creatureImage:getWidth() / 2), (WINDOW_HEIGHT / 2) - (creatureImage:getHeight() / 2))

  for name, object in pairs(gameObjects) do
    object:draw()
  end

  love.graphics.pop()
end

function love.update(dt)
  world:update(dt)

  for name, object in pairs(gameObjects) do
    object:update(dt)
  end
end
