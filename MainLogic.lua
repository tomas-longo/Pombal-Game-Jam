
--camera
cam = {x = 0, y = 0}

--timer
global_max_time = 5.0
phase_time = 0
frame_time_decrease = 0.033333333333333
time_left = global_max_time
-- base delay (in seconds) between sound plays
base_delay = .3
-- how fast it can go at the end
min_delay = 0.02
-- track when to play next
next_beep = 0

function init_timer()
	next_beep = time()
end
function update_phase_timer()
	phase_time += frame_time_decrease
	if (phase_time >= global_max_time) then phase_time = global_max_time end

	-- update timer
	local t = time()
	time_left = max(0, global_max_time - t)
	
	local progress = 1 - (time_left / global_max_time)

	-- interpolate delay so beeps speed up toward end
	local delay = base_delay - (base_delay - min_delay) * progress

	if t >= next_beep then
	-- play your sound effect (change to your SFX index)
		sfx(0)
		next_beep = t + delay
	end
end

function draw_phase_timer()
	rectfill(cam.x + 13, cam.y + 3, cam.x + 115, cam.y + 7, 1)
	rectfill(cam.x + 14, cam.y + 4, cam.x + 14 + (phase_time / global_max_time) * 100, cam.y + 6, 7)
end
	
function draw_tv()
	--corners
	spr(128, cam.x, cam.y, 2,2)
	spr(202, cam.x, cam.y + 112, 2,2)
	spr(204, cam.x + 112, cam.y + 112 ,2,2)
	spr(200, cam.x + 112, cam.y, 2 ,2)

	--borders
	for i = 0, 11  do
		spr(228, cam.x, cam.y + 16 + i * 8, 2,1)
		spr(198, cam.x + 16 + i * 8, cam.y, 1,2)
		spr(232, cam.x + 112, cam.y + 16 + i * 8, 2,1)
		spr(230, cam.x + 16 + i * 8, cam.y + 112, 1, 2)
	end

	spr(234, cam.x + 72, cam.y + 112, 2,2)
	spr(234, cam.x + 88, cam.y + 112, 2,2)
end