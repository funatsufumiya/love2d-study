-- This is the code that's going to run on the our thread. It should be moved
-- to its own dedicated Lua file, but for simplicity's sake we'll create it
-- here.
local threadCode = [[
require "love.timer"

-- Receive values sent via thread:start
local min, max = ...

for i = min, max do
    -- The Channel is used to handle communication between our main thread and
    -- this thread. On each iteration of the loop will push a message to it which
    -- we can then pop / receive in the main thread.
    love.thread.getChannel( 'info' ):push( i )
    local t = math.random() / 3.0
    love.timer.sleep(t)
end
]]

local thread -- Our thread object.
local timer = 0  -- A timer used to animate our circle.
local lastvalue = nil

function love.load()
    thread = love.thread.newThread( threadCode )
    thread:start( 99, 1000 )
end

function love.update( dt )
    timer = timer + dt
end

function love.draw()
    -- Get the info channel and pop the next message from it.
    local info = love.thread.getChannel( 'info' ):pop()
    if info then
        lastvalue = info
    end
    if lastvalue then
        love.graphics.print( lastvalue, 10, 10 )
    end

    -- We smoothly animate a circle to show that the thread isn't blocking our main thread.
    love.graphics.circle( 'line', 100 + math.sin( timer ) * 20, 100 + math.cos( timer ) * 20, 20 )
end