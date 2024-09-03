math.randomseed(os.time())

function love.load()
	require "controls"
	require "main_menu"
	require "entities"
	require "levels/level0"
end

function love.update(dt)
	--update_animations(dt)
	move_player(dt)
	spawn_kittens(dt)
	move_kittens(dt)
	move_grenades(dt)
	--TODO: handle removal of grenades and kittens
end

function love.draw()
	-- draw the level
	love.graphics.draw(level["tip1"],math.floor(player.x/width)*width+20, math.floor(player.y/height)*height+20)
	love.graphics.setBackgroundColor(0.3, 0.3, 0.3)
	love.graphics.draw(level["canvas"], 0, 0)
	-- draw the player
	love.graphics.setColor(tonumber(player.r), tonumber(player.g), tonumber(player.b))
	love.graphics.rectangle("fill",player.x, player.y, player.width, player.height)
	-- draw the kittens
	for i,kitten in ipairs(kittens) do
		love.graphics.setColor(tonumber(kitten.r), tonumber(kitten.g), tonumber(kitten.b))
		love.graphics.draw(kitten.anim, kitten.x, kitten.y)
	end
	for i, dog in ipairs(dogs) do
		love.graphics.setColor(tonumber(dog.r), tonumber(dog.g), tonumber(dog.b))
		love.graphics.draw(dog.anim, dog.x, dog.y)
	end
	love.graphics.setColor(1,1,1)
end