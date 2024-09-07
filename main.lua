math.randomseed(os.time())

function love.load()
	require "controls"
	require "main_menu"
	require "entities"
	require "levels/level0"
end

function love.update(dt)
	--update_animations(dt)
	if debug == true then debug() end
	move_player(dt)
	move_racket(dt)
	spawn_kittens(dt)
	spawn_dogs(dt)
	dog_ai(dt)
	move_kittens(dt)
	move_grenades(dt)
	clear_explosions(dt)
end

function love.draw()
	-- draw the level and scorebar
	love.graphics.draw(level["tip1"],math.floor(player.x/width)*width+20, math.floor(player.y/height)*height+20)
	if debug == true then love.graphics.draw(level["debug"],math.floor(player.x/width)*width+20, math.floor(player.y/height)*height+40) end
	love.graphics.setBackgroundColor(0.3, 0.3, 0.3)
	love.graphics.draw(level["canvas"], 0, 0)
	-- draw the player
	love.graphics.setColor(tonumber(player.r), tonumber(player.g), tonumber(player.b))
	love.graphics.rectangle("fill",player.x, player.y, player.width, player.height)
	-- draw the player's tennis racket
	love.graphics.draw(tennis_racket.anim, tennis_racket.x, tennis_racket.y)
	-- draw the racket radius around the player
	love.graphics.circle("line", player.x + (0.5 * player.width), player.y + (0.5 * player.height), player.diameter/2)
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
	for i, grenade in ipairs(grenades) do
		love.graphics.draw(grenade.anim, grenade.x, grenade.y)
	end
	for i, explosion in ipairs(explosions) do
		love.graphics.draw(explosion.anim, explosion.x, explosion.y)
	end
	love.graphics.setColor(1,1,1)
end