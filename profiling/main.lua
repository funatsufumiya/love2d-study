local profiler = require("profiler")

function love.load()
    profiler.start()
end

function love.draw()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local font = love.graphics.getFont()
    profiler.draw(w, h, font)
end

function love.keypressed(key)
    if key == 'escape' then
        profiler.stop()
        print("bye")
        love.event.quit()
    elseif key == 'a' then
        print('a')
    end
end