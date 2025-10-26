
playingCheeta = true
ac=0.04 -- acceleration
cameraspeed = 0
cameraac = 0
maploc={x=0,y=0}
game_won = false
button_down = false

function init_cheeta()
	cam.x = 0
	cam.y = 128
	cheetachar={posx = cam.x + 20, posy = cam.y + 70, vel = 0, dir = 1, frame = 0, timer = 0, framespeed = 0.2}
end

function cheeta_start()
	cam.x = 0
	cam.y = 128
	cheetachar.posx = cam.x + 20
	music(3)
end

function update_cheeta()
	game_time_variation = 0
	
	if (game_won) then
		cameraspeed *= .95
		cheetachar.vel *= .96
	else
		cheetachar.vel += ac

		if (not button_down) then
			if (btn(1)) then
				button_down = true
				cameraspeed += 0.22
			end
		else
			if (not btn(1)) then
				button_down = false
			end
		end
	end
	-- move (add velocity)
	cam.x += cameraspeed
	cheetachar.posx += cheetachar.vel
	
	cheetachar.timer += cheetachar.vel * cheetachar.framespeed
	if (cheetachar.vel < 0.1) then cheetachar.frame = 4
	elseif cheetachar.timer >= 1 then
		cheetachar.timer = 0
		cheetachar.frame = (cheetachar.frame + 2) % 4
	end
	
	if (cam.x >= 214) then
		local dif = cam.x
		cam.x = 0
		cheetachar.posx -= dif
	end
	
	if cheetachar.posx < cam.x then
		game_won = true
		game2_completed = true
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
	if game_won then
		print ("fastest man alive!", cam.x + 25, cam.y + 30, 7)
	else
		print ("smash ➡️", cam.x + 30, cam.y + 30,7)
	end
end