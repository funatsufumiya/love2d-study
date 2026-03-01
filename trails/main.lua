local canvas
local w
local h
local prev_x
local prev_y
local t = 0
local shader
local alpha_threshold = 0.01

function love.load()
    w = love.graphics.getWidth()
    h = love.graphics.getHeight()
    canvas = love.graphics.newCanvas(w, h)
    shader = love.graphics.newShader([[ 
        extern number threshold;

        vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 screen_coords)
        {
            vec4 tc = Texel(tex, texcoord);
            float a = tc.r;
            if (a < threshold) {
                return vec4(0.0, 0.0, 0.0, 0.0) * color;
            }
            float oldA = tc.a;
            vec3 rgb;
            if (oldA > 0.00001) {
                rgb = tc.rgb * (a / oldA);
            } else {
                rgb = vec3(0.0);
            }
            return vec4(rgb, a) * color;
        }
    ]])
    shader:send("threshold", alpha_threshold)

    love.graphics.setBackgroundColor(0, 0, 0.5)
end

function love.update(dt)
    t = t + dt
end

function love.draw()
    local x = love.mouse.getX()
    local y = love.mouse.getY()

    if prev_x == nil then
        prev_x = x
    end

    if prev_y == nil then
        prev_y = y
    end

    love.graphics.setCanvas(canvas)
    if t > 0.01 then
        love.graphics.setColor(0, 0, 0, 0.1)
        love.graphics.rectangle("fill", 0, 0, w, h)
        t = 0
    end

    love.graphics.setColor(1, 1, 1)
    -- love.graphics.rectangle("fill", x, y, 2, 2)
    love.graphics.line(x, y, prev_x, prev_y)
    love.graphics.setCanvas()

    -- Draw canvas using shader (red channel -> alpha), use premultiplied blending
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setShader(shader)
    love.graphics.draw(canvas)
    love.graphics.setShader()
    love.graphics.setBlendMode("alpha")

    prev_x = x
    prev_y = y
end