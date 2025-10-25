-- stores first sprite of each row - 1
puzzle_sprites = { 27, 43, 59 }

piece_draw_offset = 9
piece_size = 8
inbetween_piece_distance = 0
x_puzzle_offset = 40
y_puzzle_offset = 40

x_selection = 0
y_selection = 0

flip_h_input = false
flip_v_input = false

-- 2D array.
-- Values: 0=NoFlipping, 1=HFlipping, 2=VFlipping, 3=BothFlipping
puzzle_flip_state = {}

bckgrnd_color = 1
selection_color = 8


function flip_state_interp(in_int, get_horizontal)
	if in_int == 0 then
		return false
	elseif in_int == 1 and get_horizontal then
		return true
	elseif in_int == 2 and get_horizontal == false then
		print(2)
		return true
	elseif in_int == 3 then
		return true
	else
		return false
	end
end


function handle_flip_input(in_int, flip_horizontal)


	
	int_to_use = puzzle_flip_state[x][y]


	if flip_horizontal then
		print(2)
	else
		print(2)
	end

	flip_state_interp(in_int, )

	if in_int == 0 then
		return false
	elseif in_int == 1 and get_horizontal then
		return true
	elseif in_int == 2 and get_horizontal == false then
		print(2)
		return true
	elseif in_int == 3 then
		return true
	else
		return false
	end
end


function _init()
	color(selection_color)
	inbetween_piece_distance = piece_draw_offset - piece_size

	for x = 1, 3 do
		puzzle_flip_state[x] = {}
		for y = 1, 3 do
			puzzle_flip_state[x][y] = 0
		end
	end

	--puzzle_flip_state[2][2] = 2
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
		puzzle_flip_state[2][2] = 2
	end

	if btnp(❎) then
		flip_v_input = true
	end
end

function _draw()
	cls(bckgrnd_color)

	-- draw puzzle pieces
	for ypiece = 1, 3 do
		for xpiece = 1, 3 do
			sprite_index = puzzle_sprites[ypiece] + xpiece
			x_pos = x_puzzle_offset + (xpiece - 1) * piece_draw_offset
			y_pos = y_puzzle_offset + (ypiece - 1) * piece_draw_offset

			flip_h = flip_state_interp(puzzle_flip_state[ypiece][xpiece], true)
			flip_v = flip_state_interp(puzzle_flip_state[ypiece][xpiece], false)

			spr(sprite_index, x_pos, y_pos, 1, 1, flip_h, flip_v)
		end
	end

	selection_coord_x = x_puzzle_offset + x_selection * (piece_size + inbetween_piece_distance)
	selection_coord_y = y_puzzle_offset + y_selection * (piece_size + inbetween_piece_distance)

	x_selection_size = selection_coord_x + piece_size - 1
	selection_size_coord_y = selection_coord_y + piece_size - 1

	-- draw selection rectangle
	rect(selection_coord_x, selection_coord_y, x_selection_size, selection_size_coord_y)

	--pset(40, 40)

	--circfill(x, y, 14, 14)
end