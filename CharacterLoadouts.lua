function CharacterLoadouts_equipSet(equipmentSetName)
   local setId = C_EquipmentSet.GetEquipmentSetID(equipmentSetName)

   C_EquipmentSet.UseEquipmentSet(setId)
end

function CharacterLoadouts_equipTalents(talents)
   for i, talent in pairs(talents) do
      LearnTalent(talent)
   end
end

function CharacterLoadouts_equipEssences(essences)
   local heartSlotIds = { 115, 116, 117, 119 }
   local essenceList = C_AzeriteEssence.GetEssences()
   local id;

   for index,essence in pairs(essences) do
      for k,v in pairs(essenceList) do
         if v.name == essence then
            id = v.ID;

            C_AzeriteEssence.ActivateEssence(id, heartSlotIds[index])
         end
      end;
   end;
end

function CharacterLoadouts_equipLoadout(equipmentSetName, talents, essences)
   CharacterLoadouts_equipSet(equipmentSetName)
   CharacterLoadouts_equipTalents(talents)
   CharacterLoadouts_equipEssences(essences)
end