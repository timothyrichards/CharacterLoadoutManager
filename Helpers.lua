function CharacterLoadoutManager:GetSet()
    local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()

    for k,v in pairs(equipmentSetIDs) do
        local name, icon, id, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[k])
        if isEquipped then
            return id
        end
    end
end

function CharacterLoadoutManager:EquipSet(set)
    local equippedSet = self:GetSet()

    if equippedSet ~= set then
        C_EquipmentSet.UseEquipmentSet(set)
    end
end

function CharacterLoadoutManager:GetTalents()
    local talents = {}

    local i = 1
    while(i <= 7) do
        local row = i
        local b,column = GetTalentTierInfo(row, 1)
        local talentId = GetTalentInfo(row, column, 1)
        talents[i] = talentId
        i = i + 1
    end

    return talents
end

function CharacterLoadoutManager:EquipTalents(talents)
    for k, talent in pairs(talents) do
        local row = k + 1
        local b,column = GetTalentTierInfo(row, 1)
        local talentId = GetTalentInfo(row, column, 1)

        if talentId ~= talent then
            LearnTalent(talent)
        end
    end
end

function CharacterLoadoutManager:GetPvPTalents()
    return C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
end

function CharacterLoadoutManager:EquipPvPTalents(pvpTalents)
    for k, talent in pairs(pvpTalents) do
        local talentId = C_SpecializationInfo.GetPvpTalentSlotInfo(k).selectedTalentID

        if talentId ~= talent then
            LearnPvpTalent(talent, k)
        end
    end
end

function CharacterLoadoutManager:GetEssences()
    return {
        C_AzeriteEssence.GetMilestoneEssence(115),
        C_AzeriteEssence.GetMilestoneEssence(116),
        C_AzeriteEssence.GetMilestoneEssence(117),
        C_AzeriteEssence.GetMilestoneEssence(119)
    }
end

function CharacterLoadoutManager:EquipEssences(essences)
    local heartSlotIds = { 115, 116, 117, 119 }
    local id

    for k,v in pairs(essences) do
        C_AzeriteEssence.ActivateEssence(v, heartSlotIds[k])
    end
end

function CharacterLoadoutManager:EquipLoadout()
    local loadout = self.db.profile.loadout

    if loadout == nil then
        self:Print("You do not have a saved loadout for this profile, please go to the Loadout Manager tab and click 'Save Loadout'")
        return
    end

    self:Print("Equipping your character loadout: '" .. self.db:GetCurrentProfile() .. "'")
    self:EquipSet(loadout.set)
    if IsResting() then
        self:EquipTalents(loadout.talents)
        self:EquipPvPTalents(loadout.pvpTalents)
        self:EquipEssences(loadout.essences)
    else
        self:Print("|cffFF0000!WARNING! : We couldn't equip your talents or Essences : !WARNING!")
    end

    self:RefreshConfig()
end

function CharacterLoadoutManager:SaveLoadout()
    self.db.profile.loadout = {
        set = self:GetSet(),
        talents = self:GetTalents(),
        pvpTalents = self:GetPvPTalents(),
        essences = self:GetEssences()
    }

    self:Print("Saving your character loadout: '" .. self.db:GetCurrentProfile() .. "'")
    self:RefreshConfig()
end

function CharacterLoadoutManager:ToggleDialog(name)
    if self.configDialog.OpenFrames[name] then
        self.configDialog:Close(name)
    else
        self.configDialog:Open(name)
    end
end
