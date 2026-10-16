ADDON_NAME, ns = ...

UtilsLib = UtilsLib or {}
SignalQueue = SignalQueue or {}

local utils = UtilsLib

local thread = LibStub("WoWThreads", "0.1.0")
if not thread then
    error("WoWThreads library not found.")
end

local function genericTest( ... )
    local iterations = 1
    local msg = ...

    while iterations <= 5 do
        print( msg )
        thread:yield()
        iterations = iterations + 1
    end
end
-- run multiple thread creation tests
local function test_threadCreation()
    print( "  ")
    print( "BEGINNING THREAD CREATION TESTS" )
    print("  ")
    
    local thread_h, errorMsg = thread:create("stringType", genericTest, "hello")
    if thread_h == nil and errorMsg ~= nil then
        print( "PASSED", errorMsg )
    end

    local thread_h, errorMsg = thread:create( genericTest, "hello")
    if thread_h == nil and errorMsg ~= nil then
        print( "PASSED", errorMsg )
    end

    print( "Thread creation parameters test complete")
end

local function OnAddonLoaded()
    thread:libraryInit()  -- start the scheduler

    -- this isn't a test per se. It creates a thread will execute multiple tests.
    local thread_h, result = thread:create(30, test_threadCreation )
    if not thread_h then 
        error(result[1])
    end
    DEFAULT_CHAT_FRAME:AddMessage(string.format("%s v0.1.0 initialized.", "WoWthreads-embedded"), 0, 1, 1)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, _, ADDON_NAME)
    if ADDON_NAME == "WoWThreadsTestHarness" then
        OnAddonLoaded()
    end
end)
