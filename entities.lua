require "controls"

player={
	move = 100,
	run = 200,
	old_x = 10,
	old_y = 40,
	x = 10,
	y = 40,
	width = 25,
	height = 25,
	--collect= love.audio.newSource("audio/collect.wav", "stream"),
	r=1,
	g=1,
	b=0
}

kittens = {}
grenades = {}
dogs = {}
explosions = {}

function move_player(dt)
	player.old_x = player.x
	player.old_y = player.y
	if love.keyboard.isDown(left) then
		if (love.keyboard.isDown(shift)) then
			player.x = player.x - player.run * dt
		else
			player.x = player.x - player.move * dt
		end
	end
	if love.keyboard.isDown(right) then
		if (love.keyboard.isDown(shift)) then
			player.x = player.x + player.run * dt
		else
			player.x = player.x + player.move * dt
		end
	end
	if love.keyboard.isDown(up) then
		if (love.keyboard.isDown(shift)) then
			player.y = player.y - player.run * dt
		else
			player.y = player.y - player.move * dt
		end
	end
	if love.keyboard.isDown(down) then
		if (love.keyboard.isDown(shift)) then
			player.y = player.y + player.run * dt
		else
			player.y = player.y + player.move * dt
		end
	end
	for i,wall in ipairs(walls) do
		wall_collision = check_collision(player, wall)
		if wall_collision then resolve_collision(player, wall) end
	end
end

function spawn_kittens(dt)
	if currTimeCatSpawn + dt >= timeCatSpawn and currCatSpawn < numCatSpawn then
		generate_new_kitten()
		currTimeCatSpawn = 0
		currCatSpawn = currCatSpawn + 1
	end
	currTimeCatSpawn = currTimeCatSpawn + dt
end

function spawn_dogs(dt)
	if currTimeDogSpawn + dt >= timeDogSpawn and currDogsOnScreen < maxDogsOnScreen and currDogSpawn < numDogSpawn then
		generate_new_dog()
		currTimeDogSpawn = 0
		currDogSpawn = currDogSpawn + 1
		currDogsOnScreen = currDogsOnScreen + 1
	end
	currTimeDogSpawn = currTimeDogSpawn + dt
end

function dog_ai(dt)
	for i, dog in ipairs(dogs) do
		dog.timeTillThrow = dog.timeTillThrow - dt
		if dog.timeTillThrow <= 0 then
			if dog.numThrown < dog.maxThrows then
				local nearest_cat = get_nearest_cat(dog.x, dog.y)
				if nearest_cat ~= nil then
					local cat = kittens[nearest_cat]
					local angle = math.pi/2 + math.atan2(dog.x-cat.x +math.random(-5, 5), dog.y-cat.y +math.random(-5, 5))
					generate_new_grenade(dog.x, dog.y, angle, math.random(40, 60))
					dog.timeTillThrow = 6
					dog.numThrown = dog.numThrown + 1
				end
			else 
				remove_dog(i)
				currDogsOnScreen = currDogsOnScreen - 1
			end
		end
	end
end

function generate_new_kitten() 
	local width, height = love.graphics.getDimensions()
	local size = (0.05 * width)
	table.insert(kittens, {
		move = 50,
		x = width,
		y = (height/2) -50,
		width = size,
		height = size,
		anim=love.graphics.newImage("images/cats/kitten1.png"),
		r=math.random(), g=math.random(), b=math.random()
	})
end

function generate_new_dog() 
	local width, height = love.graphics.getDimensions()
	local size = (0.05 * width)
	local spawnX, spawnY = generate_dog_spawn(size)
	table.insert(dogs, {
		x = spawnX,
		y = spawnY,
		timeTillThrow = 6,
		numThrown = 0,
		maxThrows = math.random(1,3),
		blastRadius = 400,
		width = size,
		height = size,
		anim=love.graphics.newImage("images/dogs/dog"..math.random(5)..".png"),
		r=math.random(), g=math.random(), b=math.random()
	})
end

function generate_dog_spawn(dogSize)
	local width, height = love.graphics.getDimensions()
	local leftDisplacement = (0.15 * width)
	local rightDisplacement = (0.85 * width)
	local topDisplacement = (0.1 * height)
	local bottomDisplacement = (0.9 * height)
	local x = math.random(leftDisplacement+ dogSize, rightDisplacement+dogSize)
	local y = 0
	local hemisphere = math.random(2)
	if hemisphere == 1 then
		y = math.random(topDisplacement+dogSize, (height/2) - (0.2 * height))
	else
		y = math.random((height/2) + (0.2 * height), bottomDisplacement-dogSize)
	end
	return x, y
end

function remove_kitten(index)
	table.remove(kittens, index)
end

function remove_dog(index)
	table.remove(dogs, index)
	currDogsOnscreen = currDogsOnScreen - 1
end

function generate_new_grenade(spawnX, spawnY, angle, spawnAccel)
	local width, height = love.graphics.getDimensions()
	local size = 80
	table.insert(grenades, {
		timer = 3,
		speed = 0,
		acceleration = spawnAccel,
		old_x = spawnX,
		old_y = spawnY,
		x = spawnX,
		y = spawnY,
		direction = angle,
		width = size,
		height = size,
		anim=love.graphics.newImage("images/props/grenade.png")
	})
end

function generate_new_explosion(spawnX, spawnY)
	table.insert(explosions, {
		timer = 1,
		x = spawnX,
		y = spawnY,
		anim = love.graphics.newImage("images/props/explosion.png")
	})
end

function remove_grenade(index)
	table.remove(grenades, index)
end

function remove_explosion(index)
	table.remove(explosions, index)
end

function move_kittens(dt)
	for i, kitten in ipairs(kittens) do
		kitten.x = kitten.x - (dt* kitten.move)
		if kitten.x <= 0 - kitten.width then
			remove_kitten(i)
			score = score + 1
			update_score()
		end
	end
end

function move_grenades(dt)
	for i, grenade in ipairs(grenades) do
		grenade.old_x = grenade.x
		grenade.old_y = grenade.y
		grenade.x = grenade.x + math.cos(grenade.direction)*grenade.speed*dt
		grenade.y = grenade.y - math.sin(grenade.direction)*grenade.speed*dt
		grenade.speed = grenade.speed + grenade.acceleration
		grenade.acceleration = grenade.acceleration - (100*dt)
		for i,wall in ipairs(walls) do
			wall_collision = check_collision(grenade, wall)
			if wall_collision then resolve_elastic_collision(grenade, wall) end
		end
		grenade.timer = grenade.timer - dt
		if grenade.timer <= 0 then
			generate_new_explosion(grenade.x, grenade.y)
			remove_grenade(i)
			-- TODO: handle cat deaths and dog deaths/player death here
		end
		if grenade.speed < 0 then
			grenade.speed = 0
			grenade.acceleration = 0
		end
	end
end

function get_nearest_cat(dogX, dogY)
	local distance = nil
	local currDistance = 0
	local catIndex = nil
	for i, kitten in ipairs(kittens) do
		currDistance = math.sqrt( ((dogX - kitten.x) ^ 2) + ((dogY - kitten.y) ^ 2))
		if distance == nil or currDistance < distance then 
			distance = currDistance
			catIndex = i
		end
	end
	return catIndex
end

function check_collision(a, b)
	return a.x + a.width > b.x
	and a.x < b.x + b.width
    and a.y + a.height > b.y
    and a.y < b.y + b.height
end

function clear_explosions(dt)
	for i, explosion in ipairs(explosions) do
		explosion.timer = explosion.timer - dt
		if explosion.timer <= 0 then
			remove_explosion(i)
		end
	end
end

function resolve_collision(a, b)
	if a.old_y < b.old_y + b.height and a.old_y + a.height > b.old_y then
		if a.x + a.width/2 < b.x + a.width/2  then
            -- pushback = the right side of the player - the left side of the wall
            local pushback = a.x + a.width - b.x
            a.x = a.x - pushback
        else
            -- pushback = the right side of the wall - the left side of the player
            local pushback = b.x + b.width - a.x
            a.x = a.x + pushback
        end
	elseif a.old_x < b.old_x + b.width and a.old_x + a.width > b.old_x then
		if a.y + a.height/2 < b.y + a.height/2 then
            -- pushback = the bottom side of the player - the top side of the wall
            local pushback = a.y + a.height - b.y
            a.y = a.y - pushback
        else
            -- pushback = the bottom side of the wall - the top side of the player
            local pushback = b.y + b.height - a.y
            a.y = a.y + pushback
        end
	end
end

function resolve_elastic_collision(a, b)
	if a.old_y < b.old_y + b.height and a.old_y + a.height > b.old_y then
		if a.x + a.width/2 < b.x + a.width/2  then
            -- pushback = the right side of the player - the left side of the wall
            local pushback = a.x + a.width - b.x
            a.x = a.x - pushback
        else
            -- pushback = the right side of the wall - the left side of the player
            local pushback = b.x + b.width - a.x
            a.x = a.x + pushback
        end
		a.direction = -1 * a.direction
	elseif a.old_x < b.old_x + b.width and a.old_x + a.width > b.old_x then
		if a.y + a.height/2 < b.y + a.height/2 then
            -- pushback = the bottom side of the player - the top side of the wall
            local pushback = a.y + a.height - b.y
            a.y = a.y - pushback
        else
            -- pushback = the bottom side of the wall - the top side of the player
            local pushback = b.y + b.height - a.y
            a.y = a.y + pushback
        end
		a.direction = -1 * a.direction
	end
end

function update_animations(dt)
	for i,enemy in ipairs(enemies) do
		enemy.anim_frame = enemy.anim_frame+10*dt
		if enemy.anim_frame >= enemy.max_frames-1 then enemy.anim_frame = 0 end
	end
	--player.anim_frame = player.anim_frame+10*dt
	--if player.anim_frame >= player.max_frames then player.anim_frame = 1 end
end
--]]
