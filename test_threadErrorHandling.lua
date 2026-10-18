--=================================================================================
-- Test: thread error handling
--=================================================================================

local ADDON_NAME, ns = ...
ns.Scaffold = ns.Scaffold or {}
local Scaffold = ns.Scaffold
local master_h = nil

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

--=================================================================================
-- Test: threadErrorHandling
--=================================================================================
-- create a Lua error
local function luaErrorOne()
    local myName = nil
    local foo = myName[1]
    return
end
-- Wapper function for thread creation errors
local function wrapper()
function test_ThreadCreationErrors()

        -- thread:create - Invalid function type
        local thread_h, errorMsg = thread:create( 10, "invalidFunction" )
        assert( thread_h ~= nil, errorMsg )

        -- thread:create - Invalid tick count.
        thread_h, errorMsg = thread:create( "invalidTickCount", luaErrorOne )
        assert( thread_h ~= nil, errorMsg )
        print(1)
        
        -- thread:create - Lua fault in thread's function
        thread_h, errorMsg = thread:create( 20, luaErrorOne )
        assert( thread_h ~= nil, errorMsg )
        print(2)

        Scaffold:reportFail("Thread Creation Error Handling")
    end
end
local function test_errorsThreadCreation()
    print( "created master_h")
    -- =================================================
    -- TEST 1: Creates threads with bad parameters
    -- =================================================
    local createTest_h, errorMsg = thread:create( 30, test_threadCreateErrors )
    assert( createTest_h ~= nil, errorMsg )

    thread:yield()
    DONE = false

    local count = 1
    while not DONE do
        local sigEntry, errorMsg = thread:getSignal()
        assert( sigEntry ~= false, errorMsg )

        sigEntry, errorMsg = thread:getSignal()
        local signal    = sigEntry[1]
        local sender_h  = sigEntry[2]
        local error     = sigEntry[3]

        assert( false, "FAIL: " .. error )
        count = count + 1
        if count == 3 then DONE = true end
    end
end

local function master()
end
Scaffold:registerTest("Thread Creation Error Handling", test_threadCreateErrors )
-- ScaffoldregisterTest("Signal Send/receive Error Handling", test_threadSignalingErrors )
-- ScaffoldregisterTest("test_threadErrorHandling", test_threadCreateErrors )
-- ScaffoldregisterTest("test_threadErrorHandling", test_threadCreateErrors )
-- ScaffoldregisterTest("test_threadErrorHandling", test_threadCreateErrors )
-- ScaffoldregisterTest("test_threadErrorHandling", test_threadCreateErrors )


-- this thread creates the service that runs all the tests.
master_h, errorMsg = thread:create( 30, master )
assert( master_h ~= nil, errorMsg )

