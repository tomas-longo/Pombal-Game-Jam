--//camera//
-- gets changed by each game as needed
cam = { x = 0, y = 0 }

--//timer//
-- baseline that gets decreased on channel increment
base_max_time = 6.0
-- current max time for current game
current_max_time = base_max_time
-- set by each game to add time to currentmaxtime
game_time_variation = 0
-- once it reaches currentmaxtime it gets reset
phase_time = 0
-- constant amount by which phasetime increases
frame_time_decrease = 0.0333

--//sound//
-- time left until channel changes
time_left = base_max_time
-- base delay (in seconds) between timer sfx plays
base_delay = 0.5
-- how fast it can go at the end
min_delay = 0.1
-- timestamp increased by shorter and shorter delays
next_beep = 0
-- cached timestamp from when channel last changed
time_when_game_changes = 0

-- keeps track of button states for adequate sfx playback
button_down_main = { false, false, false, false, false, false }

current_channel_index = 0
channel_ammount = 4

-- one bool for each game
game1_completed = false
game2_completed = false
game3_completed = false
game4_completed = false

end_game = false

function increment_channel()
	current_channel_index = current_channel_index + 1

	if current_channel_index >= channel_ammount then
		current_channel_index = 0

		base_max_time -= 1
		if base_max_time <= 0 then
			end_game = true
		end
	end

	on_channel_update()
end

function on_channel_update()
	if current_channel_index == 0 then
		on_emplastro_increment()
	elseif current_channel_index == 1 then
		on_cheeta_increment()
	elseif current_channel_index == 2 then
		on_indy_increment()
	elseif current_channel_index == 3 then
		on_runner_increment()
	end

	music(current_channel_index)
end

function update_end_screen()
	-- function in case extra logic is needed
	return end_game
end

function button_press_check()
	for i = 0, 5 do
		if button_down_main[i + 1] == false then
			if btn(i) then
				button_down_main[i + 1] = true
				-- play sfx feedback for button presses
				sfx(11)
			end
		else
			if not btn(i) then
				button_down_main[i + 1] = false
			end
		end
	end
end

function update_phase_timer()
	phase_time += frame_time_decrease
	current_max_time = base_max_time + game_time_variation

	if (phase_time >= current_max_time) then
		phase_time = 0
		next_beep = 0
		time_when_game_changes = time()
		increment_channel()
	end

	-- sound beep logic
	local time_elapsed = time() - time_when_game_changes
	time_left = max(0, current_max_time - time_elapsed)

	-- goes from 0 to 1
	local progress = 1 - (time_left / current_max_time)

	-- interpolate delay so beeps speed up toward end
	local delay = base_delay - (base_delay - min_delay) * progress

	if time_elapsed >= next_beep then
		-- play your sound effect (change to your SFX index)
		sfx(0)
		next_beep = time_elapsed + delay
	end
end

function draw_tv()
	--corners
	spr(196, cam.x, cam.y, 2, 2)
	spr(202, cam.x, cam.y + 112, 2, 2)
	spr(204, cam.x + 112, cam.y + 112, 2, 2)
	spr(200, cam.x + 112, cam.y, 2, 2)

	--borders
	for i = 0, 11 do
		spr(228, cam.x, cam.y + 16 + i * 8, 2, 1)
		spr(198, cam.x + 16 + i * 8, cam.y, 1, 2)
		spr(232, cam.x + 112, cam.y + 16 + i * 8, 2, 1)
		spr(206, cam.x + 16 + i * 8, cam.y + 112, 1, 2)
	end

	--knobs
	spr(234, cam.x + 75, cam.y + 112, 2, 2)
	spr(234, cam.x + 95, cam.y + 112, 2, 2)
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

	return end_game
end