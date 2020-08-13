spriteSize = 30

require("map")
require("player")

function love.load()
	player.adjustOffset(map)
end

function love.update(dt)
	player.update(map)
end

function love.draw()
	map.draw()
	player.draw()
end

