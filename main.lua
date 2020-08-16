require("collision")

spriteSize = 30 --collision acessa

local sprites = {}
local player = {}
local scenes = {}

--identificador da cena atual
local id = 1

--tipos de cenas
local stanScene = 1



--INI
function love.load()
	--todo : criar uma tabela soh para sprites de inimigos
	sprites.wall = love.graphics.newImage("sprites/wall.png")
	sprites.grass = love.graphics.newImage("sprites/grass.png")
	sprites.enemy = love.graphics.newImage("sprites/enemy.png")
	sprites.player = love.graphics.newImage("sprites/player.png")
	init()
end

function init()
	createPlayer()

	--scene_1
	local map1 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	setBasicMapInfo(map1, 10, 10, 30, 30)

	local enemiesMap1 = {}
	createEnemy(30, 240, 1, map1, enemiesMap1)
	createEnemy(240, 30, 1, map1, enemiesMap1)
	createEnemy(210, 210, 1, map1, enemiesMap1)

	createStanScene(map1, enemiesMap1)

	--pegar pela scene
	definePlayerPosition(30, 30, map1)
end

function createStanScene(mp, ens)
	local scene = {}
	scene.type = stanScene
	scene.map = mp
	scene.enemies = ens
	table.insert(scenes, scene)
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

--UPDATES
function love.update(dt)
	updateScene()
end

function updateScene()
	local tp = scenes[id].type
	if tp == stanScene then
		updatePlayer()
		updateEnemies(scenes[id].enemies)
	end
end

function updatePlayer()
	local up = love.keyboard.isDown("up")
	local down = love.keyboard.isDown("down")
	local left = love.keyboard.isDown("left")
	local right = love.keyboard.isDown("right")

	if up and not upCollide(scenes[id].map, player) then
		player.y = player.y - player.speed
	end

	if down and not downCollide(scenes[id].map, player) then
        player.y = player.y + player.speed
    end
	
	if left and not leftCollide(scenes[id].map, player) then
        player.x = player.x - player.speed
    end

	if right and not rightCollide(scenes[id].map, player) then
        player.x = player.x + player.speed
    end
end

function updateEnemies(enemies)
	for i = 1, #enemies do
		updateEnemy(enemies[i])
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

		if up and not upCollide(scenes[id].map, enemy) then
			enemy.y = enemy.y - enemy.speed
		end

		if down and not downCollide(scenes[id].map, enemy) then
	        enemy.y = enemy.y + enemy.speed
	    end
		
		if left and not leftCollide(scenes[id].map, enemy) then
	        enemy.x = enemy.x - enemy.speed
	    end

		if right and not rightCollide(scenes[id].map, enemy) then
	        enemy.x = enemy.x + enemy.speed
	    end

	end
end

--DRAW
function love.draw()
	drawScene()
end

function drawScene()
	local tp = scenes[id].type
	if tp == stanScene then
		drawMap(scenes[id].map)
		drawPlayer()
		drawEnemies(scenes[id].enemies)
	end
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

function drawEnemies(enemies)
	for i = 1, #enemies do
		drawEnemy(enemies[i])
	end
end

function drawEnemy(enemy)
	love.graphics.draw(sprites.enemy, enemy.x, enemy.y)
end