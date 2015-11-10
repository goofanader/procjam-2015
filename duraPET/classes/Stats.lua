--[[
  Contains many fields that determine how a creature feels.
  Things are on a 0 - 100 scale.
]]
local Class = require "libraries/hump.class"

Stats = Class {
  init = function(self)
    self.hp = 100
    self.curiosity = 50
    self.foods = {} -- table that contains any food the creature has tried and their preference for it
    
  end
}
