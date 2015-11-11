local Class = require "libraries/hump.class"
local Vector = require "libraries/hump.vector"

require "classes/bodyParts/BodyPart"

Mouth = Class {__includes = BodyPart,
  IMAGE_SIZE = Vector(8,8),

  startingMouths = {
    {"media/images/square.png", "Square", love.physics.newRectangleShape(Mouth.IMAGE_SIZE.x, Mouth.IMAGE_SIZE.y)},
    {"media/images/circle.png", "Circle", love.physics.newCircleShape(Mouth.IMAGE_SIZE.x / 2.0)},
    {"media/images/triangle.png", "Triangle", love.physics.newPolygonShape({
      Mouth.IMAGE_SIZE.x / -2.0, Mouth.IMAGE_SIZE.y / 2.0,
      0, Mouth.IMAGE_SIZE.y / -2.0,
      Mouth.IMAGE_SIZE.x / 2.0, Mouth.IMAGE_SIZE.y / 2.0
    })}
  },

  init = function(self, type, world, x, y)
    local shapeData = love.image.newImageData(startingShapes[type][1])
    local mouthImage = love.graphics.newImage(startingShapeData)
    local body = love.physics.newBody(world, x, y, "dynamic")
    local shape = startingShapes[type][3]

    BodyPart.init(self, startingShapes[type][2].."Mouth", shape, body, false, .1, world)

    self.filename = startingShapes[type][1]
    self.type = type
    self.shapeData = shapeData
    self.image = mouthImage
  end
}

function Mouth:draw()
end

function Mouth:update(dt)
end
