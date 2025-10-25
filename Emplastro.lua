
boards = {}
boardvelocity = 1
maxy = 100
miny = 70
emplastroac = 0.3 -- acceleration
reporterac = 0.4
reporterframetime = 0.1
emplastroprogress = 0
emplastroprogressspeed = 0.005

function make_board(k, x, y, w, h, dir, text)
	a={
		k = k,
		x = x,
		y = y,
		w = w,
		h = h,
		dir = dir,
		text = text
	}

	add(boards,a)
	return a
end

function drawboards()
	for board in all(boards) do
		rectfill(cam.x + board.x - 1, cam.y + board.y + board.h, cam.x + board.x + 1, cam.y + board.y + 128, 4)
		rectfill(cam.x + board.x - board.w, cam.y + board.y - board.h, cam.x + board.x + board.w, cam.y + board.y + board.h, 4)
		print(board.text, cam.x + board.x - board.w + 1, cam.y + board.y, 7)
	end
end

function init_emplastro()
	cam.x = 0
	cam.y = 128
	emplastrocharacter = { x = cam.x + 64,y = cam.y + 100, vx=0, vy=0, f = 1, d = 1}
	reportercharacter = { x = cam.x,y = cam.y + 80, vx=0, vy=0, f = 1, d = 1}
	
	make_board(0, 50, 50, 15, 7, 1, "caralho")
	--make_board(1, 70, 70, 20, 10, -1, "no bitches")
	make_board(2, 100, 50, 10, 5, 1, "😐⌂")
end

function update_emplastro()
	for board in all(boards) do
		if (board.y > maxy) then
			board.dir = -1
			end
		if (board.y < miny) then
			board.dir = 1
			end
		board.y += (boardvelocity * board.dir)
	end

	--emplastro-----
	if (btn(0)) then
		emplastrocharacter.vx-= emplastroac
		emplastrocharacter.d=-1
	end
	if (btn(1)) then
		emplastrocharacter.vx+= emplastroac
		emplastrocharacter.d=1
	end
	-- move (add velocity)
	emplastrocharacter.x+= emplastrocharacter.vx

	-- friction (lower for more)
	emplastrocharacter.vx *=.9
	
	if (emplastrocharacter.x < cam.x) then emplastrocharacter.x = cam.x end
	if (emplastrocharacter.x > cam.x + 112) then emplastrocharacter.x =  cam.x + 112  end
	
	--reporter
	if (reportercharacter.x + 8 > emplastrocharacter.x) then
		reportercharacter.vx += reporterac
	else 
		reportercharacter.vx -= reporterac
	end
	-- friction
	reportercharacter.vx *=.92
	reportercharacter.x -= reportercharacter.vx
	reportercharacter.f += reporterframetime
	if (reportercharacter.f >= 2) then reportercharacter.f = 0 end
	
	--points
	if (emplastrocharacter.x > reportercharacter.x + 16 or emplastrocharacter.x < reportercharacter.x - 16) then
		emplastroprogress += emplastroprogressspeed
	end
	if (emplastroprogress >= 1) then emplastroprogress = 1 WIN=true end
		
end

function draw_emplastro()
	cls(10)
	camera(cam.x, cam.y)
	map()
	drawboards()
	--change sprite as needed
	spr(128,
		emplastrocharacter.x, emplastrocharacter.y, -- x,y (pixels)
		2,2,
		emplastrocharacter.d==-1 
	)
	spr(130 + flr(reportercharacter.f) * 4,
		reportercharacter.x, reportercharacter.y,
		4,4,
		reportercharacter.d==-1
	)
	rectfill(cam.x + 25, cam.y + 13, cam.x + 100, cam.y + 14, 1)
	rectfill(cam.x + 25, cam.y + 13, cam.x + 25 + emplastroprogress * (100-25), cam.y + 14, 11)
	print("⬅️ and ➡️ to move", cam.x + 30, cam.y + 16, 1)
	print(emplastroprogress)
end