#include main_logic.lua
#include emplastro.lua
#include cheeta.lua
#include indy.lua
#include runner.lua

function _init()
	init_main_logic()
	init_emplastro()
	init_cheeta()
	init_indy()
	init_runner()
end

function _update()
	if update_start_screen() then
		return
	end

	if update_end_screen() then
		return
	end

	button_press_check()

	if current_channel_index == 0 then
		update_emplastro()
	elseif current_channel_index == 1 then
		update_cheeta()
	elseif current_channel_index == 2 then
		update_indy()
	elseif current_channel_index == 3 then
		update_runner()
	end

	update_phase_timer()
end

function _draw()
	if draw_start_screen() then
		return
	end

	if draw_end_screen() then
		return
	end

	if current_channel_index == 0 then
		draw_emplastro()
	elseif current_channel_index == 1 then
		draw_cheeta()
	elseif current_channel_index == 2 then
		draw_indy()
	elseif current_channel_index == 3 then
		draw_runner()
	end

	draw_static()
	draw_tv()
	draw_phase_timer()
end