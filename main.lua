function love.load()
	love.window.setMode(900,700)

	myWorld = love.physics.newWorld(0, 500, false) -- normal gravity
	myWorld: setCallbacks(beginContact, endContact, preSolve, postSolve)

	sprites = {}
	sprites.coin_sheet = love.graphics.newImage('sprites/coin_sheet.png')
	sprites.player_jump = love.graphics.newImage('sprites/player_jump.png')
	sprites.player_stand = love.graphics.newImage('sprites/player_stand.png')

	require('player')
	require('coin')
	anim8 = require('anim8-master/anim8')
	sti = require("Simple-Tiled-Implementation-master/sti")

	platforms = {}
	spawnPlatform(50, 400, 300, 30)
	spawnCoin(200, 100)

	gameMap = sti("gameMap.lua")

	for i, obj in pairs(gameMap.layers["Platforms"].objects) do
		spawnPlatform(obj.x, obj.y, obj.width, obj.height)
	end

	for i, obj in pairs(gameMap.layers["Coins"].objects) do
		spawnCoin(obj.x, obj.y, obj.width, obj.height)
	end
end
--[[

]]
function love.update(dt)
	myWorld: update(dt)
	playerUpdate(dt)
	gameMap: update(dt)
	coinUpdate(dt)

	for i, c in ipairs(coins) do
		c.animation: update(dt)
	end
end
--[[

]]
function love.draw()
	gameMap: drawLayer(gameMap.layers["Tile Layer 1"])

	love.graphics.draw(player.sprite, player.body: getX(), player.body: getY(), nil, player.direction, 1, sprites.player_stand:getWidth()/2, sprites.player_stand:getHeight()/2)
--[[
	for i, p in ipairs(platforms) do
		love.graphics.rectangle("fill", p.body:getX(), p.body:getY(), p.width, p.height)
	end
]]

	for i, c in ipairs(coins) do
		c.animation: draw(sprites.coin_sheet, c.x, c.y, nil, nil, nil, 20.5, 21)
	end

end

function love.keypressed(key, scancode, isrepeat)
	if key == "w" and player.grounded == true then
		player.body: applyLinearImpulse(0, -2000)
	end
end

function spawnPlatform(x, y, width, height)
	
	local platform = {}
	
	platform.body = love.physics.newBody(myWorld, x, y, "static")
	platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
	platform.fixture = love.physics.newFixture(platform.body, platform.shape)
	platform.width = width
	platform.height = height 

	table.insert(platforms, platform)
end

function beginContact(a, b, coll) -- @param: a + b = kontakt
	player.grounded = true
end

function endContact(a, b, coll)
	player.grounded = false
end

function distanceBetween(x1, y1, x2, y2)
	return math.sqrt((y2-y1)^2 + (x2-x1)^2)
end


