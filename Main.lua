function CharacterLoadouts:drawLoadoutSwapper(container)
    local profileDropdown = self.gui:Create("Dropdown")
    profileDropdown:SetLabel("Loadout")
    profileDropdown:SetText(self.db:GetCurrentProfile())
    profileDropdown:SetWidth(300)
    profileDropdown:SetList(self.db:GetProfiles())
    container:AddChild(profileDropdown)

    local equipButton = self.gui:Create("Button")
    equipButton:SetText("Equip")
    equipButton:SetWidth(150)
    equipButton:SetCallback("OnClick", function() self:equipLoadout(self.db.profile.loadout) end)
    container:AddChild(equipButton)

    local saveButton = self.gui:Create("Button")
    saveButton:SetText("Save")
    saveButton:SetWidth(150)
    saveButton:SetCallback("OnClick", function() self:saveLoadout() end)
    container:AddChild(saveButton)
end

function CharacterLoadouts:drawLoadoutManager(container)
    local desc = self.gui:Create("Label")
    desc:SetText("This is a WIP")
    desc:SetFullWidth(true)
    container:AddChild(desc)
end

function CharacterLoadouts:SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "tab1" then
        self:drawLoadoutSwapper(container)
    elseif group == "tab2" then
        self:drawLoadoutManager(container)
    end
end

function CharacterLoadouts:openSettings()
    local frame = self.gui:Create("Frame")
    frame:SetTitle("Character Loadouts Settings")
    frame:SetStatusText("Remember to make sure you're in a rested area!")
    frame:SetCallback("OnClose", function(widget) self.gui:Release(widget) end)
    frame:SetWidth("500")
    frame:SetLayout("Fill")

    local tab = self.gui:Create("TabGroup")
    tab:SetLayout("Flow")
    tab:SetTabs({{text="Loadout Swapper", value="tab1"}, {text="Loadout Manager", value="tab2"}})
    tab:SetCallback("OnGroupSelected", function(container, event, group) self:SelectGroup(container, event, group) end)
    tab:SelectTab("tab1")

    frame:AddChild(tab)

    self:Print("Opening settings...");
end

function CharacterLoadouts:OnInitialize()
    cl_AceConsole:Embed(self)
    self.gui = cl_AceGUI

    local defaults = {
        profile = {
            loadout = {}
        },
    }
    self.db = LibStub("AceDB-3.0"):New("CharacterLoadouts", defaults)
    self:RegisterChatCommand("cls", function() self:openSettings() end)

    self:Print("Character Loadouts addon has loaded!");
end

function CharacterLoadouts:OnEnable()
    -- Called when the addon is enabled
end

function CharacterLoadouts:OnDisable()
    -- Called when the addon is disabled
end
