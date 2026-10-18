--=================================================================================
-- Filename: Locales.lua
-- Author: Michael Peterson
-- Date: October, 2026
--=================================================================================
local ADDON_NAME, ns = ...

ns.Locales = ns.Locales or {}
local Locales = ns.Locales
local global = ns.Globals

local gitVersion, expansionName = global:getAddonInfo()

-- =====================================================================
--                      LOCALIZATION
-- =====================================================================
local L = setmetatable({}, { __index = function(t, k) 
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })
ns.Locales.L = L
local L = ns.Locales

local LOCALE = GetLocale()
if LOCALE == "enUS" then
    L["VERSION"]          = ns.gitVersion
    L["EXPANSION_NAME"]   = getExpansionName()
    L["ADDON_LOADED_MSG"] = string.format("%s v%s, %s.", ADDON_NAME, gitVersion, expansionName )
end

print( L["ADDON_LOADED_MSG"] )
