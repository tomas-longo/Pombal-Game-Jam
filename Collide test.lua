-- wander demo
-- by zep

x=24 y=24 -- position (in tiles)
dx=0 dy=0 -- velocity
f=0       -- frame number
d=1       -- direction (-1, 1)

function _draw()
	cls(1)

	-- move camera to current room
	room_x = flr(x/16)
	room_y = flr(y/16)
	camera(room_x*128,room_y*128)

	-- draw the whole map (128⁙32)
	map()

	-- draw the player
	spr(1+f,      -- frame index
		x*8-4,y*8-4, -- x,y (pixels)
		1,1,d==-1    -- w,h, flip
	)
end

function _update()

	ac=0.1 -- acceleration

	if (btn(⬅️)) dx-= ac d=-1
	if (btn(➡️)) dx+= ac d= 1
	if (btn(⬆️)) dy-= ac
	if (btn(⬇️)) dy+= ac

	-- move (add velocity)
	x+=dx y+=dy

	-- friction (lower for more)
	dx *=.7
	dy *=.7

	-- advance animation according
	-- to speed (or reset when
	-- standing almost still)
	spd=sqrt(dx*dx+dy*dy)
	f= (f+spd*2) % 4 -- 4 frames
	if (spd < 0.05) f=0

	-- collect apple
	if (mget(x,y)==10) then
		mset(x,y,14)
		sfx(0)
	end

	end
