require("collision")

enemy = {}

enemy.create = function(x, y, speed, map)
	enemy.x = x + map.ox
	enemy.y = y + map.oy
	enemy.speed = speed
	enemy.sprite = love.graphics.newImage("sprites/enemy.png")
	enemy.width = enemy.sprite:getWidth()
	enemy.height = enemy.sprite:getHeight()
	enemy.alive = true
end

enemy.update = function(map, player)
	if enemy.alive then

		local up = false
		local down = false
		local left = false
		local right = false

		if enemy.y > player.y then
			up = true
		elseif enemy.y < player.y then
			down = true
		end

		if enemy.x > player.x then
			left = true
		elseif enemy.x < player.x then
			right = true
		end

		if up and not upCollide(map, enemy) then
			enemy.y = enemy.y - enemy.speed
		end

		if down and not downCollide(map, enemy) then
	        enemy.y = enemy.y + enemy.speed
	    end
		
		if left and not leftCollide(map, enemy) then
	        enemy.x = enemy.x - enemy.speed
	    end

		if right and not rightCollide(map, enemy) then
	        enemy.x = enemy.x + enemy.speed
	    end

	end
end

enemy.draw = function()
	if enemy.alive then
		love.graphics.draw(enemy.sprite, enemy.x, enemy.y)
	end
end