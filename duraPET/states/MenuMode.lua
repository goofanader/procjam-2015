local Gamestate = require "libraries/hump.gamestate"
require "states/GameMode"

MenuMode = {}

function MenuMode:draw()
  love.graphics.setColor(GB_COLORS[DRK_COLOR])
  love.graphics.print("Press Enter to continue", 10, 10)
end

function MenuMode:keyreleased(key, code)
  if key == 'return' then
    Gamestate.switch(GameMode)
  end
end
