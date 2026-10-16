ADDON_NAME, ns = ...

UtilsLib = UtilsLib or {}
SignalQueue = SignalQueue or {}

local utils = UtilsLib

local thread = LibStub("WoWThreads", "0.1.0")
if not thread then
    error("WoWThreads library not found.")
end

local SIG_HAS_PAYLOAD  = thread.SIG_HAS_PAYLOAD
local SIG_SEND_PAYLOAD = thread.SEND_DATA
local SIG_BEGIN        = thread.SIG_BEGIN
local SIG_HALT         = thread.SIG_HALT
local SIG_IS_COMPLETE  = thread.SIG_IS_COMPLETE
local SIG_SUCCESS      = thread.SIG_SUCCESS
local SIG_FAILURE      = thread.SIG_FAILURE
local SIG_IS_READY     = thread.SIG_IS_READY
local SIG_CALLBACK     = thread.SIG_CALLBACK
local SIG_THREAD_DEAD  = thread.SIG_THREAD_DEAD
local SIG_ALERT        = thread.SIG_ALERT
local SIG_WAKEUP       = thread.SIG_WAKEUP
local SIG_TERMINATE    = thread.SIG_TERMINATE
local SIG_NONE_PENDING = thread.SIG_NONE_PENDING

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
