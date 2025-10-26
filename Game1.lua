#include mainlogic.lua
#include junglecheeta.lua
#include emplastro.lua
#include indypuzzle.lua
#include corrida.lua

function _init()
	init_timer()
	init_corrida()
	init_emplastro()
	init_cheeta()
	init_indy()
end

function _update()
	button_press_check()

	if current_channel_index == 0 then
		update_indy()
	elseif current_channel_index == 1 then
		update_cheeta()
	elseif current_channel_index == 2 then
		update_emplastro()
	elseif current_channel_index == 3 then
		update_corrida()
	end

	update_phase_timer()
end

function _draw()
	if current_channel_index == 0 then
		draw_indy()
	elseif current_channel_index == 1 then
		draw_cheeta()
	elseif current_channel_index == 2 then
		draw_emplastro()
	elseif current_channel_index == 3 then
		draw_corrida()
	end

	draw_tv()
	draw_phase_timer()
	draw_end_screen()
end
