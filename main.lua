require("collision")
local saveData = require("saveData")

spriteSize = 30 --collision acessa

local sprites = {}
local player = {}
local scenes = {}
local mainButtons = {}
local stanButtons = {}
local galleryButtons = {}
local gallerySlots = {}

--tipos de cenas
local mainScene = -1
local stanScene = -2
local dialogScene = -3
local galleryScene = -4

--ids dos botoes
local startButton = 1
local nextSceneButton = 2
local nextButton = 3
local previousButton = 4
local galleryButton = 5
local mainButton = 6

local mousePressed = false

--identificador da cena atual
local id = 1

--id temporario, para selecao de cenas
local tid = 1
local limit = 0 --limite para o tid

--save
local saveFileName = "save"
local totalSlots = 8
local save = {}


--INI
function love.load()
	--todo : criar uma tabela soh para sprites de inimigos
	sprites.wall = love.graphics.newImage("sprites/wall.png")
	sprites.grass = love.graphics.newImage("sprites/grass.png")
	sprites.enemy = love.graphics.newImage("sprites/enemy.png")
	sprites.player = love.graphics.newImage("sprites/player.png")

	sprites.ns = love.graphics.newImage("sprites/next-scene.png")
	sprites.prev = love.graphics.newImage("sprites/prev.png")
	sprites.next = love.graphics.newImage("sprites/next.png")
	sprites.start = love.graphics.newImage("sprites/start.png")
	sprites.gallery = love.graphics.newImage("sprites/gallery.png")
	sprites.main = love.graphics.newImage("sprites/main.png")
	sprites.focus = love.graphics.newImage("sprites/focus-bt.png")

	sprites.focusg = love.graphics.newImage("sprites/gallery/focus.png")
	sprites.lock = love.graphics.newImage("sprites/gallery/lock.png")
	sprites.um = love.graphics.newImage("sprites/gallery/1.png")
	sprites.dois = love.graphics.newImage("sprites/gallery/2.png")
	sprites.tres = love.graphics.newImage("sprites/gallery/3.png")
	sprites.quatro = love.graphics.newImage("sprites/gallery/4.png")
	sprites.cinco = love.graphics.newImage("sprites/gallery/5.png")
	sprites.seis = love.graphics.newImage("sprites/gallery/6.png")
	sprites.sete = love.graphics.newImage("sprites/gallery/7.png")
	sprites.oito = love.graphics.newImage("sprites/gallery/8.png")

	initSaveFile()
	init()
end

function initSaveFile()

	local f = love.filesystem.getInfo(saveFileName)
	
	if f then
		--arquivo existe
		save = saveData.load(saveFileName)
	else
		--arquivo nao existe
		save[1] = 0
		for i = 2, totalSlots do
			save[i] = -1
		end

		local sc1 = {-1}
		local sc2 = {-1}
		save.sc = {sc1, sc2}

		local uv = {}
		for i = 1, totalSlots do
			uv[i] = -1
		end
		save.uv = uv

		saveData.save(save, saveFileName)
	end

	updateLimit()
end

function init()

	createPlayer()

	--cena 1 em scenes
	createMainScene()

	--cena 2
	createGalleryScene()


	--cena 3
	createDialogScene({"uno", "dos", "tres"}, nil, 4)


	--cena 4
	local map1 = {
					1,1,1,1,1,1,1,1,1,1,
					1,0,0,0,0,0,0,1,0,1,
					1,1,1,1,1,1,0,1,0,1,
					1,0,0,0,0,0,0,1,0,1,
					1,1,1,0,1,1,1,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,1,0,1,1,1,1,
					1,1,1,0,1,0,1,0,0,1,
					1,0,0,0,1,0,0,0,0,1,
					1,1,1,1,1,1,1,1,1,1}
	setBasicMapInfo(map1, 10, 10, 30, 30)
	local enemiesMap1 = {}
	createEnemy(210, 210, 1, map1, enemiesMap1, 30, 90)
	createEnemy(240, 30, 1, map1, enemiesMap1, 210, 120)
	createEnemy(30, 240, 1, map1, enemiesMap1, 30, 150)
	createStanScene(map1, enemiesMap1, {30 + map1.ox, 30 + map1.oy}, 5, {1, 1}, {true, 2})


	--cena 5
	createDialogScene({"asdasdad", "zxczczxcxz"}, nil, 6)


	--cena 6
	local map2 = {
					1,1,1,1,1,1,1,1,1,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,1,1,1,1,1,1,1,1,1}
	setBasicMapInfo(map2, 10, 10, 0, 0)
	local enemiesMap2 = {}
	createEnemy(150, 150, 1, map2, enemiesMap2, 30, 30)
	createStanScene(map2, enemiesMap2, {30 + map2.ox, 30 + map2.oy}, 1, {2, 1}, {true, 1})


	--BUTTONS------------------------------------------------
	local start_button = createButton(10, 10, sprites.start, sprites.focus, startButton)
	local next_scene_button = createButton(300, 10, sprites.ns, sprites.focus, nextSceneButton)
	local next_button = createButton(110, 100, sprites.next, sprites.focus, nextButton)
	local prev_button = createButton(10, 100, sprites.prev, sprites.focus, previousButton)
	local gallery_button = createButton(110, 10, sprites.gallery, sprites.focus, galleryButton)
	local main_button = createButton(400, 10, sprites.main, sprites.focus, mainButton)

	table.insert(mainButtons, start_button)
	table.insert(mainButtons, prev_button)
	table.insert(mainButtons, next_button)
	table.insert(mainButtons, gallery_button)

	table.insert(stanButtons, next_scene_button)

	table.insert(galleryButtons, main_button)
end

function createStanScene(mp, ens, ppos, nx, idseq, tnx)
	--mp = mapa
	--ens = inimigos
	--ppos = posicao do player neste mapa
	--nx = next scene
	--idseq = id do conjunto / id desta cena no conjunto
	--tnx = se a cena for a ultima de uma sequencia, carrega
	--		a informaca do proximo char a ser liberado
	--		ex: {false} > para cenas ~= da ultima
	--			{true, 2} > para a ultima cena da sequencia, 2 = id da cena em save
	local scene = {}
	scene.type = stanScene
	scene.map = mp
	scene.enemies = ens
	scene.endScene = false
	scene.ppos = ppos
	scene.nextScene = nx
	scene.idseq = idseq
	scene.tnx = tnx
	table.insert(scenes, scene)
end

function createMainScene()
	local scene = {}
	scene.type = mainScene
	table.insert(scenes, scene)
end

function createDialogScene(txts, img, nx)
	local scene = {}
	scene.type = dialogScene
	scene.txtId = 1
	scene.txts = txts
	scene.img = img
	scene.nextScene = nx
	table.insert(scenes, scene)
end

function createGalleryScene()
	local scene = {}
	scene.type = galleryScene

	local slot1 = createButton(30, 30, sprites.um, sprites.focusg, 1)
	local slot2 = createButton(90, 30, sprites.dois, sprites.focusg, 2)
	local slot3 = createButton(150, 30, sprites.tres, sprites.focusg, 3)
	local slot4 = createButton(210, 30, sprites.quatro, sprites.focusg, 4)
	local slot5 = createButton(30, 90, sprites.cinco, sprites.focusg, 5)
	local slot6 = createButton(90, 90, sprites.seis, sprites.focusg, 6)
	local slot7 = createButton(150, 90, sprites.sete, sprites.focusg, 7)
	local slot8 = createButton(210, 90, sprites.oito, sprites.focusg, 8)

	gallerySlots = {slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8}

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
	elseif tp == dialogScene then
		updateDialogScene(mousePressed)
	elseif tp == galleryScene then
		updateGalleryScene(mx, my)
	end
end

function love.mousereleased(x, y, button_callback, istouch, presses)
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
	if btId ~= -1 then --todo
		if btId == startButton then
			if tid == 1 then
				id = 3
			elseif tid == 2 then
				id = 5
			end
			resetButtons(mainButtons)
		elseif btId == previousButton then --(<)
			if tid > 1 then
				tid = tid - 1
			end
		elseif btId == nextButton then
			if tid < limit then
				tid = tid + 1
			end
		elseif btId == galleryButton then
			id = 2
			resetButtons(mainButtons)
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
			checkSave()
		end
	else
		local tempId = updateButtons(stanButtons, mx, my, mousePressed)
		if tempId ~= -1 then
			if tempId == nextSceneButton then
				resetStan()
				id = scenes[id].nextScene
			end
		end
	end
end

function updateDialogScene(mousePressed)
	if mousePressed then
		if scenes[id].txtId < #scenes[id].txts then
			scenes[id].txtId = scenes[id].txtId + 1
		else
			scenes[id].txtId = 1
			id = scenes[id].nextScene
			if scenes[id].type == stanScene then
				definePlayerPosition(scenes[id])
			end
		end
	end
end

function updateGalleryScene(mx, my)
	local tslotId = updateGallerySlots(gallerySlots, mx, my, mousePressed)
	if tslotId == -1 then --nenhum slot foi selecionado
		local tbuttonId updateButtons(galleryButtons, mx, my, mousePressed)
		if tbuttonId == mainButton then --como soh tem 1, nao vou verificar com -1
			id = 1
			--reset
		end
	end
end

function updateButtons(bts, mx, my, mousePressed)
	for i = 1, #bts do
		bts[i].on = mx > bts[i].x and mx < bts[i].x + bts[i].w and my > bts[i].y and my < bts[i].y + bts[i].h
		if mousePressed  and bts[i].on then
			print(bts[i].id)
			return bts[i].id
		end
	end
	return -1
end

function updateGallerySlots(bts, mx, my, mousePressed)
	for i = 1, #bts do
		if save.uv[i] ~= -1 then
			bts[i].on = mx > bts[i].x and mx < bts[i].x + bts[i].w and my > bts[i].y and my < bts[i].y + bts[i].h
			if mousePressed  and bts[i].on then
				return bts[i].id
			end
		end
	end
	return -1
end

function checkSave()

	--o salvamento soh vai acontecer uma vez, quando a cena for 
	--concluida pela primeira vez (win = true)

	--verifica se esta cena ja foi concluida (pack/scene)
	if save.sc[scenes[id].idseq[1]][scenes[id].idseq[2]] == -1 then
		
		--define como concluida
		save.sc[scenes[id].idseq[1]][scenes[id].idseq[2]] = 0

		--verifica se esta cena eh a ultima da sequencia
		if scenes[id].tnx[1] then

			--eh a ultima, entao resgata a nextScene para desbloquear no main
			if save[scenes[id].tnx[2]] == -1 then

				--o id da proxima cena eh liberado no main
				save[scenes[id].tnx[2]] = 0

				--limite atualizado
				updateLimit()
			end

			--como eh a ultima cena, desbloqueia este id para a galeria
			if save.uv[scenes[id].idseq[1]] == -1 then
				save.uv[scenes[id].idseq[1]] = 0
			end
		end

		--salva
		saveData.save(save, saveFileName)
	end
end

function updateLimit()
	--verifica dentro do save quantas telas estao liberadas
	limit = 0
	for i = 1, #save do
		if save[i] ~= -1 then
			limit = limit + 1
		end
	end
end

--DRAW
function love.draw()
	drawScene()
	love.graphics.print(tid, 200, 0)
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
	elseif tp == dialogScene then
		love.graphics.print(scenes[id].txts[scenes[id].txtId], 0, 0)
	elseif tp == galleryScene then
		drawSlots(gallerySlots)
		drawButtons(galleryButtons)
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
		if not bts[i].on then
			love.graphics.draw(bts[i].stan, bts[i].x, bts[i].y)
		else
			love.graphics.draw(bts[i].focus, bts[i].x, bts[i].y)
		end
	end
end

function drawSlots(slts)
	for i = 1, #slts do
		if save.uv[i] == -1 then
			--slot bloqueado
			love.graphics.draw(sprites.lock, slts[i].x, slts[i].y)
		else
			--slot desbloqueado
			if slts[i].on then
				love.graphics.draw(slts[i].focus, slts[i].x, slts[i].y)
			else
				love.graphics.draw(slts[i].stan, slts[i].x, slts[i].y)				
			end
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

function resetButtons(buttons)
	for i = 1, #buttons do
		buttons[i].on = false
	end
end