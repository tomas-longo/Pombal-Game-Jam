
function _init_corrida()
	cam.x =111*8
	cam.y =01*8
	finish=	{x= cam.x+100,y=cam.y+60}
	pointer={x = cam.x+7,y = cam.y+92}
	point_a={x=cam.x+7,y=cam.y+92}
	point_b={x=cam.x+95,y=cam.y+92}
	player={x=cam.x+30,y=cam.y+70}
	key={x=cam.x+50,y=cam.y+110}
	moving_b=true
	ab={240,241}
	speed=6
	n=240
	win=false
	frame_a=192
	frame_b=194
	current_frame = frame_a
end

function delay_corrida(t)
	for x=1, t do
		yield()
	end
end

function _update_corrida()
	if n==240 then
		if btn(➡️) then
			if pointer.x>=cam.x+45 then
				if pointer.x<=cam.x+65 then
						finish.x -=2
						n=rnd(ab)
						delay_corrida(2)
						if current_frame == frame_a then
							current_frame = frame_b
						else
							current_frame = frame_a
						end
				end
			end
		end
		else	
			if btn(⬅️) then
			if pointer.x>=cam.x+45 then
				if pointer.x<=cam.x+65 then
						finish.x -=2
						n=rnd(ab)
						delay_corrida(2)
						if current_frame == frame_a then
							current_frame = frame_b
						else
							current_frame = frame_a
						end
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
		if pointer.x<= point_a.x then
			moving_b = true
		end
	end

	if finish.x-15<=player.x then
	winstate_corrida()
	end
end

function winstate_corrida()
speed=0
win=true
end

function _draw_corrida()
	cls()
	camera(cam.x,cam.y)
	map()
	spr(237,finish.x-15, 75,2,2)
	spr(224,pointer.x,pointer.y-3)
	spr(n, key.x+6, key.y-8)
	spr(current_frame,player.x, player.y,2,2)
	rectfill(cam.x+100,cam.y+98,cam.x+20,cam.y+98,6)
	rectfill(cam.x+50,cam.y+98,cam.x+70,cam.y+98,2)
	if win==true then
		spr(226,cam.x+20,cam.y+20,2,2)	
	end
end
