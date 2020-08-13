require("collision")

player = {}

player.x = 30
player.y = 30
player.speed = 1
player.sprite = love.graphics.newImage("sprites/player.png")
player.width = player.sprite:getWidth()
player.height = player.sprite:getHeight()

player.adjustOffset = function(map)
	player.x = player.x + map.ox
	player.y = player.y + map.oy
end

player.update = function(map)
	local up = love.keyboard.isDown("up")
	local down = love.keyboard.isDown("down")
	local left = love.keyboard.isDown("left")
	local right = love.keyboard.isDown("right")

	if up and not upCollide(map, player) then
		player.y = player.y - player.speed
	end

	if down and not downCollide(map, player) then
        player.y = player.y + player.speed
    end
	
	if left and not leftCollide(map, player) then
        player.x = player.x - player.speed
    end

	if right and not rightCollide(map, player) then
        player.x = player.x + player.speed
    end
end

player.draw = function()
	love.graphics.draw(player.sprite, player.x, player.y)
end