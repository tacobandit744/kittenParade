width, height = love.graphics.getDimensions()
main_menu_screen = love.graphics.newCanvas(width, height)
main_menu_buttons = {"Press \"P\" to start, resume, pause", "Press \"Q\" to quit", "wasd to move, shift to sprint", "Find the 4 bed pieces and reach the bedroom before you get eaten!", "Made by Milk, bedbug by Nick"}
win_buttons = {"I haven't programmed"}
buffer_space = 100;
game_name = 'BED BUG!'
win_screen = 'Hey, you won!'
death_screen = 'You got munched by a spooder :('
--[[menu_bedbug = love.graphics.newImage("images/bedbug.png")
rotation = 0
death_sound = love.audio.newSource("audio/bite.wav", "stream")
win_sound = love.audio.newSource("audio/win.wav", "stream")
background_sounds= {
	love.audio.newSource("audio/ambient1.wav", "stream"),
	love.audio.newSource("audio/ambient2.wav", "stream"),
	love.audio.newSource("audio/ambient3.wav", "stream"),
	love.audio.newSource("audio/ambient4.wav", "stream")
}
current_background_sound = 0


love.graphics.setCanvas(main_menu_screen)
love.graphics.setBackgroundColor(0, 0, 0)
love.graphics.clear()

-- Font Setup
title_font = love.graphics.newFont(48)
title_font_width = title_font:getWidth(game_name)
menu_font = love.graphics.newFont(24)
menu_font_height = menu_font:getHeight()

-- Title
love.graphics.setColor(1,1,1)
title = love.graphics.newText(title_font, game_name)
love.graphics.draw(title, width/2-title_font_width/2, height/8)

-- Menu Buttons
for i,v in ipairs(main_menu_buttons) do
	local menu_font_width = menu_font:getWidth(v)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", width/2-menu_font_width/2-10 , height/4-10 + i*buffer_space, menu_font_width+20, menu_font_height+20)
	love.graphics.setColor(0.5,0.5,1)
	local menu_text = love.graphics.newText(menu_font, v)
	love.graphics.draw(menu_text, width/2-menu_font_width/2, height/4 + i*buffer_space)
end
love.graphics.setCanvas()

function show_menu()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(main_menu_screen,0,0)
	-- Two spinny bois
	love.graphics.draw(menu_bedbug, width/6, height/3, rotation, 0.25, 0.25, 320, 320)
	love.graphics.draw(menu_bedbug, width/6*5, height/3, rotation, 0.25, 0.25, 320, 320)
end

function show_win_menu()
	love.graphics.setBackgroundColor(0,0,0)
	win_menu = love.graphics.newCanvas(width, height)
	love.graphics.clear()
	love.graphics.setColor(1,1,1)
	title_font_width = title_font:getWidth(win_screen)
	title = love.graphics.newText(title_font, win_screen)
	love.graphics.draw(title, width/2-title_font_width/2, height/8)
	if audio_killed == false then
		love.audio.stop()
		win_sound:play()
		audio_killed = true
	end
	local menu_font_width = menu_font:getWidth("Press \"Q\" to quit!")
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", width/2-menu_font_width/2-10 , height/4-10 + buffer_space, menu_font_width+20, menu_font_height+20)
	love.graphics.setColor(0.5,0.5,1)
	local menu_text = love.graphics.newText(menu_font, "Press\"Q\" to quit!")
	love.graphics.draw(menu_text, width/2-menu_font_width/2, height/4 + buffer_space)
	-- Two spinny bois
	love.graphics.draw(menu_bedbug, width/6, height/3, rotation, 0.25, 0.25, 320, 320)
	love.graphics.draw(menu_bedbug, width/6*5, height/3, rotation, 0.25, 0.25, 320, 320)
end

function show_death_menu()
	love.graphics.setBackgroundColor(0,0,0)
	death_menu = love.graphics.newCanvas(width, height)
	love.graphics.clear()
	love.graphics.setColor(1,1,1)
	title_font_width = title_font:getWidth(death_screen)
	title = love.graphics.newText(title_font, death_screen)
	love.graphics.draw(title, width/2-title_font_width/2, height/8)
	if audio_killed == false then
		love.audio.stop()
		death_sound:play()
		audio_killed = true
	end
	local menu_font_width = menu_font:getWidth("Press \"Q\" to quit!")
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", width/2-menu_font_width/2-10 , height/4-10 + buffer_space, menu_font_width+20, menu_font_height+20)
	love.graphics.setColor(0.5,0.5,1)
	local menu_text = love.graphics.newText(menu_font, "Press\"Q\" to quit!")
	love.graphics.draw(menu_text, width/2-menu_font_width/2, height/4 + buffer_space)
	-- Two spinny bois
	love.graphics.draw(menu_bedbug, width/6, height/3, rotation, 0.25, 0.25, 320, 320)
	love.graphics.draw(menu_bedbug, width/6*5, height/3, rotation, 0.25, 0.25, 320, 320)
end

function background_music()
	local index = (current_background_sound % #background_sounds)+1
	if background_sounds[index]:isPlaying() == false and not win then
		current_background_sound = current_background_sound + 1
		background_sounds[index]:play()
	end
end
]]--