local love = love

local shapes = {}
local currentPoints = 8
-- local maxPoints = 4096
local maxPoints = 500000
local minPoints = 1
local centerX, centerY
local nMeshes = 1
local spacing = 300

local function makeShape(cx, cy, numPoints)
	local verts = {}
	local radiusBase = 80
	verts[#verts+1] = {cx, cy, 0, 0, 1, 1, 1, 1}
	for i=1,numPoints do
		local angle = (i-1)/numPoints * (math.pi*2)
		local r = radiusBase * (0.6 + math.random()*1.2)
		local x = cx + math.cos(angle) * r * (0.8 + (math.random()-0.5)*0.6)
		local y = cy + math.sin(angle) * r * (0.8 + (math.random()-0.5)*0.6)
		verts[#verts+1] = {x, y, 0, 0, 1, 1, 1, 1}
	end
	local mesh = love.graphics.newMesh(verts, "fan", "static")
	return {mesh = mesh, verts = verts, count = numPoints, cx = cx, cy = cy}
end

local function generate()
	centerX = love.graphics.getWidth()/2
	centerY = love.graphics.getHeight()/2
	shapes = {}
	local startX = centerX - spacing
	for i=1,nMeshes do
		local x = startX + (i-1) * spacing
		shapes[i] = makeShape(x, centerY, currentPoints)
	end
end

function love.load()
	math.randomseed(os.time())
	love.window.setTitle("newMesh test - use LEFT/RIGHT to change vertices")
	love.window.setMode(1024, 600)
	generate()
end

function love.draw()
	love.graphics.clear(0.12, 0.12, 0.14)
	love.graphics.setColor(1,1,1)
	love.graphics.print("LEFT/RIGHT: halve/double vertices   R: regenerate", 8, 8)

	for idx, s in ipairs(shapes) do
		love.graphics.setColor(0.2 + 0.15*idx, 0.5 + 0.15*idx, 0.7 - 0.1*idx, 0.9)
		love.graphics.draw(s.mesh)

		love.graphics.setColor(1,0.8,0.2)
		for i=2,#s.verts do
			local v = s.verts[i]
			love.graphics.circle("fill", v[1], v[2], 3)
		end

		love.graphics.setColor(1,1,1)
		love.graphics.print("mesh "..idx.."  n="..s.count, s.cx-36, s.cy-80)
	end
end

function love.keypressed(k)
	if k == 'right' then
		local nextN = math.min(maxPoints, math.max(minPoints, currentPoints * 2))
		if nextN ~= currentPoints then
			currentPoints = nextN
			generate()
		end
	elseif k == 'left' then
		local nextN = math.max(minPoints, math.floor(currentPoints / 2))
		if nextN ~= currentPoints then
			currentPoints = nextN
			generate()
		end
	elseif k == 'r' then
		generate()
	end
end

