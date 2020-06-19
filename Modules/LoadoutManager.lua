function CharacterLoadoutManager:getSet()
   local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()

   for k,v in pairs(equipmentSetIDs) do
      local name, icon, id, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[k])
      if isEquipped then
         return id
      end
   end
end

function CharacterLoadoutManager:equipSet(set)
   local equippedSet = self:getSet()

   if equippedSet ~= set then
      C_EquipmentSet.UseEquipmentSet(set)
   end
end

function CharacterLoadoutManager:getTalents()
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

function CharacterLoadoutManager:equipTalents(talents)
   for k, talent in pairs(talents) do
      local row = k + 1
      local b,column = GetTalentTierInfo(row, 1)
      local talentId = GetTalentInfo(row, column, 1)

      if talentId ~= talent then
         LearnTalent(talent)
      end
   end
end

function CharacterLoadoutManager:getPvPTalents()
   return C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
end

function CharacterLoadoutManager:equipPvPTalents(pvpTalents)
   for k, talent in pairs(pvpTalents) do
      local talentId = C_SpecializationInfo.GetPvpTalentSlotInfo(k).selectedTalentID

      if talentId ~= talent then
         LearnPvpTalent(talent, k)
      end
   end
end

function CharacterLoadoutManager:getEssences()
   return {
      C_AzeriteEssence.GetMilestoneEssence(115),
      C_AzeriteEssence.GetMilestoneEssence(116),
      C_AzeriteEssence.GetMilestoneEssence(117),
      C_AzeriteEssence.GetMilestoneEssence(119)
   }
end

function CharacterLoadoutManager:equipEssences(essences)
   local heartSlotIds = { 115, 116, 117, 119 }
   local id

   for k,v in pairs(essences) do
      C_AzeriteEssence.ActivateEssence(v, heartSlotIds[k])
   end
end

function CharacterLoadoutManager:equipLoadout()
   local loadout = self.db.profile.loadout
   --   local id, name, mult = GetRestState()

   self:equipSet(loadout.set)
   --   if name == "Rested" then
   self:equipTalents(loadout.talents)
   self:equipPvPTalents(loadout.pvpTalents)
   self:equipEssences(loadout.essences)
   --   else
   --      self:Print("<WARNING> : We couldn't equip your talents or essences : <WARNING>")
   --   end

   self:Print("Equipping your character loadout: '" .. self.db:GetCurrentProfile() .. "'")
end

function CharacterLoadoutManager:saveLoadout()
   self.db.profile.loadout = {
      set = self:getSet(),
      talents = self:getTalents(),
      pvpTalents = self:getPvPTalents(),
      essences = self:getEssences()
   }

   self:Print("Saving your character loadout: '" .. self.db:GetCurrentProfile() .. "'")
end
