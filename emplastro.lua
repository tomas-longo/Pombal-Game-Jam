boards = {}
boardvelocity = 1
board_max_y = 85
board_min_y = 60

anim_speed = 0.1
anim_counter = 1

reporter_accel = 0.4
reporter_friction = 0.92

emplastro_accel = 0.3
emplastro_friction = 0.9

emplastro_progress = 0
emplastro_progress_speed = 0.005

emplastro_character = { x = cam.x + 64, y = cam.y + 80, vx = 0, vy = 0, f = 1, d = 1 }
reporter_character = { x = cam.x, y = cam.y + 64, vx = 0, vy = 0, d = 1 }
airplane = { x = cam.x, y = cam.y + 30, v = 0.1 }

win_emplastro = false

function make_board(x, y, w, h, dir, text)
	a = {
		x = x,
		y = y,
		w = w,
		h = h,
		dir = dir,
		text = text
	}

	add(boards, a)
end

function draw_flame(sprite, anim_multiplier, flame_x, flame_y)
	spr(
		sprite + flr(anim_counter) * anim_multiplier,
		cam.x + flame_x, cam.y + flame_y,
		1, 1
	)
end

function draw_boards()
	for board in all(boards) do
		rectfill(cam.x + board.x - 1, cam.y + board.y + board.h, cam.x + board.x + 1, cam.y + 95, 4)
		rectfill(cam.x + board.x - board.w, cam.y + board.y - board.h, cam.x + board.x + board.w, cam.y + board.y + board.h, 4)
		print(board.text, cam.x + board.x - board.w + 1, cam.y + board.y, 7)
	end
end

function init_emplastro()
	make_board(23, 70, 10, 5, 1, "😐⌂")
	make_board(42, 50, 15, 7, 1, "fim fmi")
end

function on_emplastro_increment()
	cam.x = 0
	cam.y = 0

	camera(cam.x, cam.y)

	game_time_variation = 0
end

function update_emplastro()
	--boards
	for board in all(boards) do
		if (board.y > board_max_y) then
			board.dir = -1
		end
		if (board.y < board_min_y) then
			board.dir = 1
		end
		board.y += (boardvelocity * board.dir)
	end

	--airplane
	airplane.x += airplane.v

	--//emplastro//
	if btn(0) then
		emplastro_character.vx -= emplastro_accel
		emplastro_character.d = -1
	end
	if btn(1) then
		emplastro_character.vx += emplastro_accel
		emplastro_character.d = 1
	end
	-- move (add velocity)
	emplastro_character.x += emplastro_character.vx

	-- friction (lower for more)
	emplastro_character.vx *= emplastro_friction

	-- clamp
	if (emplastro_character.x < cam.x + 16) then emplastro_character.x = cam.x + 16 end
	if (emplastro_character.x > cam.x + 96) then emplastro_character.x = cam.x + 96 end

	--//reporter//
	if (reporter_character.x + 8 > emplastro_character.x) then
		reporter_character.vx += reporter_accel
	else
		reporter_character.vx -= reporter_accel
	end

	-- friction
	reporter_character.vx *= reporter_friction
	reporter_character.x -= reporter_character.vx

	-- //animation//
	anim_counter += anim_speed
	if (anim_counter >= 2) then anim_counter = 0 end

	--//points//
	if (emplastro_character.x > reporter_character.x + 16 or emplastro_character.x < reporter_character.x - 16) then
		emplastro_progress += emplastro_progress_speed
	end
	if (emplastro_progress >= 1) then
		emplastro_progress = 1
		win_emplastro = true
		game3_completed = true
	end
end

function draw_emplastro()
	cls(10)
	map()

	spr(18, airplane.x, airplane.y, 2, 1)

	if not win_emplastro then
		draw_boards()

		draw_flame(51, 1, 64, 24)
		draw_flame(52, -1, 92, 24)
		draw_flame(35, 1, 88, 55)

		spr(
			32,
			emplastro_character.x, emplastro_character.y, -- x,y (pixels)
			2, 2,
			emplastro_character.d == -1
		)
		spr(
			5 + flr(anim_counter) * 4,
			reporter_character.x, reporter_character.y,
			4, 4,
			reporter_character.d == -1
		)

		rectfill(cam.x + 24, cam.y + 13, cam.x + 101, cam.y + 16, 1)
		rectfill(cam.x + 25, cam.y + 14, cam.x + 25 + emplastro_progress * (100 - 25), cam.y + 15, 11)
		print("⬅️ and ➡️ to move", cam.x + 30, cam.y + 18, 1)
	end

	if win_emplastro then
		spr(
			32,
			emplastro_character.x, emplastro_character.y, -- x,y (pixels)
			2, 2,
			emplastro_character.d == -1
		)
		print("emplastro on live tv", cam.x + 20, cam.y + 18, 1)
	end
end