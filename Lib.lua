function CharacterLoadouts:getSet()
   local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()
   local equipmentSets = {}

   for k,v in pairs(equipmentSetIDs) do
      local name, icon, id, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[k])
      if isEquipped then
         return id
      end
   end
end

function CharacterLoadouts:equipSet(set)
   C_EquipmentSet.UseEquipmentSet(set)
end

function CharacterLoadouts:getTalents()
   local talents = {}

   local i = 0
   while(i < 7) do
      local row = i + 1
      local b,column = GetTalentTierInfo(row, 1)
      local talentId = GetTalentInfo(row, column, 1)
      talents[i] = talentId
      i = i + 1
   end

   return talents
end

function CharacterLoadouts:equipTalents(talents)
   for i, talent in pairs(talents) do
      LearnTalent(talent)
   end
end

function CharacterLoadouts:getEssences()
   return {
      C_AzeriteEssence.GetMilestoneEssence(115),
      C_AzeriteEssence.GetMilestoneEssence(116),
      C_AzeriteEssence.GetMilestoneEssence(117),
      C_AzeriteEssence.GetMilestoneEssence(119)
   }
end

function CharacterLoadouts:equipEssences(essences)
   local heartSlotIds = { 115, 116, 117, 119 }
   local id

   for k,v in pairs(essences) do
      C_AzeriteEssence.ActivateEssence(v, heartSlotIds[k])
   end;
end

function CharacterLoadouts:equipLoadout(loadout)
   self:equipSet(loadout.set)
   self:equipTalents(loadout.talents)
   self:equipEssences(loadout.essences)

   self:Print("Equipping your character loadout...")
end

function CharacterLoadouts:saveLoadout()
   self.db.profile.loadout = {
      set = self:getSet(),
      talents = self:getTalents(),
      essences = self:getEssences()
   }

   self:Print("Saving your character loadout...")
end
