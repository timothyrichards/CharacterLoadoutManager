function CharacterLoadoutManager:OnInitialize()
    cl_AceConsole:Embed(self)
    self.config = cl_AceConfig
    self.configDialog = cl_AceConfigDialog
    self.gui = cl_AceGUI
    self.dbOptions = cl_AceDBOptions

    self.options = {
        name = "Character Loadout Manager",
        handler = self,
        type = "group",
        args = {
--            welcome = {
--                name = "Welcome",
--                type = "group",
--                order = 0,
--                args = {
--                    p1 = {
--                        name = "Hello and welcome to the Character Loadout Manager add-on! This add-on is pretty simple, you'll head over to the profiles page and make a new profile. Once you have the new profile you can go ahead and equip whatever equipment set, talents, and essences that you want to save. After you have everything setup, you can click the 'Save Loadout' button, and ta-da! Your loadout is now saved to your current profile. Now you can make multiple profiles and save your different loadouts to each of them.",
--                        type = "description",
--                        fontSize = "medium",
--                        order = 0
--                    },
--                }
--            }
        },
    }
    self.config:RegisterOptionsTable("CharacterLoadoutManager", self.options)

    self.db = cl_AceDB:New("CharacterLoadoutsDB")
    self.db.RegisterCallback(self, "OnProfileChanged", "equipLoadout")
    self.options.args.profile = self.dbOptions:GetOptionsTable(self.db)
    self.options.args.profile.args.header = {
        name = "Loadout Management",
        type = "header",
        width = "full",
    }
    self.options.args.profile.args.equip = {
        name = "Equip Loadout",
        desc = "Equips your loadout from the current profile",
        width = "full",
        order = 101,
        type = "execute",
        func = function() self:equipLoadout() end,
    }
    self.options.args.profile.args.save = {
        name = "Save Loadout",
        desc = "Saves your loadout to the current profile",
        width = "full",
        order = 102,
        type = "execute",
        func = function() self:saveLoadout() end,
    }

    self:RegisterChatCommand("clm", function() self.configDialog:Open("CharacterLoadoutManager") end)
    self:Print("Character Loadout Manager addon has loaded!");
end

function CharacterLoadoutManager:OnEnable()
    -- Called when the addon is enabled
end

function CharacterLoadoutManager:OnDisable()
    -- Called when the addon is disabled
end
