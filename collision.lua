function upCollide(map, entity)
	--ul
	local ulx = math.floor(entity.x)
	local uly = math.floor(entity.y)
	uly = uly - entity.speed --simula o movimento para cima
	local res_ul = innerMapId(ulx, uly)
	res_ul = res_ul + 1 --pois o array comeca em 1

	--ur
	local urx = math.floor(entity.x) + entity.width - 1
	local ury = math.floor(entity.y)
	ury = ury - entity.speed
	local res_ur = innerMapId(urx, ury)
	res_ur = res_ur + 1

	if map[res_ul] == 1 or map[res_ur] == 1 then
		return true
	else
		return false
	end
end

function downCollide(map, entity)
	--ll
	local llx = math.floor(entity.x)
	local lly = math.floor(entity.y) + entity.height - 1
	lly = lly + entity.speed
	local res_ll = innerMapId(llx, lly)
	res_ll = res_ll + 1

	--lr
	local lrx = math.floor(entity.x) + entity.width - 1
	local lry = math.floor(entity.y) + entity.height - 1
	lry = lry + entity.speed
	local res_lr = innerMapId(lrx, lry)
	res_lr = res_lr + 1

	if map[res_ll] == 1 or map[res_lr] == 1 then
		return true
	else
		return false
	end
end

function leftCollide(map, entity)
	--ul
	local ulx = math.floor(entity.x)
	local uly = math.floor(entity.y)
	ulx = ulx - entity.speed
	local res_ul = innerMapId(ulx, uly)
	res_ul = res_ul + 1

	--ll
	local llx = math.floor(entity.x)
	local lly = math.floor(entity.y) + entity.height - 1
	llx = llx - entity.speed
	local res_ll = innerMapId(llx, lly)
	res_ll = res_ll + 1

	if map[res_ul] == 1 or map[res_ll] == 1 then
		return true
	else
		return false
	end
end

function rightCollide(map, entity)
	--ur
	local urx = math.floor(entity.x) + entity.width - 1
	local ury = math.floor(entity.y)
	urx = urx + entity.speed
	local res_ur = innerMapId(urx, ury)
	res_ur = res_ur + 1

	--lr
	local lrx = math.floor(entity.x) + entity.width - 1
	local lry = math.floor(entity.y) + entity.height - 1
	lrx = lrx + entity.speed
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