function build_room(left,up,right,down, param_canvas, room_origin_x, room_origin_y)
	local room_x, room_y = love.graphics.getDimensions()
	local wall_width = 10
	love.graphics.setCanvas(param_canvas)
	love.graphics.setColor(0.4, 0.0, 0.4)
	if (left) then
		table.insert(walls,{x=room_origin_x, y=room_origin_y, width=wall_width, height=room_y})
		love.graphics.rectangle("fill",room_origin_x, room_origin_y, wall_width, room_y)
	else
		table.insert(walls,{x=room_origin_x, y=room_origin_y, width=wall_width, height=room_y/3})
		table.insert(walls,{x=room_origin_x, y=(2*room_y/3)+room_origin_y, width=wall_width, height=room_y/3})
		love.graphics.rectangle("fill",room_origin_x,room_origin_y, wall_width, room_y/3)
		love.graphics.rectangle("fill",room_origin_x,(2*room_y/3)+room_origin_y, wall_width, room_y/3)
	end
	if (up) then
		table.insert(walls,{x=room_origin_x, y=room_origin_y, width=room_x, height=wall_width})
		love.graphics.rectangle("fill",room_origin_x, room_origin_y, room_x, wall_width)
	else
		table.insert(walls,{x=room_origin_x, y=room_origin_y, width=room_x/3, height=wall_width})
		table.insert(walls,{x=(2*room_x/3)+room_origin_x, y=room_origin_y, width=room_x/3, height=wall_width})
		love.graphics.rectangle("fill",room_origin_x,room_origin_y, room_x/3, wall_width)
		love.graphics.rectangle("fill",(2*room_x/3)+room_origin_x,room_origin_y, room_x/3, wall_width)
	end
	if (right) then
		table.insert(walls,{x=room_origin_x+room_x-wall_width, y=room_origin_y, width=wall_width, height=room_y})
		love.graphics.rectangle("fill",room_origin_x+room_x-wall_width, room_origin_y, wall_width, room_y)
	else
		table.insert(walls,{x=room_origin_x+room_x-wall_width, y=room_origin_y, width=wall_width, height=room_y/3})
		table.insert(walls,{x=room_origin_x+room_x-wall_width, y=(2*room_y/3)+room_origin_y, width=wall_width, height=room_y/3})
		love.graphics.rectangle("fill",room_origin_x+room_x-wall_width,room_origin_y, wall_width, room_y/3)
		love.graphics.rectangle("fill",room_origin_x+room_x-wall_width,(2*room_y/3)+room_origin_y, wall_width, room_y/3)
	end
	if (down) then
		table.insert(walls,{x=room_origin_x, y=room_origin_y+room_y-wall_width, width=room_x, height=wall_width})
		love.graphics.rectangle("fill",room_origin_x, room_origin_y+room_y-wall_width, room_x, wall_width)
	else
		table.insert(walls,{x=room_origin_x, y=room_origin_y-wall_width, width=room_x/3, height=wall_width})
		table.insert(walls,{x=(2*room_x/3)+room_origin_x, y=room_origin_y-wall_width, width=room_x/3, height=wall_width})
		love.graphics.rectangle("fill",room_origin_x,room_origin_y+room_y-wall_width, room_x/3, wall_width)
		love.graphics.rectangle("fill",(2*room_x/3)+room_origin_x,room_origin_y+room_y-wall_width, room_x/3, wall_width)
	end
	love.graphics.setCanvas()
end
