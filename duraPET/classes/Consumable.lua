--[[
  An item that can be eaten by a creature.
  Since creatures can eat themselves, Creatures extend from consumable.
]]
local Class = require "libraries/hump.class"

require "classes/GameObject"

Consumable = Class {__includes = GameObject,
  init = function(self)
    self.flavors = {}
    self.spiciness = 0
    self.rottenness = 0
    self.sweetness = 0
    self.bitterness = 0
    self.umaminess = 0
    self.hp = 100
    self.defense = 10
    self.bite = 0
    self.metalness = 0
    self.sliminess = 0
    self.stickiness = 0
    self.wetness = 0
    self.state = "solid"
  end
}
