spriteSize = 30

require("map")
require("player")
require("enemy")

function love.load()
	player.adjustOffset(map)
	enemy.create(30, 240, 1, map)
end

function love.update(dt)
	player.update(map)
	enemy.update(map, player)
end

function love.draw()
	map.draw()
	player.draw()
	enemy.draw()
end

