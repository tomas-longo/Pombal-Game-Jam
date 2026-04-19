camera_speed = 0
cheeta_char = { posx = 0, posy = 0, vel = 0, frame = 0, timer = 0, animspeed = 0 }

cheeta_initial_mltplr = 10
cheeta_mltplr = 0

cam_cache = 0

button_down = false
game_won = false

function init_cheeta()
	cheeta_mltplr = cheeta_initial_mltplr
	cheeta_char = { posx = 0 + 20, posy = 128 + 70, vel = 0, frame = 0, timer = 0, animspeed = 0.07 }
end

function on_cheeta_increment()
	cam.x = cam_cache
	cam.y = 128
	game_time_variation = 0
end

function update_cheeta()
	if game_won then
		camera_speed *= .95
		cheeta_char.vel *= .96
	else
		cheeta_char.vel += 0.04

		-- make the input less effective during the initial moments
		cheeta_mltplr = max(0, cheeta_mltplr * 0.98)

		if not button_down then
			if btn(1) then
				button_down = true

				-- goes from 0 to 1
				local input_mltplr = (1 - (cheeta_mltplr / cheeta_initial_mltplr))
				camera_speed += (0.22 * input_mltplr) 
			end
		else
			if not btn(1) then
				button_down = false
			end
		end
	end

	-- move (add velocity)
	cam.x += camera_speed
	cheeta_char.posx += cheeta_char.vel

	-- cheeta animation
	cheeta_char.timer += cheeta_char.vel * cheeta_char.animspeed
	if (cheeta_char.vel < 0.07) then
		cheeta_char.frame = 4
	elseif cheeta_char.timer >= 1 then
		cheeta_char.timer = 0
		cheeta_char.frame = (cheeta_char.frame + 2) % 4
	end

	-- cam loop around
	if (cam.x >= 214) then
		cheeta_char.posx -= cam.x
		cam.x = 0
	end

	if cheeta_char.posx < cam.x and game_won == false then
		game_won = true
		game2_completed = true
	end

	cam_cache = cam.x
end

function draw_cheeta()
	cls(4)
	camera(cam.x, cam.y)
	map()

	-- draw sky
	rectfill(cam.x, cam.y, cam.x + 128, cam.y + 50, 9)

	-- draw sun
	spr(113,cam.x + 95, cam.y + 22)

	spr(
		101 + cheeta_char.frame, -- frame index
		cheeta_char.posx, cheeta_char.posy, -- x,y
		2, 2, true -- w,h, flip
	)

	if game_won then
		print("fastest man alive!", cam.x + 25, cam.y + 30, 7)
	else
		print("spam ➡️", cam.x + 30, cam.y + 30, 7)
	end
end