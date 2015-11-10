-- holds a bodypart
-- imagedata
-- name of part
-- isMirrored
-- shape and body data
-- who it's connected to ?? dunno about this one
-- density

local Class = require "libraries/hump.class"
local Vector = require "libraries/hump.vector"

--require "classes/GameObject"

BodyPart = Class {
  index = 1,
  DEFAULT_DENSITY = .1,

  init = function(self, name, shape, body, isMirrored, density)
    self.shape = shape or nil
    self.body = body or nil
    self.name = name or "BodyPart"..BodyPart.index
    self.id = BodyPart.index

    self.isMirrored = nil
    if isMirrored == true or isMirrored == false then self.isMirrored = isMirrored end

    self.fixture = nil
    self.density = density or BodyPart.DEFAULT_DENSITY

    if self.shape ~= nil and self.body ~= nil then
      self.fixture = love.physics.newFixture(self.body, self.shape, self.density)
    end

    self.joints = {}

    BodyPart.index = BodyPart.index + 1
  end
}
