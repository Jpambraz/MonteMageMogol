local LAM = LibAddonMenu2
local LMP = LibMapPins

local ADDON_NAME = "MonteeMageMogol"

local settings

------------------------------------------------
-- Apply Filters
------------------------------------------------

local function ApplyFilters()

    ------------------------------------------------
    -- LoreBooks pin filters
    ------------------------------------------------

    ------------------------------------------------
    -- Enable Shalidor
    ------------------------------------------------

    LMP:SetEnabled("LoreBooksMapPin_unknown", true)
    LMP:SetEnabled("LoreBooksMapPin_collected", true)

    ------------------------------------------------
    -- Disable Eidetic
    ------------------------------------------------

    LMP:SetEnabled("LoreBooksMapPin_eidetic", false)

    ------------------------------------------------
    -- Disable bookshelves
    ------------------------------------------------

    LMP:SetEnabled("LoreBooksMapPin_bookshelf", false)

    ------------------------------------------------
    -- Refresh map
    ------------------------------------------------

    LMP:RefreshPins("LoreBooksMapPin_unknown")
    LMP:RefreshPins("LoreBooksMapPin_collected")
    LMP:RefreshPins("LoreBooksMapPin_eidetic")
    LMP:RefreshPins("LoreBooksMapPin_bookshelf")

    d("[MonteeMageMogol] Filters applied")

end

------------------------------------------------
-- Settings Menu
------------------------------------------------

local function CreateSettingsMenu()

    local panelData = {
        type = "panel",
        name = "Montee Mage Mogol",
        displayName = "Montee Mage Mogol",
        author = "João",
        version = "1.0",
    }

    LAM:RegisterAddonPanel(
        "MonteeMageMogolPanel",
        panelData
    )

    local options = {

        {
            type = "checkbox",

            name = "Mage Guild Only Mode",

            tooltip = "Hide all other LoreBooks pins",

            getFunc = function()
                return settings.mageOnly
            end,

            setFunc = function(value)

                settings.mageOnly = value

                ApplyFilters()

            end,

            default = true,
        },
    }

    LAM:RegisterOptionControls(
        "MonteeMageMogolPanel",
        options
    )
end

------------------------------------------------
-- Addon Loaded
------------------------------------------------

local function OnAddonLoaded(event, addonName)

    if addonName ~= ADDON_NAME then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(
        ADDON_NAME,
        EVENT_ADD_ON_LOADED
    )

    ------------------------------------------------
    -- Saved Variables
    ------------------------------------------------

    settings = ZO_SavedVars:NewAccountWide(
        "MonteeMageMogolSavedVars",
        1,
        nil,
        {
            mageOnly = true,
        }
    )

    ------------------------------------------------
    -- Create Settings
    ------------------------------------------------

    CreateSettingsMenu()

    ------------------------------------------------
    -- Wait for LoreBooks to initialize
    ------------------------------------------------

    zo_callLater(function()

        ApplyFilters()

    end, 5000)

    d("[MonteeMageMogol] Loaded")

end

EVENT_MANAGER:RegisterForEvent(
    ADDON_NAME,
    EVENT_ADD_ON_LOADED,
    OnAddonLoaded
)