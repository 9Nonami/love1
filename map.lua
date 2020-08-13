map = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
map.w = 10
map.h = 10
map.ox = 30
map.oy = 30
map.wall = love.graphics.newImage("sprites/wall.png") -- 1
map.grass = love.graphics.newImage("sprites/grass.png") -- 0

map.draw = function()

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