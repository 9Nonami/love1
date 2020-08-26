require("collision")

spriteSize = 30 --collision acessa

local sprites = {}
local player = {}
local scenes = {}
local mainButtons = {}
local stanButtons = {}

--identificador da cena atual
local id = 2

--tipos de cenas
local stanScene = 1
local mainScene = 2

--ids dos botoes
local startButton = 1
local nextButton = 2

local mousePressed = false
local lockPressed = false



--INI
function love.load()
	--todo : criar uma tabela soh para sprites de inimigos
	sprites.wall = love.graphics.newImage("sprites/wall.png")
	sprites.grass = love.graphics.newImage("sprites/grass.png")
	sprites.enemy = love.graphics.newImage("sprites/enemy.png")
	sprites.player = love.graphics.newImage("sprites/player.png")
	sprites.stan = love.graphics.newImage("sprites/stan-bt.png")
	sprites.focus = love.graphics.newImage("sprites/focus-bt.png")
	init()
end

function init()
	createPlayer()

	--scene_1
	local map1 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	setBasicMapInfo(map1, 10, 10, 30, 30)

	local enemiesMap1 = {}
	createEnemy(210, 210, 1, map1, enemiesMap1, 30, 90)
	createEnemy(240, 30, 1, map1, enemiesMap1, 210, 120)
	createEnemy(30, 240, 1, map1, enemiesMap1, 30, 150)

	createStanScene(map1, enemiesMap1, {30 + map1.ox, 30 + map1.oy})
	
	local start_button = createButton(10, 10, sprites.stan, sprites.focus, startButton)
	local next_button = createButton(300, 10, sprites.stan, sprites.focus, nextButton)

	table.insert(mainButtons, start_button)
	table.insert(stanButtons, next_button)

	createMainScene()
end

function createStanScene(mp, ens, ppos)
	local scene = {}
	scene.type = stanScene
	scene.map = mp
	scene.enemies = ens
	scene.endScene = false
	scene.ppos = ppos
	table.insert(scenes, scene)
end

function createMainScene()
	local scene = {}
	scene.type = mainScene
	table.insert(scenes, scene)
end

function createPlayer()
	player.x = 0
	player.y = 0
	player.speed = 1
	player.width = sprites.player:getWidth()
	player.height = sprites.player:getHeight()
end

function definePlayerPosition(scn)
	player.x, player.y = scn.ppos[1], scn.ppos[2]
end

function setBasicMapInfo(mp, w, h, ox, oy)
	mp.w = w
	mp.h = h
	mp.ox = ox
	mp.oy = oy
end

function createEnemy(x, y, speed, map, ens, gx, gy)
	local enemy = {}
	enemy.x = x + map.ox
	enemy.y = y + map.oy
	enemy.speed = speed
	enemy.width = sprites.enemy:getWidth()
	enemy.height = sprites.enemy:getHeight()
	enemy.alive = true
	enemy.gx = gx + map.ox
	enemy.gy = gy + map.oy
	enemy.orx = enemy.x
	enemy.ory = enemy.y
	table.insert(ens, enemy)
end

function createButton(x, y, stan, focus, id)
	local b = {}
	b.x = x
	b.y = y
	b.stan = stan
	b.focus = focus
	b.id = id
	b.w = stan:getWidth()
	b.h = stan:getHeight()
	b.on = false
	return b
end

--UPDATES
function love.update(dt)
	updateScene()
	mousePressed = false
end

function updateScene()
	local tp = scenes[id].type

	local mx = love.mouse.getX()
	local my = love.mouse.getY()

	if tp == stanScene then
		updateStanScene(mx, my, mousePressed)
	elseif tp == mainScene then
		updateMainScene(mx, my, mousePressed)
	end

end

function love.mousepressed(x, y, button_callback, istouch, presses)
	mousePressed = true
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

	    if enemy.x == enemy.gx and enemy.y == enemy.gy then
	    	enemy.alive = false
	    end

	end
end

function updateMainScene(mx, my, mousePressed)
	local btId = updateButtons(mainButtons, mx, my, mousePressed)
	if btId ~= -1 then
		if btId == startButton then
			id = 1
			definePlayerPosition(scenes[id])
		end
	end
end

function updateStanScene(mx, my, mousePressed)
	updatePlayer()
	updateEnemies(scenes[id].enemies)
	updateWinStanScene(scenes[id].enemies, mx, my, mousePressed)
end

function updateWinStanScene(enemies, mx, my, mousePressed)
	if not scenes[id].endScene then
		local win = true
		for i = 1, #enemies do
			win = win and not enemies[i].alive
		end
		if win then
			scenes[id].endScene = true
		end
	else
		local tempId = updateButtons(stanButtons, mx, my, mousePressed)
		if tempId ~= -1 then -- -1 em var
			if tempId == nextButton then
				resetStan()
				id = 2
			end
		end
	end
end

function updateButtons(bts, mx, my, mousePressed)
	for i = 1, #bts do
		bts[i].on = mx > bts[i].x and mx < bts[i].x + bts[i].w and my > bts[i].y and my < bts[i].y + bts[i].h
		if mousePressed  and bts[i].on then
			return bts[i].id
		end
	end
	return -1
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

		if scenes[id].endScene then
			love.graphics.print("win", 0, 0)
			drawButtons(stanButtons)
		end
	elseif tp == mainScene then
		drawButtons(mainButtons)
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

function drawButtons(bts)
	for i = 1, #bts do
		if bts[i].on then
			love.graphics.draw(bts[i].stan, bts[i].x, bts[i].y)
		else
			love.graphics.draw(bts[i].focus, bts[i].x, bts[i].y)
		end
	end
end

function resetStan()
	scenes[id].endScene = false
	for i = 1, #scenes[id].enemies do
		scenes[id].enemies[i].x = scenes[id].enemies[i].orx
		scenes[id].enemies[i].y = scenes[id].enemies[i].ory
		scenes[id].enemies[i].alive = true
	end
end
--reset(ens)
--resetStan(stan)