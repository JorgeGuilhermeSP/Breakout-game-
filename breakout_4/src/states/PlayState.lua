PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paddle = Paddle()

    self.ball = Ball(1)

    self.ball.dx = math.random(-200,200)
    self.ball.dy = math.random(-50,-60)

    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42

    self.bricks = LevelMaker.createMap()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
        elseif love.keyboard.wasPressed('space') then
            self.paused = true
            gSounds['pause']:play()
            return
        end

        self.paddle:update(dt)
        self.ball:update(dt)

-- sistema de colisão da bola com travessão

if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - 8
    self.ball.dy = - self.ball.dy

    -- colisão lado esquerdo enquanto se move para esquerda
    if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
        self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

    -- se colidir com o lado direito se movento para direita
    elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
        self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
    end
            gSounds['paddle-hit']:play()
    end    

    -- detectar colisão para todos os bricks
    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()

    -- lado esquerdo, apenas checa se está movendo pela direita
    if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
    -- flip velocidade de x
    self.ball.dx = -self.ball.dx
    self.ball.x = brick.x - 8

    -- lado direito, apenas checa se está movendo pela esquerda
    elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
    -- flip velocidade de x
    self.ball.dx = -self.ball.dx
    self.ball.x = brick.x + 32

    -- top edge se não houver colisão com x
    elseif self.ball.y < brick.y then
    -- flip velocidade y
    self.ball.dy = -self.ball.dy
    self.ball.y = brick.y - 8

    -- bottom edge se não houver colisão com x
    else
        -- flip velocidade y
        self.ball.dy = -self.ball.dy
    self.ball.y = brick.y + 16
    end

    -- aumenta velocidade de y
    self.ball.dy = self.ball.dy * 1.02

            break
        end
    end

    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end
end

function PlayState:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    self.paddle:render()
    self.ball:render()
    
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end