function innerMapId(lx, ly)
	return math.floor((map.w * math.floor((ly - map.oy) / spriteSize)) + math.floor((lx - map.ox) / spriteSize))
end