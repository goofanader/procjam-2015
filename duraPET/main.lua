
local Gamestate = require "libraries/hump.gamestate"
local Class = require "libraries/hump.class"

require "constants"
require "classes/GameObject"
require "classes/Creature"
require "classes/BodyPart"
require "states/MenuMode"
--require "states/GameMode"

isDebugging = true

function love.load()
  WINDOW_WIDTH = love.graphics.getWidth()
  WINDOW_HEIGHT = love.graphics.getHeight()

  love.graphics.setBackgroundColor(unpack(GB_COLORS[BG_COLOR]))
  love.graphics.setDefaultFilter("nearest", "nearest")

  Gamestate.registerEvents()
  Gamestate.switch(MenuMode)
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key, isrepeat)
  if key == "q" then
    love.event.quit()
  end
end
