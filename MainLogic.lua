--camera
cam = { x = 0, y = 0 }

--timer
global_max_time = 1.0
current_max_time = 0
game_time_variation = 0
phase_time = 0
frame_time_decrease = 0.033333333333333

--sound
time_left = global_max_time
-- base delay (in seconds) between sound plays
base_delay = .5
-- how fast it can go at the end
min_delay = 0.1
-- track when to play next
next_beep = 0

current_channel_index = 0
channel_number = 3

-- TODO: be sure to assign one in each game's code
game1_completed = false
game2_completed = false
game3_completed = false
game4_completed = false

end_game = false

function increment_channel()
	current_channel_index = current_channel_index + 1
	if current_channel_index >= channel_number then
		current_channel_index = 0

		global_max_time = mid(0, global_max_time - 1, 5)

		if global_max_time <= 0 then
			end_game = true
		end
	end
end

function init_timer()
	next_beep = time()
	current_max_time = global_max_time
end

function update_phase_timer()
	phase_time += frame_time_decrease

	current_max_time = global_max_time + game_time_variation

	-- on end game timer
	if (phase_time >= current_max_time) then
		phase_time = 0
		increment_channel()
	end

	-- sound beep logic
	--[[ local t = time()
	time_left = max(0, current_max_time - t)

	local progress = 1 - (time_left / current_max_time)

	-- interpolate delay so beeps speed up toward end
	local delay = base_delay - (base_delay - min_delay) * progress

	if t >= next_beep then
	-- play your sound effect (change to your SFX index)
		sfx(0)
		next_beep = t + delay
	end ]]
end

function draw_phase_timer()
	rectfill(cam.x + 13, cam.y + 3, cam.x + 115, cam.y + 7, 1)
	rectfill(cam.x + 14, cam.y + 4, cam.x + 14 + (phase_time / current_max_time) * 100, cam.y + 6, 7)
end

function draw_end_screen()
	if end_game then
		camera(0, 0)
		map()
		cls(0)
		rectfill(0, 0, 128, 128, 0)

		end_string_1 = "oops. amused yourself"
		end_string_2 = "to death :/"

		if game1_completed and game2_completed and game3_completed and game4_completed then
			end_string_1 = "congrats! maybe that's enough"
			end_string_2 = " media for today though."
		end

		print(end_string_1, 10, 10, 7)
		print(end_string_2, 10, 20, 7)
	end
end

function draw_tv()
	--corners
	spr(128, cam.x, cam.y, 2, 2)
	spr(202, cam.x, cam.y + 112, 2, 2)
	spr(204, cam.x + 112, cam.y + 112, 2, 2)
	spr(200, cam.x + 112, cam.y, 2, 2)

	--borders
	for i = 0, 11 do
		spr(228, cam.x, cam.y + 16 + i * 8, 2, 1)
		spr(198, cam.x + 16 + i * 8, cam.y, 1, 2)
		spr(232, cam.x + 112, cam.y + 16 + i * 8, 2, 1)
		spr(230, cam.x + 16 + i * 8, cam.y + 112, 1, 2)
	end

	spr(234, cam.x + 72, cam.y + 112, 2, 2)
	spr(234, cam.x + 88, cam.y + 112, 2, 2)
end