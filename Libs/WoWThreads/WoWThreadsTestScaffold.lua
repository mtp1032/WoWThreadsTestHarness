--=================================================================================
-- WoWThreads Test Scaffold
--=================================================================================

local ADDON_NAME, ns = ...

local thread = LibStub("WoWThreads", "0.1.0")
if not thread then
    error("WoWThreads library not found.")
end

local Scaffold = {}
ns.Scaffold = Scaffold

-- Internal storage for registered tests
local tests = {}
local results = {
    passed = 0,
    failed = 0,
    groups = {}
}

--=================================================================================
-- Register a test
--=================================================================================
function Scaffold:registerTest(name, fn)
    tests[#tests + 1] = { name = name, fn = fn }
end

--=================================================================================
-- Optional grouping (cosmetic)
--=================================================================================
function Scaffold:beginGroup(name)
    print(" ")
    print("=== BEGIN TEST GROUP:", name, "===")
    print(" ")
    results.groups[#results.groups + 1] = { name = name }
end

function Scaffold:endGroup(name)
    print(" ")
    print("=== END TEST GROUP:", name, "===")
    print(" ")
end

--=================================================================================
-- PASS / FAIL reporting
--=================================================================================
function Scaffold:reportPass(name)
    results.passed = results.passed + 1
    print("|cff00ff00PASS|r", name)
end

function Scaffold:reportFail(name, msg)
    results.failed = results.failed + 1
    print("|cffff0000FAIL|r", name, msg)
end

--=================================================================================
-- Run all registered tests
--=================================================================================
function Scaffold:runAllTests()
    print(" ")
    print("======================================")
    print("      WoWThreads Automated Tests       ")
    print("======================================")
    print(" ")

    for _, t in ipairs(tests) do
        local ok, msg = pcall(t.fn)
        if ok then
            Scaffold:reportPass(t.name)
        else
            Scaffold:reportFail(t.name, msg)
        end
    end

    Scaffold:printSummary()
end

--=================================================================================
-- Summary
--=================================================================================
function Scaffold:printSummary()
    print(" ")
    print("======================================")
    print("            TEST SUMMARY              ")
    print("======================================")
    print("Passed:", results.passed)
    print("Failed:", results.failed)
    print("Total:", results.passed + results.failed)
    print("======================================")
    print(" ")
end

local function OnAddonLoaded()
    thread:libraryInit()  -- start the scheduler
    DEFAULT_CHAT_FRAME:AddMessage(string.format("%s v0.1.0 initialized.", "WoWthreads-embedded"), 0, 1, 1)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, _, ADDON_NAME)
    if ADDON_NAME == "WoWThreadsTestHarness" then
        OnAddonLoaded()
    end
end)
