
--camera
cam = {x = 0, y = 0}

--timer
globalmaxtime = 5.0
phasetime = 0
frametimedecrease = 0.033333333333333

function update_phase_timer()
	phasetime += frametimedecrease
	if (phasetime >= globalmaxtime) then phasetime = globalmaxtime end
end

function draw_phase_timer()
	rectfill(cam.x, cam.y + 5, cam.x + 128, cam.y + 8, 1)
	rectfill(cam.x + 1, cam.y + 6, (phasetime / globalmaxtime) * (126-0), cam.y + 7, 11)
end
	