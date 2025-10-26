#include mainlogic.lua
#include junglecheeta.lua
#include emplastro.lua

function _init()
	init_timer()
	init_emplastro()
end

function _update()
	update_phase_timer()
	update_emplastro()
end

function _draw()
	draw_emplastro()
	draw_tv()
	draw_phase_timer()
end