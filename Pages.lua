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
            header2 = {
                name = "",
                type = "header",
                width = "full",
                order = 3,
            },
            clmBtn = {
                name = "Character Window Button",
                desc = "After changing this setting you will need to perform a /reload for it to be in effect.",
                type = "toggle",
                width = 1,
                order = 4,
                get = function(info) return self.db.global.clmBtnEnabled end,
                set = function(info,val) self.db.global.clmBtnEnabled = val end,
            },
            btnX = {
                name = "Button X",
                desc = "Must be a number, this is the X position of the button relative to the top left corner of the Character window. (Default: 60)",
                type = "input",
                width = 0.5,
                order = 5,
                get = function(info) return self.db.global.clmBtnX end,
                set = function(info,val) self.db.global.clmBtnX = val, self.clmBtn.frame:SetPoint("TOPLEFT", "PaperDollFrame", "TOPLEFT", val, self.db.global.clmBtnY) end,
            },
            btnY = {
                name = "Button Y",
                desc = "Must be a number, this is the Y position of the button relative to the top left corner of the Character window. (Default: -30)",
                type = "input",
                width = 0.5,
                order = 6,
                get = function(info) return self.db.global.clmBtnY end,
                set = function(info,val) self.db.global.clmBtnY = val, self.clmBtn.frame:SetPoint("TOPLEFT", "PaperDollFrame", "TOPLEFT", self.db.global.clmBtnX, val) end,
            },
        }
    }
end

function CharacterLoadoutManager:GetLoadoutManagerPage()
    local loadout = self.db.profile.loadout
    local loadoutDetails = {
        name = "Loadout Details",
        type = "group",
        desc = "View the details of your current loadout.",
        order = 1,
        args = {
            equip = {
                name = "Equip Loadout",
                desc = "Equips your loadout from your current profile",
                width = "Half",
                order = 1,
                type = "execute",
                func = function() self:EquipLoadout() end,
            },
            save = {
                name = "Save Loadout",
                desc = "Saves your loadout to your current profile",
                width = "Half",
                order = 2,
                type = "execute",
                func = function() self:SaveLoadout() end,
            },
            p = {
                name = "You don't have any information saved to this loadout yet.",
                type = "description",
                fontSize = "medium",
                hidden = true,
                order = 3,
            },
            header = {
                name = "Talents",
                type = "header",
                width = "full",
                hidden = true,
                order = 4,
            },
            header2 = {
                name = "PvP Talents",
                type = "header",
                width = "full",
                hidden = true,
                order = 5,
            },
            header3 = {
                name = "Essences",
                type = "header",
                width = "full",
                hidden = true,
                order = 6,
            }
        }
    }

    if loadout == nil then
        self:Print("You do not have a saved loadout for this profile, please go to the Loadout Manager tab and click 'Save Loadout'")
        loadoutDetails.args.p.hidden = false
        return loadoutDetails
    else
        local order = 3;

        if table.getn(loadout.talents) ~= 0 then
            loadoutDetails.args.header.hidden = false
            loadoutDetails.args.header.order = order
            for k,v in pairs(loadout.talents) do
                order = order + 1;
                local talentID, name, icon = GetTalentInfoByID(v, GetActiveSpecGroup())
                loadoutDetails.args[name] = {
                    name = name,
                    type = "description",
                    fontSize = "medium",
                    image = icon,
                    order = order,
                }
            end
        end

        if table.getn(loadout.pvpTalents) ~= 0 then
            order = order + 1;
            loadoutDetails.args.header2.hidden = false
            loadoutDetails.args.header2.order = order
            for k,v in pairs(loadout.pvpTalents) do
                order = order + 1;
                local talentID, name, icon = GetPvpTalentInfoByID(v, GetActiveSpecGroup())
                loadoutDetails.args[name] = {
                    name = name,
                    type = "description",
                    fontSize = "medium",
                    image = icon,
                    order = order,
                }
            end
        end

        if table.getn(loadout.essences) ~= 0 then
            order = order + 1;
            loadoutDetails.args.header3.hidden = false
            loadoutDetails.args.header3.order = order
            for k,v in pairs(loadout.essences) do
                order = order + 1;
                local info = C_AzeriteEssence.GetEssenceInfo(v)
                if info == nil then
                    return
                end
                loadoutDetails.args[info.name] = {
                    name = info.name,
                    type = "description",
                    fontSize = "medium",
                    image = info.icon,
                    order = order,
                }
            end
        end
    end

    return loadoutDetails
end