function setEssences(essences)
   azeriteEssences = C_AzeriteEssence;
   essenceList = azeriteEssences.GetEssences()
   
   for slot,essence in pairs(essences) do 
      
      for k,v in pairs(essenceList) do
         if v.name == essence then
            id = v.ID;
         end
      end;
      
      azeriteEssences.ActivateEssence(id, slot)
   end;
end