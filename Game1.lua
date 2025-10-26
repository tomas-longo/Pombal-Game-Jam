-- stores first sprite of each row - 1
puzzle_sprites = { 27, 43, 59 }

piece_draw_offset = 9
piece_size = 8
inbetween_piece_distance = 0
x_puzzle_offset = 40
y_puzzle_offset = 40

-- 0-3 grid coordinate that is currently selected
x_selection = 0
y_selection = 0

-- 2D array.
-- Values: 0=NoFlipping, 1=HFlipping, 2=VFlipping, 3=BothFlipping
puzzle_flip_state = {}

bckgrnd_color = 1
selection_color = 8

puzzle_completed = false


function check_win_state()
	for x = 1, 3 do
		for y = 1, 3 do
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


function _init()
	color(selection_color)
	inbetween_piece_distance = piece_draw_offset - piece_size

	-- setup puzzle_flip_state
	for x = 1, 3 do
		puzzle_flip_state[x] = {}
		for y = 1, 3 do
			-- a random integer between [0 and 3]
			-- pray that it doesnt turn out to be all 0s
			puzzle_flip_state[x][y] = flr(rnd(4))
		end
	end
end

function _update()
	if btnp(⬅️) then
		x_selection = mid(x_selection - 1, 2)
	end

	if btnp(➡️) then
		x_selection = mid(x_selection + 1, 2)
	end

	if btnp(⬆️) then
		y_selection = mid(y_selection - 1, 2)
	end

	if btnp(⬇️) then
		y_selection = mid(y_selection + 1, 2)
	end

	if btnp(🅾️) then
		if puzzle_completed == false then
			handle_flip_input(true)
			puzzle_completed = check_win_state()
		end
	end

	if btnp(❎) then
		if puzzle_completed == false then
			handle_flip_input(false)
			puzzle_completed = check_win_state()
		end
	end
end

function _draw()
	cls(bckgrnd_color)

	-- draw puzzle pieces
	for ypiece = 1, 3 do
		for xpiece = 1, 3 do
			sprite_index = puzzle_sprites[ypiece] + xpiece
			local x_pos = x_puzzle_offset + (xpiece - 1) * piece_draw_offset
			local y_pos = y_puzzle_offset + (ypiece - 1) * piece_draw_offset

			local flip_h = flip_state_interp(puzzle_flip_state[ypiece][xpiece], true)
			local flip_v = flip_state_interp(puzzle_flip_state[ypiece][xpiece], false)

			spr(sprite_index, x_pos, y_pos, 1, 1, flip_h, flip_v)
		end
	end

	local selection_coord_x = x_puzzle_offset + x_selection * (piece_size + inbetween_piece_distance) - 1
	local selection_coord_y = y_puzzle_offset + y_selection * (piece_size + inbetween_piece_distance) - 1

	local x_selection_size = selection_coord_x + piece_size + 1
	local selection_size_coord_y = selection_coord_y + piece_size + 1

	-- draw selection rectangle
	rect(selection_coord_x, selection_coord_y, x_selection_size, selection_size_coord_y)
end