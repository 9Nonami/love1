require("collision")

spriteSize = 30 --collision acessa
local maps = {}
local sprites = {}
local enemies = {}
local player = {}
local id = 1

function love.load()
	--todo : criear uma tabela soh para inimigos
	sprites.wall = love.graphics.newImage("sprites/wall.png")
	sprites.grass = love.graphics.newImage("sprites/grass.png")
	sprites.enemy = love.graphics.newImage("sprites/enemy.png")
	sprites.player = love.graphics.newImage("sprites/player.png")
	init()
end

function init()
	createPlayer()
	--mapa 1
	local map1 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	setBasicMapInfo(map1, 10, 10, 30, 30)

	local enemiesMap1 = {}
	createEnemy(30, 240, 1, map1, enemiesMap1)
	createEnemy(240, 30, 1, map1, enemiesMap1)
	createEnemy(210, 210, 1, map1, enemiesMap1)

	table.insert(enemies, enemiesMap1)
	--
	definePlayerPosition(30, 30, map1)
end

function createPlayer()
	player.x = 0
	player.y = 0
	player.speed = 1
	player.width = sprites.player:getWidth()
	player.height = sprites.player:getHeight()
end

function definePlayerPosition(x, y, mp)
	player.x = x + mp.ox
	player.y = y + mp.oy
end

function setBasicMapInfo(mp, w, h, ox, oy)
	mp.w = w
	mp.h = h
	mp.ox = ox
	mp.oy = oy
	table.insert(maps, mp)
end

function createEnemy(x, y, speed, map, ens)
	local enemy = {}
	enemy.x = x + map.ox
	enemy.y = y + map.oy
	enemy.speed = speed
	enemy.width = sprites.enemy:getWidth()
	enemy.height = sprites.enemy:getHeight()
	enemy.alive = true
	table.insert(ens, enemy)
end

function love.update(dt)
	updatePlayer()
	updateEnemies()
end

function updatePlayer()
	local up = love.keyboard.isDown("up")
	local down = love.keyboard.isDown("down")
	local left = love.keyboard.isDown("left")
	local right = love.keyboard.isDown("right")

	if up and not upCollide(maps[id], player) then
		player.y = player.y - player.speed
	end

	if down and not downCollide(maps[id], player) then
        player.y = player.y + player.speed
    end
	
	if left and not leftCollide(maps[id], player) then
        player.x = player.x - player.speed
    end

	if right and not rightCollide(maps[id], player) then
        player.x = player.x + player.speed
    end
end

function updateEnemy(enemy)
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

		if up and not upCollide(maps[id], enemy) then
			enemy.y = enemy.y - enemy.speed
		end

		if down and not downCollide(maps[id], enemy) then
	        enemy.y = enemy.y + enemy.speed
	    end
		
		if left and not leftCollide(maps[id], enemy) then
	        enemy.x = enemy.x - enemy.speed
	    end

		if right and not rightCollide(maps[id], enemy) then
	        enemy.x = enemy.x + enemy.speed
	    end

	end
end

function updateEnemies()
	for i = 1, #enemies[id] do
		updateEnemy(enemies[id][i])
	end
end

function love.draw()
	drawMap(maps[id])
	drawPlayer()
	drawEnemies()
end

function drawMap(map)
	local lx = map.ox
	local ly = map.oy

	for i = 1, #map do

		if map[i] == 1 then
			love.graphics.draw(sprites.wall, lx, ly)
		elseif map[i] == 0 then
			love.graphics.draw(sprites.grass, lx, ly)
		end

		lx = lx + spriteSize

		if lx == ((map.w * spriteSize) + map.ox) then
			lx = map.ox
			ly = ly + spriteSize
		end

	end
end

function drawPlayer()
	love.graphics.draw(sprites.player, player.x, player.y)
end

function drawEnemy(enemy)
	love.graphics.draw(sprites.enemy, enemy.x, enemy.y)
end

function drawEnemies()
	for i = 1, #enemies[id] do
		drawEnemy(enemies[id][i])
	end
end