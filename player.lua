require("innerid")

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

	if up and not upCollide(map) then
		player.y = player.y - player.speed
	end

	if down and not downCollide(map) then
        player.y = player.y + player.speed
    end
	
	if left and not leftCollide(map) then
        player.x = player.x - player.speed
    end

	if right and not rightCollide(map) then
        player.x = player.x + player.speed
    end
end

function upCollide(map)
	--ul
	local ulx = math.floor(player.x)
	local uly = math.floor(player.y)
	uly = uly - player.speed --simula o movimento para cima
	local res_ul = innerMapId(ulx, uly)
	res_ul = res_ul + 1 --pois o array comeca em 1

	--ur
	local urx = math.floor(player.x) + player.width - 1
	local ury = math.floor(player.y)
	ury = ury - player.speed
	local res_ur = innerMapId(urx, ury)
	res_ur = res_ur + 1

	if map[res_ul] == 1 or map[res_ur] == 1 then
		return true
	else
		return false
	end
end

function downCollide(map)
	--ll
	local llx = math.floor(player.x)
	local lly = math.floor(player.y) + player.height - 1
	lly = lly + player.speed
	local res_ll = innerMapId(llx, lly)
	res_ll = res_ll + 1

	--lr
	local lrx = math.floor(player.x) + player.width - 1
	local lry = math.floor(player.y) + player.height - 1
	lry = lry + player.speed
	local res_lr = innerMapId(lrx, lry)
	res_lr = res_lr + 1

	if map[res_ll] == 1 or map[res_lr] == 1 then
		return true
	else
		return false
	end
end

function leftCollide(map)
	--ul
	local ulx = math.floor(player.x)
	local uly = math.floor(player.y)
	ulx = ulx - player.speed
	local res_ul = innerMapId(ulx, uly)
	res_ul = res_ul + 1

	--ll
	local llx = math.floor(player.x)
	local lly = math.floor(player.y) + player.height - 1
	llx = llx - player.speed
	local res_ll = innerMapId(llx, lly)
	res_ll = res_ll + 1

	if map[res_ul] == 1 or map[res_ll] == 1 then
		return true
	else
		return false
	end
end

function rightCollide(map)
	--ur
	local urx = math.floor(player.x) + player.width - 1
	local ury = math.floor(player.y)
	urx = urx + player.speed
	local res_ur = innerMapId(urx, ury)
	res_ur = res_ur + 1

	--lr
	local lrx = math.floor(player.x) + player.width - 1
	local lry = math.floor(player.y) + player.height - 1
	lrx = lrx + player.speed
	local res_lr = innerMapId(lrx, lry)
	res_lr = res_lr + 1

	if map[res_ur] == 1 or map[res_lr] == 1 then
		return true
	else
		return false
	end
end

player.draw = function()
	love.graphics.draw(player.sprite, player.x, player.y)
end