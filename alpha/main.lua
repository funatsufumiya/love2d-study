function love.load()
	baseX = 300
	baseY = 400
	radius = 100
	offsetY = radius*.5*math.sqrt(3)
	love.graphics.setBackgroundColor(1, 1, 1)
end

function love.draw()
	love.graphics.setColor(1, 0, 0, 0.4)
	love.graphics.circle('fill', baseX, baseY, radius)
	love.graphics.setColor(0, 1, 0, 0.4)
	love.graphics.circle('fill', baseX + radius / 2, baseY - offsetY, radius)
	love.graphics.setColor(0, 0, 1, 0.4)
	love.graphics.circle('fill', baseX + radius, baseY, radius)
end