score = {azul = 0, vermelho = 0}

function love.load()
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, false)
	math.randomseed(os.time())

	love.mouse.setVisible(false)

	objects = {}

	objects.lat_1 = {}
	objects.lat_1.body = love.physics.newBody(world, 799, 320)
	objects.lat_1.shape = love.physics.newRectangleShape(1, 640)
	objects.lat_1.fixture = love.physics.newFixture(objects.lat_1.body, objects.lat_1.shape)
	objects.lat_1.fixture:setRestitution(1)

	objects.lat_2 = {}
	objects.lat_2.body = love.physics.newBody(world, 1, 320)
	objects.lat_2.shape = love.physics.newRectangleShape(1, 640)
	objects.lat_2.fixture = love.physics.newFixture(objects.lat_2.body, objects.lat_2.shape)
	objects.lat_2.fixture:setRestitution(1)

	objects.ground_2 = {}
	objects.ground_2.body = love.physics.newBody(world, 800 / 2, -25)
	objects.ground_2.shape = love.physics.newCircleShape(100)
	objects.ground_2.fixture = love.physics.newFixture(objects.ground_2.body, objects.ground_2.shape)
	objects.ground_2.fixture:setRestitution(1)

	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, 800 / 2, 625)
	objects.ground.shape = love.physics.newCircleShape(100)
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
	objects.ground.fixture:setRestitution(1)

	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, 400, 320, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(20)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
	objects.ball.fixture:setRestitution(0.9)

	objects.ground_2.body:setX(objects.ground_2.body:getX() + 25)

	if math.random(0, 1) == 0 then
		objects.ball.body:setLinearVelocity(math.random(100, 200), math.random(100, 200))
	else
		objects.ball.body:setLinearVelocity(math.random(-200, -100), math.random(-200, -100))
	end
end

function love.update(dt)
	world:update(dt)
	
	if objects.ground.body:getX() >= 750 then
		objects.ground.body:setX(750)
	end
	if objects.ground.body:getX() <= 50 then
		objects.ground.body:setX(50)
	end

	if objects.ground_2.body:getX() >= 750 then
		objects.ground_2.body:setX(750)
	end
	if objects.ground_2.body:getX() <= 50 then
		objects.ground_2.body:setX(50)
	end

	if love.keyboard.isDown("right") then
		objects.ground_2.body:setX(objects.ground_2.body:getX() + 640 * dt)
	elseif love.keyboard.isDown("left") then
		objects.ground_2.body:setX(objects.ground_2.body:getX() - 640 * dt)
	end

	if love.keyboard.isDown("d") then
		objects.ground.body:setX(objects.ground.body:getX() + 640 * dt)
	elseif love.keyboard.isDown("a") then
		objects.ground.body:setX(objects.ground.body:getX() - 640 * dt)
	end

	if objects.ball.body:getY() < 0 then
		score.azul = score.azul + 1
		love.load()
	end
	if objects.ball.body:getY() > 640 then
		score.vermelho = score.vermelho + 1
		love.load()
	end

	ballX, ballY = objects.ball.body:getLinearVelocity()

	if ballX < 0 then
		ballX = ballX - 1
	elseif ballX > 0 then
		ballX = ballX + 1
	end

	if ballY < 0 then
		ballY = ballY - 1
	elseif ballY > 0 then
		ballY = ballY + 1
	end

	-- if score_vermelho == 5 or score_azul == 5 then
	-- 	love.event.quit()
	-- 	print("Ganhou o Player Azul!")
	-- end

	objects.ball.body:setLinearVelocity(ballX, ballY)
end

function love.draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", 798, 0, 2, 640)
	love.graphics.rectangle("fill", 1, 0, 2, 640)
	
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("fill", 0, 0, 800, 2)
	love.graphics.rectangle("fill", 0, 598, 800, 2)

	love.graphics.setColor(12, 45, 87)
	love.graphics.circle("fill", objects.ground.body:getX(), objects.ground.body:getY(), objects.ground.shape:getRadius())

	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", objects.ground_2.body:getX(), objects.ground_2.body:getY(),  objects.ground_2.shape:getRadius())

	--love.graphics.setColor(255, 255, 255)
	love.graphics.setColor(math.random(0,255), math.random(0, 255), math.random(0, 255))
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

	love.graphics.setColor(255, 0, 0)
	love.graphics.print("Score: " .. score.vermelho, 720, 10)

	love.graphics.setColor(0, 0, 255)
	love.graphics.print("Score: " .. score.azul, 720, 570)

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Key A <-- and --> Key D", 10, 10)
	love.graphics.print("Left <-- and --> Right", 10, 570)

	if score.azul == 5 then
		love.graphics.setColor(0, 0, 255)
		love.graphics.print("Ganhou o Player Azul! Carrega P para jogar novamente!", 200, 300)
		if love.keyboard.isDown("p") then
			score.vermelho = 0
			score.azul = 0
			love.load()
		end
	end

	if score.vermelho == 5 then
		love.graphics.setColor(255, 0, 0)
		love.graphics.print("Ganhou o Player Vermelho! Carrega P para jogar novamente!", 200, 300)
		if love.keyboard.isDown("p") then
			score.vermelho = 0
			score.azul = 0
			love.load()
		end
	end
end