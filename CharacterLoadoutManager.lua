CharacterLoadoutManager = LibStub("AceAddon-3.0"):NewAddon("CharacterLoadoutManager")
cl_AceDB = LibStub("AceDB-3.0")
cl_AceDBOptions = LibStub("AceDBOptions-3.0")
cl_AceConsole = LibStub("AceConsole-3.0")
cl_AceGUI = LibStub("AceGUI-3.0")
cl_AceConfig = LibStub("AceConfig-3.0")
cl_AceConfigDialog = LibStub("AceConfigDialog-3.0")
cl_AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

function CharacterLoadoutManager:CreateCLMButton()
    self.clmBtn = self.gui:Create("Button")
    self.clmBtn:SetText("CLM")
    self.clmBtn:SetWidth(60)
    self.clmBtn:SetCallback("OnClick", function() self:ToggleDialog("CharacterLoadoutManager") end)
    self.clmBtn.frame:ClearAllPoints()
    self.clmBtn.frame:SetPoint("TOPLEFT", "PaperDollFrame", "TOPLEFT", self.db.global.clmBtnX, self.db.global.clmBtnY)
    self.clmBtn.frame:SetParent("PaperDollFrame")
    PaperDollFrame:HookScript("OnShow", function() self.clmBtn.frame:SetShown(PaperDollFrame:IsShown()) end)
end

function CharacterLoadoutManager:RefreshConfig()
    self.options.args.loadoutManager = self:GetLoadoutManagerPage()
    cl_AceConfigRegistry:NotifyChange("CharacterLoadoutManager")
end

function CharacterLoadoutManager:OnInitialize()
    -- Add the ace modules to the CharacterLoadoutManager object
    cl_AceConsole:Embed(self)
    self.config = cl_AceConfig
    self.configDialog = cl_AceConfigDialog
    self.gui = cl_AceGUI
    self.dbOptions = cl_AceDBOptions

    -- Set up the database
    self.db = cl_AceDB:New("CharacterLoadoutsDB", {}, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "EquipLoadout")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    -- Initialize default button values
    if self.db.global.clmBtnEnabled == nil then
        self.db.global.clmBtnEnabled = true
    end
    if self.db.global.clmBtnX == nil then
        self.db.global.clmBtnX = 60
    end
    if self.db.global.clmBtnY == nil then
        self.db.global.clmBtnY = -30
    end
end

function CharacterLoadoutManager:OnEnable()
    -- Register the options table
    self.options = {
        name = "Character Loadout Manager",
        handler = self,
        type = "group",
        args = {
            welcome = self:GetWelcomePage(),
            loadoutManager = self:GetLoadoutManagerPage(),
            profile = self.dbOptions:GetOptionsTable(self.db),
        },
    }
    self.config:RegisterOptionsTable("CharacterLoadoutManager", self.options)

    -- Register the /clm chat command and notify the plater that the addon has loaded
    self:RegisterChatCommand("clm", function() self.configDialog:Open("CharacterLoadoutManager") end)

    -- Add button to character window if enabled
    if (self.db.global.clmBtnEnabled) then
        self:CreateCLMButton()
    end

    self:Print("Character Loadout Manager addon has loaded! Use the command /clm to access it.");
end

function CharacterLoadoutManager:OnDisable()
    -- Called when the addon is disabled
end
