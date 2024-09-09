require "levels/room_builder"
walls={}
local width, height = love.graphics.getDimensions()
level = {}
-- Cat Spawn Logic
currCatSpawn = 0
numCatSpawn = 15
currTimeCatSpawn = 0
timeCatSpawn = 5 -- seconds
-- Dog Spawn Logic
currDogSpawn = 0
maxDogsOnScreen = 2
currDogsOnScreen = 0
numDogSpawn = 9
currTimeDogSpawn = 0
timeDogSpawn = 7
score = 0
debug = false
level["canvas"] = love.graphics.newCanvas(width, height)

-- hand gen for levels right now
level["room"] = {left=true, up=true, right=true, down=true, origin_x=0, origin_y=0}

build_room(level['room'].left, level['room'].up, level['room'].right, level['room'].down, level["canvas"], level['room'].origin_x, level['room'].origin_y, walls)

for i, wall in ipairs(walls) do
	wall.old_x = wall.x
	wall.old_y = wall.y
end

-- Font Setup
level_font = love.graphics.newFont(24)
level["tip1_text"] = "Score: " .. score
level["tip1_width"] = level_font:getWidth(level["tip1_text"])
level["tip1"] = love.graphics.newText(level_font, level["tip1_text"])
level["debug_racket"] = "X: " .. tennis_racket.x .. ", Y: ".. tennis_racket.y .. ", distance: ".. getDistance(tennis_racket.x, player.x , tennis_racket.y, player.y)
level["debug"] = love.graphics.newText(level_font, level["debug_racket"])

function update_score()
	level["tip1_text"] = "Score: " .. score
	level["tip1"] = love.graphics.newText(level_font, level["tip1_text"])
end

function debug()
	level["debug_racket"] = "X: " .. tennis_racket.x .. ", Y: ".. tennis_racket.y .. ", distance: ".. getDistance(tennis_racket.x, player.x , tennis_racket.y, player.y)
	level["debug"] = love.graphics.newText(level_font, level["debug_racket"])
end

