-- Simple Love2D GPU particle seed demo
-- Place this folder in a LÖVE project and run with `love .`

local vertex_shader = [[
extern float particleSize;
extern float time;
varying vec4 v_seed;
varying vec2 v_texcoord;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    v_seed = VertexColor;
    v_texcoord = VertexTexCoord.xy;

    // VertexPosition holds the particle center (same center for all corners).
    // VertexTexCoord gives corner flags (0/1) which we map to offset centered on (0,0).
    vec2 corner = VertexTexCoord.xy - vec2(0.5);
    vec2 offset = corner * particleSize;

    // seed controls animation phase / period
    float seed = VertexColor.r;
    float period = 1.0 + seed; // seconds
    float phase = time * 6.2831853 / period; // 2*pi/time_period
    float amp = particleSize * 1.5;
    vec2 jitter = vec2(cos(phase + seed * 6.2831853), sin(phase + seed * 6.2831853)) * amp;

    vec4 pos = vertex_position + vec4(offset + jitter, 0.0, 0.0);
    return transform_projection * pos;
}
]]

local fragment_shader = [[
extern float time;

varying vec4 v_seed;
varying vec2 v_texcoord;

vec4 effect(vec4 color, Image texture, vec2 texcoord, vec2 pixcoord)
{
    // Use seed to vary color and alpha over time. Alpha cycles with period (1 + seed).
    float seed = v_seed.r;
    float period = 1.0 + seed;
    float m = mod(time, period);
    float f = m / period;
    float alpha = abs(sin(f * 6.2831853));

    vec3 col = vec3(seed, 0.5 * seed + 0.25, 1.0 - seed);
    return vec4(col, alpha) * color;
}
]]

local shader
local mesh
local bufferSize = 10000 -- change this to create more particles (each particle = 4 vertices / a quad)
local particleSize = 2

local function createParticleMesh(count, size)
    local vertices = {}
    local indices = {}

    local margin = 8
    local cols = math.max(1, math.floor(math.sqrt(count)))
    local spacing = size + margin

    for i = 1, count do
        local col = (i-1) % cols
        local row = math.floor((i-1) / cols)
        local cx = 100 + col * spacing
        local cy = 100 + row * spacing
        local half = size / 2

        -- Seed values stored in vertex color (r,g,b,a) as normalized floats (0..1)
        local seed_r = love.math.random()
        local seed_g = love.math.random()
        local seed_b = love.math.random()
        local a = 1

        -- Each particle is a quad (4 logical corners). Store particle center in x,y
        -- and use u,v as corner flags (0 or 1). Vertex shader offsets by particleSize.
        local v1 = {cx, cy, 0, 0, seed_r, seed_g, seed_b, a}
        local v2 = {cx, cy, 1, 0, seed_r, seed_g, seed_b, a}
        local v3 = {cx, cy, 1, 1, seed_r, seed_g, seed_b, a}
        local v4 = {cx, cy, 0, 1, seed_r, seed_g, seed_b, a}

        -- Emit as two triangles: (v1,v2,v3) and (v1,v3,v4)
        table.insert(vertices, v1)
        table.insert(vertices, v2)
        table.insert(vertices, v3)
        table.insert(vertices, v1)
        table.insert(vertices, v3)
        table.insert(vertices, v4)
    end

    local m = love.graphics.newMesh(vertices, "triangles", "static")
    -- m:setVertexMap(indices)
    return m
end

function love.load()
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.05, 0.05, 0.06)
    shader = love.graphics.newShader(vertex_shader, fragment_shader)
    mesh = createParticleMesh(bufferSize, particleSize)
    shader:send("particleSize", particleSize)
end

function love.update(dt)
    shader:send("time", love.timer.getTime())
end

function love.draw()
    love.graphics.setShader(shader)
    love.graphics.draw(mesh)
    love.graphics.setShader()

    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Buffer size: " .. tostring(bufferSize) .. " particles (each = 4 verts)", 10, 10)
    love.graphics.print("Press R to reseed", 10, 26)
end

function love.keypressed(key)
    if key == "r" then
        mesh = createParticleMesh(bufferSize, particleSize)
    end
end
