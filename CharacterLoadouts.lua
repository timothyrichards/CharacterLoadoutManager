CharacterLoadouts = LibStub("AceAddon-3.0"):NewAddon("CharacterLoadouts")
AceConsole = LibStub("AceConsole-3.0")
AceGUI = LibStub("AceGUI-3.0")

function CharacterLoadouts:getSets()
   local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()
   local equipmentSets = {}

   for k,v in pairs(equipmentSetIDs) do
      equipmentSets[k] = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[k])
   end

   return equipmentSets
end

function CharacterLoadouts:equipSet(set)
   C_EquipmentSet.UseEquipmentSet(set)
end

function CharacterLoadouts:getTalents()
   --
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
   CharacterLoadouts:equipSet(loadout["set"])
   CharacterLoadouts:equipTalents(loadout["talents"])
   CharacterLoadouts:equipEssences(loadout["essences"])
end

function CharacterLoadouts:createSettingsFrame()
   local frame = AceGUI:Create("Frame")
   frame:SetTitle("Character Loadouts Settings")
   frame:SetStatusText("Remember to be in a rested area when switching profiles!")

   local setDropdown = AceGUI:Create("Dropdown")
   setDropdown:SetLabel("Equipment Set")
   setDropdown:SetWidth(200)
   setDropdown:SetList(CharacterLoadouts:getSets())
   frame:AddChild(setDropdown)
end

function CharacterLoadouts:openSettings()
   AceConsole:Print("<Character Loadouts> Opening settings...");
   CharacterLoadouts:createSettingsFrame()
end

function CharacterLoadouts:OnInitialize()
   AceConsole:Print("<Character Loadouts> Character Loadouts addon has loaded!");
   --AceConsole:RegisterChatCommand("cls", "openSettings")
   CharacterLoadouts:openSettings()
end

function CharacterLoadouts:OnEnable()
   -- Called when the addon is enabled
end

function CharacterLoadouts:OnDisable()
   -- Called when the addon is disabled
end