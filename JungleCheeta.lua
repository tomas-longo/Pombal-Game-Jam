
playingCheeta = true
ac=0.04 -- acceleration
cameraspeed = 0
cameraac = 0
maploc={x=0,y=0}

function init_cheeta()
	cam.x = 0
	cam.y = 128
	cheetachar={posx = cam.x + 20, posy = cam.y + 70, vel = 0, dir = 1, frame = 0, timer = 0, framespeed = 0.2}
end

function update_cheeta()
	cam.x = 0
	cam.y = 128

	game_time_variation = 0

	cheetachar.vel += ac
	if (btnp(➡️)) then
		cameraac += 0.003
	end
	cameraspeed += cameraac
	cam.x += cameraspeed
	-- move (add velocity)
	cheetachar.posx += cheetachar.vel

	cheetachar.timer += cheetachar.vel * cheetachar.framespeed
	if cheetachar.timer >= 1 then
		cheetachar.timer = 0
		cheetachar.frame = (cheetachar.frame + 2) % 4
	end
	
	if (cam.x >= 216) then
		cam.x = 0
		cheetachar.posx -= 216
	end
	
	if cheetachar.posx < cam.x then

	end
end

function draw_cheeta()
	cls(4)
	--change camera map position
	camera(cam.x, cam.y)
	-- draw the whole map
	map()
	-- draw the cheeta
	spr(101+cheetachar.frame,      -- frame index
		cheetachar.posx,cheetachar.posy, -- x,y (pixels)
		2,2,cheetachar.dir==1    -- w,h, flip
	)
	print ("smash ➡️", cam.x + 30, cam.y + 30,7)
end