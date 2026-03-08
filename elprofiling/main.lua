local Profiler = require("ELProfiler")

function love.load()
    Profiler.setClock(love.timer.getTime)
    Profiler.start()
end

function love.draw()
    love.graphics.rectangle("fill", 0, 0, 100, 100)
end

function love.quit()
    print(Profiler.format(Profiler.stop()))
end
