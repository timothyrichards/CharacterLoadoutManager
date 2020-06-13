function CharacterLoadouts_equipEssences(essences)
   local essenceList = C_AzeriteEssence.GetEssences()
   local id;

   for slot,essence in pairs(essences) do
      for k,v in pairs(essenceList) do
         if v.name == essence then
            id = v.ID;
         end
      end;

      C_AzeriteEssence.ActivateEssence(id, slot)
   end;
end

function CharacterLoadouts_equipSet(equipmentSetName)
   local setId = C_EquipmentSet.GetEquipmentSetID(equipmentSetName)

   C_EquipmentSet.UseEquipmentSet(setId)
end

function CharacterLoadouts_equipLoadout(essences, equipmentSetName)
   CharacterLoadouts_equipEssences(essences)
   CharacterLoadouts_equipSet(equipmentSetName)
end