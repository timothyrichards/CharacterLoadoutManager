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
        desc = "Equip/Save loadouts from your current profiled and see the details of what's part of your current loadout.",
        order = 1,
        disabled = true,
        args = {
            equip = {
                name = "Equip Loadout",
                desc = "Equips your loadout from your current profile",
                width = "full",
                order = 1,
                type = "execute",
                func = function() self:equipLoadout() end,
            },
            save = {
                name = "Save Loadout",
                desc = "Saves your loadout to your current profile",
                width = "full",
                order = 2,
                type = "execute",
                func = function() self:saveLoadout() end,
            },
            header = {
                name = "Loadout Details",
                type = "header",
                width = "full",
                order = 3,
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
    self.options.args.profile.args.header = {
        name = "",
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

    -- Register the /clm chat command and notify the plater that the addon has loaded
    self:RegisterChatCommand("clm", function() self.configDialog:Open("CharacterLoadoutManager") end)
    self:Print("Character Loadout Manager addon has loaded! Use the command /clm to access it.");
end

function CharacterLoadoutManager:OnEnable()
    -- Called when the addon is enabled
end

function CharacterLoadoutManager:OnDisable()
    -- Called when the addon is disabled
end
