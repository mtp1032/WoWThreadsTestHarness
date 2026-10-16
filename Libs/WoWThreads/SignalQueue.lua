---------------------------------------------------------------
-- Filename: SignalQueue.lua
-- Author: Michael Peterson
-- Date: October, 2026
---------------------------------------------------------------
ADDON_NAME, ns = ...

ns.SignalQueue = ns.SignalQueue or {}
local sig = ns.SignalQueue

-- Class definition
local SignalTable = {}
SignalTable.__index = SignalTable

local sigTable = SignalTable

function sig:new()
    local self = setmetatable({}, SignalTable)
    self.front = 1
    self.rear = 0
    self.items = {}
    return self
end
function sigTable:enqueue(value)
    self.rear = self.rear + 1
    self.items[self.rear] = value
end
function sigTable:dequeue()
    if self:isEmpty() then
        return nil
    end

    local value = self.items[self.front]
    self.items[self.front] = nil
    self.front = self.front + 1

    if self.front > self.rear then
        self.front = 1
        self.rear = 0
    end

    return value
end
function sigTable:peek() 
    if self:isEmpty() then
        return nil
    end
    return self.items[self.front]
end
function sigTable:isEmpty()
    return self.front > self.rear
end
function sigTable:size()
    return self.rear - self.front + 1
end
return SignalQueue
