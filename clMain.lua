function CharacterLoadouts:createSettingsFrame()
    local frame = cl_AceGUI:Create("Frame")
    frame:SetTitle("Character Loadouts Settings")
    frame:SetStatusText("Remember to be in a rested area when switching profiles!")

    local profileDropdown = cl_AceGUI:Create("Dropdown")
    profileDropdown:SetLabel("Profile")
    profileDropdown:SetText(cl_AceDB:GetCurrentProfile())
    profileDropdown:SetWidth(200)
    profileDropdown:SetList(cl_AceDB:GetProfiles())
    frame:AddChild(profileDropdown)

    local setDropdown = cl_AceGUI:Create("Dropdown")
    setDropdown:SetLabel("Equipment Set")
    setDropdown:SetWidth(200)
    setDropdown:SetList(CharacterLoadouts:getSets())
    frame:AddChild(setDropdown)

    local equipButton = cl_AceGUI:Create("Button")
    equipButton:SetText("Equip")
    equipButton:SetWidth(100)
    frame:AddChild(equipButton)

    local saveButton = cl_AceGUI:Create("Button")
    saveButton:SetText("Save")
    saveButton:SetWidth(100)
    frame:AddChild(saveButton)
end

function CharacterLoadouts:openSettings()
    cl_AceConsole:Print("<Character Loadouts> Opening settings...");
    CharacterLoadouts:createSettingsFrame()
end

function CharacterLoadouts:OnInitialize()
    --cl_AceConsole:RegisterChatCommand("cls", "CharacterLoadouts:openSettings")

    cl_AceConsole:Print("<Character Loadouts> Character Loadouts addon has loaded!");
    CharacterLoadouts:openSettings()
end

function CharacterLoadouts:OnEnable()
    -- Called when the addon is enabled
end

function CharacterLoadouts:OnDisable()
    -- Called when the addon is disabled
end