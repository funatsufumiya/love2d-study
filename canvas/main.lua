function love.load()
    canvas = love.graphics.newCanvas(800, 600)

    -- Rectangle is drawn to the canvas with the regular/default alpha blend mode ("alphamultiply").
    love.graphics.setCanvas(canvas)
        love.graphics.clear(0, 0, 0, 0)
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 0, 0, .5)
        love.graphics.rectangle("fill", 0,0, 100,100)
    love.graphics.setCanvas()
end

function love.draw()
    -- The colors for the rectangle on the canvas have already been alpha blended.
    -- Use the "premultiplied" alpha blend mode when drawing the canvas to the screen for proper color blending.
    -- (Also set the color to white so the canvas itself doesn't get tinted.)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(canvas, 0,0)
    -- Observe the difference if the canvas is drawn with the regular alpha blend mode instead.
    love.graphics.setBlendMode("alpha")
    -- love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.draw(canvas, 100,0)

    -- Rectangle is drawn directly to the screen with the regular alpha blend mode.
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 0, 0, .5)
    love.graphics.rectangle("fill", 200,0, 100,100)

    -- (Helper texts.)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("canvas", 0,0, 100)
    love.graphics.printf("incorrect\n(looks too dark)", 100,0, 100)
    love.graphics.printf("rectangle\n(what canvas should look like)", 200,0, 100)
end