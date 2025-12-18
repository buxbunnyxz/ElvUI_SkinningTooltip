local E, L, V, P, G = unpack(ElvUI)
local TT = E:GetModule('Tooltip')
local EP = LibStub("LibElvUIPlugin-1.0")
local addonName = "ElvUI_SkinningTooltip"

-- 1. Initialize Default Settings
P["SkinningTooltip"] = {
    ["enable"] = true,
}

local function GetSkinningLevel()
    for i = 1, GetNumSkillLines() do
        local name, _, _, rank = GetSkillLineInfo(i)
        if name == "Skinning" then return rank end
    end
    return 0
end

local function OnTooltipSetUnit(self)
    -- Check if enabled in ElvUI settings
    if not E.db.SkinningTooltip.enable then return end

    local _, unit = self:GetUnit()
    if not unit or not UnitExists(unit) or UnitIsPlayer(unit) then return end

    local playerSkill = GetSkinningLevel()
    if playerSkill <= 0 then return end

    local creatureType = UnitCreatureType(unit)
    if creatureType == "Beast" or creatureType == "Dragonkin" then
        local level = UnitLevel(unit)
        if level < 0 then level = 83 end

        local req = (level <= 20) and math.max(1, (level - 10) * 10) or (level * 5)
        local color = (playerSkill >= req) and "|cff00ff00" or "|cffff0000"
        
        self:AddLine("Skinning: " .. color .. req .. "|r")
    end
end

-- 2. Inject Menu into ElvUI
function HookOptions()
    E.Options.args.SkinningTooltip = {
        type = "group",
        name = "Skinning Tooltip",
        args = {
            enable = {
                type = "toggle",
                order = 1,
                name = "Enable",
                desc = "Show skinning level on tooltips.",
                get = function(info) return E.db.SkinningTooltip.enable end,
                set = function(info, value) E.db.SkinningTooltip.enable = value end,
            },
        },
    }
end

-- 3. Register the Plugin
EP:RegisterPlugin(addonName, HookOptions)
GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)