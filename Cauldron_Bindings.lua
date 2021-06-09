local nextButtonIndex = 1

--- Creates a action button frame for binding.
-- @return created action button frame
--
local function CreateButtonFrame()
    local frame = CreateFrame("Button", "Cauldron_BindingsActionButton" .. nextButtonIndex, UIParent, "SecureActionButtonTemplate")
    nextButtonIndex = nextButtonIndex + 1
    return frame
end

--- Sets the defined bindings
-- @param recipe recipe table
--
local function SetRecipeBindings(recipe)
    local bindings = recipe["bindings"]

    -- Creates owner frame for override bindings
    local owner = CreateFrame("Frame")
    recipe["__runtime"]["bindings_owner"] = owner

    for i = 1, #bindings do
        local binding = bindings[i]
        local key, action = binding["key"], binding["action"]

        if type(action) == "string" then
            if key then
                SetOverrideBinding(owner, true, key, action)
                Cauldron_Debug(string.format("Bind command: '%s'->'%s'.", key, tostring(action)))
            else
                -- Continue to next binding
                Cauldron_Warn(string.format("Key missed for binding command '%s'.", tostring(action)))
            end
        elseif type(action) == "table" then
            if not action["frame"] then
                action["frame"] = CreateButtonFrame()
            end

            local frameName = action["frame"]:GetName()

            if key then
                SetOverrideBindingClick(owner, true, key, frameName)
                Cauldron_Debug(string.format("Bind action: '%s'->'%s'.", key, frameName))
            end

            for attrName, attrValue in pairs(action["attributes"]) do
                action["frame"]:SetAttribute(attrName, attrValue)
                Cauldron_Debug(string.format("Set '%s' attribute: '%s'->'%s'.", frameName, attrName, attrValue))
            end
        else
            Cauldron_Error(string.format("Unknown action type '%s'.", type(action)))
        end
    end
end

--- Clears the bindings defined in the given recipe.
-- @param recipe recipe table.
--
local function ClearRecipeBindings(recipe)
    if recipe["__runtime"]["bindings_owner"] then
        ClearOverrideBindings(recipe["__runtime"]["bindings_owner"])
    end
end

-- Registers events for recipe attribute
Cauldron_RegisterEvent("RECIPE_ENABLE", function(_, recipe)
    if not recipe["bindings"] then
        return
    end

    SetRecipeBindings(recipe)
end)

Cauldron_RegisterEvent("RECIPE_DISABLE", function(_, recipe)
    if not recipe["bindings"] then
        return
    end

    ClearRecipeBindings(recipe)
end)
