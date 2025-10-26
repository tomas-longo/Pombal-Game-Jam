function init_corrida()
	finish = { x = 100, y = 80 }
	pointer = { x = 7, y = 92 }
	point_a = { x = 7, y = 92 }
	point_b = { x = 95, y = 92 }
	player = { x = 30, y = 80 }
	key = { x = 50, y = 110 }
	moving_b = true
	ab = { 2, 3 }
	speed = 6
	n = 2
	win = false
end

function delay_corrida(t)
	for x = 1, t do
		yield()
	end
end

function update_corrida()

	game_time_variation = 0

	if n == 2 then
		if btn(➡️) then
			if pointer.x >= 45 then
				if pointer.x <= 65 then
					finish.x -= 1
					n = rnd(ab)
					delay(2)
				end
			end
		end
	else
		if btn(⬅️) then
			if pointer.x >= 45 then
				if pointer.x <= 65 then
					finish.x -= 1
					n = rnd(ab)
					delay(2)
				end
			end
		end
	end
	if moving_b then
		pointer.x += speed
		if pointer.x >= point_b.x then
			moving_b = false
		end
	else
		pointer.x -= speed
		if pointer.x <= point_a.x then
			moving_b = true
		end
	end
	if finish.x <= player.x then
		winstate()
	end
end

function winstate_corrida()
	speed = 0
	win = true
end

function draw_corrida()
	cls()
	map()
	spr(0, finish.x, 80)
	spr(5, pointer.x, pointer.y)
	spr(n, key.x, key.y)
	spr(4, player.x, player.y)
	rectfill(100, 100, 10, 100, 6)
	rectfill(65, 100, 45, 100, 2)
	if win == true then
		spr(6, 20, 20, 2, 2)
	end
end