
playingCheeta = true
cheetachar={posx = 1, posy = 65, vel = 0, dir = 1, frame = 0, timer = 0, framespeed = 0.2}
ac=0.03 -- acceleration
cameraspeed = 0
cameraac = 0
maploc={x=0,y=0}

function _initcheeta()

end

function _updatecheeta()
	cheetachar.vel += ac
	if (btnp(➡️)) then
		cameraac += 0.003
		sfx(40)
	end
	cameraspeed += cameraac
	maploc.x += cameraspeed
	-- move (add velocity)
	cheetachar.posx += cheetachar.vel

	cheetachar.timer += cheetachar.vel * cheetachar.framespeed
	if cheetachar.timer >= 1 then
		cheetachar.timer = 0
		cheetachar.frame = (cheetachar.frame + 2) % 4
	end
	
	if cheetachar.posx > maploc.x + 128 then
		playingCheeta = false
	end
end

function _drawcheeta()
	cls(1)
	if playingCheeta then
		cls(12)
		--change camera map position
		camera(maploc.x, maploc.y)
		-- draw the whole map
		map()
		-- draw the cheeta
		spr(80+cheetachar.frame,      -- frame index
			cheetachar.posx,cheetachar.posy, -- x,y (pixels)
			2,2,cheetachar.dir==-1    -- w,h, flip
		)
		print ("➡️ keep up with the cheeta", 10,30,7)
	end
end