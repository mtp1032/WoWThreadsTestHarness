--=================================================================================
-- Test: thread error handling
--=================================================================================

local ADDON_NAME, ns = ...

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
local function dummy()
    local myName = nil
    local foo = myName[1]
end
local function parameterTests()
    local thread_h = nil
    local errorMsg = nil
    
    -- test thread:create() function arguments
    thread_h, errorMsg = thread:create( "stringParam", dummy )
    assert( thread_h ~= nil, errorMsg )

    thread_h, errorMsg = thread:create( 30, "hello")
    assert( thread_h ~= nil, errorMsg )

    -- this will succeed, but the thread function will throw a Lua error.
    -- In other words, the thread creation will succeed and no error will propagate
    -- up through the WoWThread's stack.
    thread_h, errorMsg = thread:create( 30, dummy )
    assert( thread_h ~= nil, errorMsg )
  
    -- testing is done. Notify the master thread and exit.
    local wasSent, errorMsg = thread:sendSignal( master_h, SIG_IS_COMPLETE )
    assert( wasSent, errorMsg )
end
local function test_threadCreateErrors()

    -- this test is expected to succeed with a non-nil handle and a nil errorMsg
    local thread_h, errorMsg = thread:create( 10, parameterTests )
    assert( thread_h ~= nil, errorMsg )
 
    while signal ~= SIG_NONE_PENDING do
        thread:yield()
        local sigEntry, errorMsg = thread:getSignal() 
        assert( signal ~= nil, errorMsg )
        local signal = sigEntry[1]
        local sender_h = sigEntry[2]

        if signal[1] == SIG_IS_COMPLETE then
            thread:sendSignal( signal[2], SIG_TERMINATE)
        end
        if signal[1] == SIG_TERMINATE then
            DONE = true 
        end
    end

    Scaffold.reportPass("test_threadErrorHandling")
end
-- Register the master thread with the scaffold
Scaffold.registerTest("test_threadErrorHandling", test_threadCreateErrors )


-- this thread creates the service that runs all the tests.
master_h, errorMsg = thread:create( 30, test_threadCreateErrors )
assert( master_h ~= nil, errorMsg )
