local player = {}
local spriteSize = 30
local cell = love.graphics.getWidth() / spriteSize
local map = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

function love.load()
	player.x = 30
	player.y = 30
	player.speed = 60
	player.sprite = love.graphics.newImage("player.png")
	player.width = player.sprite:getWidth()
	player.height = player.sprite:getHeight()

	map.w = 10
	map.h = 10
	map.ox = 30
	map.oy = 30
	map.wall = love.graphics.newImage("wall.png") -- 1
	map.grass = love.graphics.newImage("grass.png") -- 0

	player.x = player.x + map.ox
	player.y = player.y + map.oy
end

function love.update(dt)
	updatePlayer(dt)
end

function updatePlayer(dt)

	local up = love.keyboard.isDown("up")
	local down = love.keyboard.isDown("down")
	local left = love.keyboard.isDown("left")
	local right = love.keyboard.isDown("right")

	if up and not upCollide() then
		player.y = math.floor(player.y - player.speed * dt)
	end

	if down and not downCollide() then
        player.y = math.ceil(player.y + player.speed * dt)
    end
	
	if left and not leftCollide() then
        player.x = math.floor(player.x - player.speed * dt)
    end

	if right and not rightCollide() then
        player.x = math.ceil(player.x + player.speed * dt)
    end
end

function upCollide()
	--ul
	local ulx = math.floor(player.x)
	local uly = math.floor(player.y)
	uly = uly - 1 --simula o movimento para cima
	local res_ul = innerMapId(ulx, uly)
	res_ul = res_ul + 1 --pois o array comeca em 1

	--ur
	local urx = math.floor(player.x) + player.width - 1
	local ury = math.floor(player.y)
	ury = ury - 1
	local res_ur = innerMapId(urx, ury)
	res_ur = res_ur + 1

	-- 0 = block
	if map[res_ul] == 1 or map[res_ur] == 1 then
		return true
	else
		return false
	end
end

function downCollide()
	--ll
	local llx = math.floor(player.x)
	local lly = math.floor(player.y) + player.height - 1
	lly = lly + 1
	local res_ll = innerMapId(llx, lly)
	res_ll = res_ll + 1

	--lr
	local lrx = math.floor(player.x) + player.width - 1
	local lry = math.floor(player.y) + player.height - 1
	lry = lry + 1
	local res_lr = innerMapId(lrx, lry)
	res_lr = res_lr + 1

	if map[res_ll] == 1 or map[res_lr] == 1 then
		return true
	else
		return false
	end
end

function leftCollide()
	--ul
	local ulx = math.floor(player.x)
	local uly = math.floor(player.y)
	ulx = ulx - 1
	local res_ul = innerMapId(ulx, uly)
	res_ul = res_ul + 1

	--ll
	local llx = math.floor(player.x)
	local lly = math.floor(player.y) + player.height - 1
	llx = llx - 1
	local res_ll = innerMapId(llx, lly)
	res_ll = res_ll + 1

	if map[res_ul] == 1 or map[res_ll] == 1 then
		return true
	else
		return false
	end
end

function rightCollide()
	--ur
	local urx = math.floor(player.x) + player.width - 1
	local ury = math.floor(player.y)
	urx = urx + 1
	local res_ur = innerMapId(urx, ury)
	res_ur = res_ur + 1

	--lr
	local lrx = math.floor(player.x) + player.width - 1
	local lry = math.floor(player.y) + player.height - 1
	lrx = lrx + 1
	local res_lr = innerMapId(lrx, lry)
	res_lr = res_lr + 1

	if map[res_ur] == 1 or map[res_lr] == 1 then
		return true
	else
		return false
	end
end

function innerMapId(lx, ly)
	return math.floor((map.w * math.floor((ly - map.oy) / spriteSize)) + math.floor((lx - map.ox) / spriteSize))
end

function love.draw()
	drawMap()
	drawPlayer()
end

function drawMap()

	local lx = map.ox
	local ly = map.oy

	for i = 1, #map do

		--ver se da para pegar direto de um arr
		if map[i] == 1 then
			love.graphics.draw(map.wall, lx, ly)
		elseif map[i] == 0 then
			love.graphics.draw(map.grass, lx, ly)
		end

		lx = lx + spriteSize

		if lx == ((map.w * spriteSize) + map.ox) then
			lx = map.ox
			ly = ly + spriteSize
		end

	end
end

function drawPlayer()
	love.graphics.draw(player.sprite, math.floor(player.x), math.floor(player.y))
end