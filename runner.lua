win_runner = false

input_right = false
runner_frame = 0
pointer_speed = 6
-- direction in which the pointer moves
pointer_direction = 1
half_pointer_size = 4
-- gets increased in case of penalty
pointer_delay = 0.0

left_down = false
right_down = false

cam_runner_x = 256
cam_runner_y = 0

-- range in which input is valid
sweet_spot = { l = cam_runner_x + 53, r = cam_runner_x + 73 }
meter_extremes = { l = cam_runner_x + 23, r = cam_runner_x + 103 }

finish_line = { x = cam_runner_x + 85, y = cam_runner_y + 70 }
pointer = { x = cam_runner_x + 27, y = cam_runner_y + 89 }
runner = { x = cam_runner_x + 30, y = cam_runner_y + 70 }

function check_runner_input(in_right)
	if input_right != in_right then
		pointer_delay = 1
		return
	end

	if pointer.x >= sweet_spot.l - half_pointer_size and pointer.x <= sweet_spot.r - half_pointer_size then
		finish_line.x -= 2
		input_right = flr(rnd(2)) == 0

		if runner_frame == 0 then
			runner_frame = 1
		else
			runner_frame = 0
		end
	else
		pointer_delay = 1
	end
end

function init_runner()
	-- in case it's needed
end

function on_runner_increment()
	cam.x = cam_runner_x
	cam.y = cam_runner_y

	camera(cam.x, cam.y)

	game_time_variation = 0
end

function update_runner()
	-- early return
	if win_runner then
		return
	end

	-- inputs
	if not left_down then
		if btn(⬅️) then
			left_down = true
			check_runner_input(false)
		end
	else
		if not btn(⬅️) then
			left_down = false
		end
	end

	if not right_down then
		if btn(➡️) then
			right_down = true
			check_runner_input(true)
		end
	else
		if not btn(➡️) then
			right_down = false
		end
	end

	-- pointer
	if pointer.x <= meter_extremes.l - half_pointer_size then
		pointer_direction = 1
	elseif pointer.x >= meter_extremes.r - half_pointer_size then
		pointer_direction = -1
	end

	pointer_delay *= 0.5
	if pointer_delay < 0.001 then
		pointer_delay = 0
		pointer.x += pointer_speed * pointer_direction
	end
	
	-- win condition
	if finish_line.x <= runner.x then
		pointer_speed = 0
		win_runner = true
		game4_completed = true
	end
end

function draw_runner()
	cls(12)
	map()

	-- ground
	rectfill(cam_runner_x, cam_runner_y + 85, cam_runner_x + 128, cam_runner_y + 128, 4)

	-- finish line
	spr(237, finish_line.x, finish_line.y, 2, 2)

	-- pointer
	spr(224, pointer.x, pointer.y)

	-- input string
	local direction_string = "⬅️"
	if input_right then
		direction_string = "➡️"
	end
	print(direction_string, cam_runner_x + 61, cam_runner_y + 102, 7)

	-- runner
	local current_frame = 192
	if runner_frame == 1 then
		current_frame = 194
	end
	spr(current_frame, runner.x, runner.y, 2, 2)

	-- meter
	rectfill(meter_extremes.l, cam_runner_y + 98, meter_extremes.r, cam_runner_y + 98, 6)
	rectfill(sweet_spot.l, cam_runner_y + 98, sweet_spot.r, cam_runner_y + 98, 2)

	if win_runner == true then
		print("you win!", cam_runner_x + 20, cam_runner_y + 20, 7)
	end
end