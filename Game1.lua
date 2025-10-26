#include mainlogic.lua
#include junglecheeta.lua
#include emplastro.lua

function _init()
	init_timer()
	init_cheeta()
end

function _update()
	button_press_check()
	update_phase_timer()
	update_cheeta()
end

function _draw()
	draw_cheeta()
	draw_tv()
	draw_phase_timer()
end