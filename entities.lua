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

kittens = {

}

grenades = {

}

enemies={
	--[[{
		move = 150,
		run = 200,
		old_x = 50,
		old_y = 1400,
		x = 50,
		y = 1400,
		width = 100,
		height = 100,
		detection=500,
		seek_noise= love.audio.newSource("audio/spooder.wav", "stream"),
		anim=love.graphics.newImage("anims/spooder1_quad.png"),
		anim_frame=0,
		max_frames=4,
		r=0.1, g=0.8, b=0.2
	},
	{
		move = 200,
		run = 250,
		old_x = 1800,
		old_y = 1400,
		x = 1800,
		y = 1400,
		width = 75,
		height = 100,
		detection=800,
		anim=love.graphics.newImage("anims/spooder2_quad.png"),
		anim_frame=0,
		max_frames=4,
		seek_noise= love.audio.newSource("audio/spooder2.wav", "stream"),
		r=0.1, g=0.2, b=0.6
	}
	--]]
}

function move_player(dt, bed)
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
	if currTime + dt >= timeCatSpawn and currCatSpawn < numCatSpawn then
		generate_new_kitten()
		currTime = 0
		currCatSpawn = currCatSpawn + 1
	end
	currTime = currTime + dt
end


function generate_new_kitten() 
	local width, height = love.graphics.getDimensions()
	table.insert(kittens, {
		move = 50,
		x = width,
		y = (height/2) -50,
		width = 100,
		height = 100,
		anim=love.graphics.newImage("images/kitten_160x90.png"),
		r=math.random(), g=math.random(), b=math.random()
	})
end

function remove_kitten(index)
	table.remove(kittens, index)
end

--[[function move_enemies(dt)
	for i,enemy in ipairs(enemies) do
		enemy.old_x = enemy.x
		enemy.old_y = enemy.y
		detected_player = check_detection(player, enemy)
		if detected_player then
			enemy.seek_noise:play()
			local angle = math.pi/2 + math.atan2(enemy.x-player.x, enemy.y-player.y)
			enemy.x = enemy.x + math.cos(angle)*enemy.run*dt
			enemy.y = enemy.y - math.sin(angle)*enemy.run*dt
		end
		for i,wall in ipairs(walls) do
			wall_collision = check_collision(enemy, wall)
			if wall_collision then resolve_collision(enemy, wall) end
		end
		player_dead = check_collision(enemy, player)
		if player_dead then dead = true end
	end
end--]]

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

end

function remove_grenade(index)

end

function check_collision(a, b)
	return a.x + a.width > b.x
	and a.x < b.x + b.width
    and a.y + a.height > b.y
    and a.y < b.y + b.height
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
--[[
function move_camera()
	love.graphics.translate(-math.floor(player.x / width) * width,-math.floor(player.y/height) * height)
end

function check_all_parts_found(bed)
	local count = 0
	for i, bed_part in ipairs(bed) do
		if bed_part.found then count = count + 1 end
	end
	if count == 4 then
		all_parts_found = true
	end
end

function check_win(bedroom_area)
	if check_collision(player, bedroom_area) then win = true end
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
