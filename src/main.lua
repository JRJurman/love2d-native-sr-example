require('sral')

local quadrants = {
	{name = "Top-Left",     count = 0, color = {0.8, 0.3, 0.3}},
	{name = "Top-Right",    count = 0, color = {0.3, 0.8, 0.3}},
	{name = "Bottom-Left",  count = 0, color = {0.3, 0.3, 0.8}},
	{name = "Bottom-Right", count = 0, color = {0.8, 0.8, 0.3}},
}

local hoveringQuadrant = nil
local mouseX = 0
local mouseY = 0
local isPressed = false

local function getQuadrant(x, y)
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	local col = x < w / 2 and 1 or 2
	local row = y < h / 2 and 0 or 2
	return row + col
end

function love.load()
	love.window.setTitle('A11y Sample')
	speak("4 colored quadrants. Hover over a section to hear its name. Click to increase its count.")
end

function love.draw()
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	local halfW = w / 2
	local halfH = h / 2
	local positions = {
		{0, 0},
		{halfW, 0},
		{0, halfH},
		{halfW, halfH},
	}

	for i, quad in ipairs(quadrants) do
		local px, py = positions[i][1], positions[i][2]

		if hoveringQuadrant == i then
			love.graphics.setColor(quad.color[1] * 1.3, quad.color[2] * 1.3, quad.color[3] * 1.3)
		else
			love.graphics.setColor(quad.color[1], quad.color[2], quad.color[3])
		end
		love.graphics.rectangle("fill", px, py, halfW, halfH)

		love.graphics.setColor(0, 0, 0)
		love.graphics.printf(quad.name .. "\n" .. quad.count, px, py + halfH / 2 - 20, halfW, "center")
	end

	if isPressed then
		love.graphics.setColor(1, 0, 0)
	else
		love.graphics.setColor(0, 0, 0)
	end
	love.graphics.circle('line', mouseX, mouseY, 10)
end

local function updateHover(x, y)
	mouseX = x
	mouseY = y
	local q = getQuadrant(x, y)
	if q ~= hoveringQuadrant then
		hoveringQuadrant = q
		speak("Hovering over " .. quadrants[q].name .. ", count is " .. quadrants[q].count)
	end
end

local function incrementCurrent()
	if hoveringQuadrant then
		local quad = quadrants[hoveringQuadrant]
		quad.count = quad.count + 1
		speak(quad.name .. " count is now " .. quad.count)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if presses > 1 or istouch or hoveringQuadrant then
		incrementCurrent()
	end
	isPressed = true
end

function love.mousereleased()
	isPressed = false
end

function love.mousemoved(x, y)
	updateHover(x, y)
end
