-- stores first sprite of each row - 1
puzzle_sprites = { 74, 90, 106, 122 }
indy_sprites = { 65, 66 }
indy_anim_index = 1

indy_location_x = 40
indy_location_y = 80

piece_draw_offset = 9
piece_size = 8
piece_grid_side = 4
inbetween_piece_distance = 0

cam_pos_puzzle_x = 160
cam_pos_puzzle_y = 0

x_puzzle_offset = 70
y_puzzle_offset = 48

-- 0-piece_grid_side grid coordinate that is currently selected
x_selection = 0
y_selection = 0

-- 2D array.
-- Values: 0=NoFlipping, 1=HFlipping, 2=VFlipping, 3=BothFlipping
puzzle_flip_state = {}

bckgrnd_color = 14
selection_color = 8

puzzle_completed = false


function check_puzzle_win_state()
	for x = 1, piece_grid_side do
		for y = 1, piece_grid_side do
			if puzzle_flip_state[x][y] != 0 then
				return false
			end
		end
	end

	return true
end

-- for a given int returns if h_flip or v_flip are true
function flip_state_interp(in_int, get_horizontal)
	if in_int == 0 then
		return false
	elseif in_int == 1 and get_horizontal then
		return true
	elseif in_int == 2 and get_horizontal == false then
		return true
	elseif in_int == 3 then
		return true
	else
		return false
	end
end

-- argument false to flip vertically
function handle_flip_input(flip_horizontal)
	local int_to_use = puzzle_flip_state[y_selection + 1][x_selection + 1]

	if int_to_use == 0 then
		if flip_horizontal then
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 1
		else
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 2
		end
	elseif int_to_use == 1 then
		if flip_horizontal then
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 0
		else
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 3
		end
	elseif int_to_use == 2 then
		if flip_horizontal then
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 3
		else
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 0
		end
	elseif int_to_use == 3 then
		if flip_horizontal then
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 2
		else
			puzzle_flip_state[y_selection + 1][x_selection + 1] = 1
		end
	end
end


function init_indy()
	cam.x = cam_pos_puzzle_x
	cam.y = cam_pos_puzzle_y

	x_puzzle_offset = cam_pos_puzzle_x + x_puzzle_offset
	y_puzzle_offset = cam_pos_puzzle_y + y_puzzle_offset

	indy_location_x = cam_pos_puzzle_x + indy_location_x
	indy_location_y = cam_pos_puzzle_y + indy_location_y

	inbetween_piece_distance = piece_draw_offset - piece_size

	-- setup puzzle_flip_state
	for x = 1, piece_grid_side do
		puzzle_flip_state[x] = {}
		for y = 1, piece_grid_side do
			-- a random integer between [0 and 3]
			-- pray that it doesnt turn out to be all 0s
			--puzzle_flip_state[x][y] = flr(rnd(4))
			puzzle_flip_state[x][y] = 0
		end
	end
end

function update_indy()
	if btnp(⬅️) then
		x_selection = mid(x_selection - 1, piece_grid_side - 1)
	end

	if btnp(➡️) then
		x_selection = mid(x_selection + 1, piece_grid_side - 1)
	end

	if btnp(⬆️) then
		y_selection = mid(y_selection - 1, piece_grid_side - 1)
	end

	if btnp(⬇️) then
		y_selection = mid(y_selection + 1, piece_grid_side - 1)
	end

	if btnp(🅾️) then
		if puzzle_completed == false then
			handle_flip_input(true)
			puzzle_completed = check_puzzle_win_state()
		end
	end

	if btnp(❎) then
		if puzzle_completed == false then
			handle_flip_input(false)
			puzzle_completed = check_puzzle_win_state()
		end
	end
end

function draw_indy()
	cls(bckgrnd_color)
	camera(cam.x, cam.y)

	-- door
	if puzzle_completed == false then
		rectfill(cam.x + 30, cam.y + 65, cam.x + 40, cam.x + 80, 0)	
	end

	-- map
	map()

	-- draw puzzle background
	local background_side = (piece_grid_side * piece_size) + ((piece_grid_side - 2) * inbetween_piece_distance)
	local puzzle_background_extent_x = x_puzzle_offset + background_side
	local puzzle_background_extent_y = y_puzzle_offset + background_side
	rectfill(x_puzzle_offset, y_puzzle_offset, puzzle_background_extent_x, puzzle_background_extent_y, 0)

	-- draw puzzle pieces
	for ypiece = 1, piece_grid_side do
		for xpiece = 1, piece_grid_side do
			local sprite_index = puzzle_sprites[ypiece] + xpiece
			local x_pos = x_puzzle_offset + (xpiece - 1) * piece_draw_offset
			local y_pos = y_puzzle_offset + (ypiece - 1) * piece_draw_offset

			local flip_h = flip_state_interp(puzzle_flip_state[ypiece][xpiece], true)
			local flip_v = flip_state_interp(puzzle_flip_state[ypiece][xpiece], false)

			spr(sprite_index, x_pos, y_pos, 1, 1, flip_h, flip_v)
		end
	end

	-- draw selection rectangle
	local selection_coord_x = x_puzzle_offset + x_selection * (piece_size + inbetween_piece_distance) - 1
	local selection_coord_y = y_puzzle_offset + y_selection * (piece_size + inbetween_piece_distance) - 1

	local x_selection_size = selection_coord_x + piece_size + 1
	local selection_size_coord_y = selection_coord_y + piece_size + 1

	rect(selection_coord_x, selection_coord_y, x_selection_size, selection_size_coord_y, selection_color)

	-- draw indy
	if  puzzle_completed then
		if indy_anim_index > 2.9 then
			indy_anim_index = 1
		else
			indy_anim_index = indy_anim_index + 0.1
		end
	end
	spr(indy_sprites[flr(indy_anim_index)], indy_location_x, indy_location_y)


	print("complete picture.", cam.x + 30, cam.y + 20, 0)
	print("flip tiles with 🅾️ and ❎", cam.x + 15, cam.y + 30, 0)

end