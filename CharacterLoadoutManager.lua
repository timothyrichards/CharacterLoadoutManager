function CharacterLoadoutManager:GetWelcomePage()
    return {
        name = "Welcome",
        type = "group",
        order = 0,
        args = {
            h1 = {
                name = "Welcome to the Character Loadout Manager add-on!",
                type = "description",
                fontSize = "large",
                order = 0,
            },
            header = {
                name = "",
                type = "header",
                width = "full",
                order = 1,
            },
            p1 = {
                name = [[This add-on is pretty simple, you'll head over to the profiles page and make a new profile.

Once you have the new profile you can go ahead and equip whatever equipment set, talents, and essences that you want to save.

After you have everything setup, you can click the 'Save Loadout' button, and ta-da! Your loadout is now saved to your current profile.

Now you can make multiple profiles and save your different loadouts to each of them.]],
                type = "description",
                fontSize = "medium",
                order = 2,
            },
        }
    }
end

function CharacterLoadoutManager:GetLoadoutManagerPage()
    return {
        name = "Loadout Manager",
        type = "group",
        desc = "Equip/Save loadouts from your current profile and see the details of what's saved to your current loadout.",
        order = 1,
        args = {
            clmButton = {
                name = "Character Window Button",
                desc = "After changing this setting you will need to perform a /reload for it to be in effect.",
                type = "toggle",
                order = 0,
                get = function(info) return self.db.global.clmBtnEnabled end,
                set = function(info,val) self.db.global.clmBtnEnabled = val end,
            },
            header1 = {
                name = "Loadout Management",
                type = "header",
                width = "full",
                order = 1,
            },
            equip = {
                name = "Equip Loadout",
                desc = "Equips your loadout from your current profile",
                width = "full",
                order = 2,
                type = "execute",
                func = function() self:equipLoadout() end,
            },
            save = {
                name = "Save Loadout",
                desc = "Saves your loadout to your current profile",
                width = "full",
                order = 3,
                type = "execute",
                func = function() self:saveLoadout() end,
            },
            header2 = {
                name = "Loadout Details",
                type = "header",
                width = "full",
                order = 4,
            },
        }
    }
end

function CharacterLoadoutManager:OnInitialize()
    -- Add the ace modules to the CharacterLoadoutManager object
    cl_AceConsole:Embed(self)
    self.config = cl_AceConfig
    self.configDialog = cl_AceConfigDialog
    self.gui = cl_AceGUI
    self.dbOptions = cl_AceDBOptions

    -- Register the options table
    self.options = {
        name = "Character Loadout Manager",
        handler = self,
        type = "group",
        args = {
            welcome = self:GetWelcomePage(),
            loadoutManager = self:GetLoadoutManagerPage(),
        },
    }
    self.config:RegisterOptionsTable("CharacterLoadoutManager", self.options)

    -- Set up the database
    self.db = cl_AceDB:New("CharacterLoadoutsDB")
    self.db.RegisterCallback(self, "OnProfileChanged", "equipLoadout")

    -- Adds profile page to the options window
    self.options.args.profile = self.dbOptions:GetOptionsTable(self.db)

    -- Register the /clm chat command and notify the plater that the addon has loaded
    self:RegisterChatCommand("clm", function() self.configDialog:Open("CharacterLoadoutManager") end)

    -- Add button to character window if enabled
    if (self.db.global.clmBtnEnabled) then
        local button = CharacterLoadoutManager.gui:Create("Button")
        button:SetText("CLM")
        button:SetWidth(75)
        button:SetCallback("OnClick", function() self:toggleDialog("CharacterLoadoutManager") end)
        button.frame:ClearAllPoints()
        button.frame:SetPoint("TOPLEFT", "PaperDollFrame", "TOPLEFT", 60, -30)
        button.frame:SetParent("PaperDollFrame")
        PaperDollFrame:HookScript("OnShow", function() button.frame:SetShown(PaperDollFrame:IsShown()) end)
    end

    self:Print("Character Loadout Manager addon has loaded! Use the command /clm to access it.");
end

function CharacterLoadoutManager:OnEnable()
    -- Called when the addon is enabled
end

function CharacterLoadoutManager:OnDisable()
    -- Called when the addon is disabled
end
