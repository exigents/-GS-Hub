local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local EzExp = loadstring(game:HttpGet("https://raw.githubusercontent.com/exigents/EzVars-Exploit-Helper/main/EzVars.lua"))()

--// Vars
local Player = EzExp.Players.LocalPlayer.Player
local SkillToggle = EzExp.Objects:FindFirstChild(nil, "SkillToggle", "RemoteEvent", "ReplicatedStorage")
local Weight = EzExp.Objects:FindFirstChild(nil, "Weight", "RemoteEvent", "ReplicatedStorage")
local CombatFolder = EzExp.Objects:FindFirstChild(nil, "CombatFolder", "Folder", "ReplicatedStorage")
local CombatEvent = EzExp.Objects:FindFirstChild(CombatFolder, "RemoteEvent", "RemoteEvent", nil)
local EnterCode = EzExp.Objects:FindFirstChild(nil, "EnterCode", "RemoteFunction", "ReplicatedStorage")
local BuyZone = EzExp.Objects:FindFirstChild(nil, "BuyZone", "RemoteEvent", "ReplicatedStorage")
local SpinWheelEvent = EzExp.Objects:FindFirstChild(nil, "Spin Wheel", "RemoteEvent", "ReplicatedStorage")
local HatchEgg = EzExp.Objects:FindFirstChild(nil, "HatchEgg", "RemoteFunction", "ReplicatedStorage")
local Rebirth = EzExp.Objects:FindFirstChild(nil, "Rebirth", "RemoteEvent", "ReplicatedStorage")
local PetAction = EzExp.Objects:FindFirstChild(nil, "PetAction", "RemoteFunction", "ReplicatedStorage")
local DropMuscle = EzExp.Objects:FindFirstChild(nil, "DropMuscle", "BasePart", "ReplicatedStorage")
local Configs = EzExp.Objects:FindFirstChild(nil, "Configs", "Configuration", "ReplicatedStorage")
local AuraFolder = EzExp.Objects:FindFirstChild(nil, "Auras", "Folder", "ReplicatedStorage")
local Aura = EzExp.Objects:FindFirstChild(nil, "Aura", "RemoteEvent", "ReplicatedStorage")
local Spawns = EzExp.Objects:FindFirstChild(nil, "Spawns", "Folder", "Workspace")
local AutoDeletePets = EzExp.Objects:FindFirstChild(nil, "AutoDelete", "RemoteFunction", "ReplicatedStorage")

local PlayerData = EzExp.Objects:FindFirstChild(Player, "Data", "Folder", nil)
local WeightVal = EzExp.Objects:FindFirstChild(PlayerData, "Weight", "StringValue", nil)
local PlayerAuras = EzExp.Objects:FindFirstChild(Player, "Aura", "Folder", nil)

--// Modules Vars
local ACODES = EzExp.Objects:FindFirstChild(nil, "ActiveCodes", "ModuleScript", "ReplicatedStorage")
local ActiveCodes = require(ACODES)
local ToolsM = EzExp.Objects:FindFirstChild(nil, "Tools", "ModuleScript", "ReplicatedStorage")
local ToolsModule = require(ToolsM)
local AurasM = EzExp.Objects:FindFirstChild(nil, "Auras", "ModuleScript", "ReplicatedStorage")
local AurasModule = require(AurasM)
local UpgradesM = EzExp.Objects:FindFirstChild(nil, "Upgrades", "ModuleScript", "ReplicatedStorage")
local UpgradesModule = require(UpgradesM)
local DropM = EzExp.Objects:FindFirstChild(nil, "Drop", "ModuleScript", "ReplicatedStorage")
local DropModule = require(DropM)
local EggsM = EzExp.Objects:FindFirstChild(Configs, "Eggs", "ModuleScript", nil)
local EggsModule = require(EggsM)
local PetsM = EzExp.Objects:FindFirstChild(Configs, "Pets", "ModuleScript", nil)
local PetsModule = require(PetsM)

for Egg, Data in pairs(EggsModule) do
	Data.required = function(p1)
		return true
	end
end

--// Settings
local Settings = {
	AutoWeight = false,
	AutoCombat = false,
	AutoRebirth = false,
	AutoBest = false,
	AutoCraft = false,
	AutoEgg = false,
	AutoDrop = false,
	AutoAura = false,
}

local Zones = {}
local Spawnss = {}
local Eggs = {}
local Auras = {}
local Pets = {}
local PetIds = {}
local EggChosen = "Basic"
local EggAmount = 1

for Id, Data in pairs(PetsModule) do
	table.insert(Pets, Data.display)
end

for Id, Data in pairs(PetsModule) do
	PetIds[Data.display] = tostring(Id)
end

for Egg, Data in pairs(EggsModule) do
	table.insert(Eggs, tostring(Egg))
end

for i, v in pairs(AuraFolder:GetChildren()) do
	table.insert(Auras, v.Name)
end

local ZonePositions = {}

for i,v in pairs(Spawns:GetChildren()) do
	table.insert(Spawnss, v.Name)
end

for i, v in pairs(Spawns:GetChildren()) do
	ZonePositions[v.Name] = v.CFrame
end

for _, v in pairs(workspace:GetChildren()) do
	if v:IsA("BasePart") then
		if string.match(v.Name, "Buy") ~= nil then
			table.insert(Zones, string.split(v.Name, "Buy")[1])
			print(string.split(v.Name, "Buy")[1])
		end
	end
end

--// Main
local Window = Rayfield:CreateWindow({
	Name = "[GS] Hub",
	LoadingTitle = "Welcome to [GS] Hub!",
	LoadingSubtitle = "by Grave Society",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "[GS] Hub", -- Create a custom folder for your hub/game
		FileName = "[GS] Hub"
	},
	Discord = {
		Enabled = true,
		Invite = "fj8hfEaTD3", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	},
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "[GS] Hub",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided",
		FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"TestKey1"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local AutoTab = Window:CreateTab("Auto", nil)
local EggTab = Window:CreateTab("Eggs", nil)
local AuraTab = Window:CreateTab("Auras", nil)
local PetTab = Window:CreateTab("Pets", nil)
local LocationsTab = Window:CreateTab("Locations", nil)
local HumanoidTab = Window:CreateTab("Humanoid", nil)
local MiscTab = Window:CreateTab("Misc", nil)

--// Misc Funcs
function compareAura(Aura1, Aura2)
	if AurasModule[Aura2].Multiplier > AurasModule[Aura1].Multiplier then
		return true
	end
	return false
end

function OwnsAura(Aura)
	local Owned = false
	
	for i,v in pairs(PlayerAuras:GetChildren()) do
		if v.Name == Aura then
			if v.Value == true then
				Owned = true
			end
		end
	end
	
	return Owned
end

--// AUTO TAB
local AutoWeight = AutoTab:CreateToggle({
	Name = "Auto Weight",
	CurrentValue = false,
	Flag = "AutoWeight1",
	Callback = function(Value)
		Settings.AutoWeight = Value
		if Value == true then
			Settings.AutoCombat = false
		end
	end,
})

local AutoCombat = AutoTab:CreateToggle({
	Name = "Auto Combat",
	CurrentValue = false,
	Flag = "AutoCombat1",
	Callback = function(Value)
		Settings.AutoCombat = Value
		if Value == true then
			Settings.AutoWeight = false
		end
	end,
})

local AutoRebirth = AutoTab:CreateToggle({
	Name = "Auto Rebirth",
	CurrentValue = false,
	Flag = "AutoRebirth1",
	Callback = function(Value)
		Settings.AutoRebirth = true
	end,
})

local AutoDrop = AutoTab:CreateToggle({
	Name = "Auto Drops",
	CurrentValue = false,
	Flag = "AutoDropToggle1",
	Callback = function(Value)
		Settings.AutoDrop = Value
	end,
})

--// Aura Tab
local AuraDrop = AuraTab:CreateDropdown({
	Name = "Buy Auras",
	Options = Auras,
	CurrentOption = {"Smoke"},
	MultipleOptions = false,
	Flag = "AuraDropDown1",
	Callback = function(Options)
		Aura:FireServer("Unlock", Options[1])
	end,
})

local AutoEqBestAura = AuraTab:CreateToggle({
	Name = "Auto Equip Best",
	CurrentValue = false,
	Flag = "AutoEquipAura1",
	Callback = function(Value)
		Settings.AutoAura = Value
	end,
})

--// Egg Tab
local EggsDrop = EggTab:CreateDropdown({
	Name = "Egg Type",
	Options = Eggs,
	CurrentOption = {EggChosen},
	MultipleOptions = false,
	Flag = "EggsDropDown1",
	Callback = function(Options)
		EggChosen = Options[1]
	end,
})

local AutoDelete = EggTab:CreateDropdown({
	Name = "Auto Delete",
	Options = Pets,
	CurrentOption = {"Cat"},
	MultipleOptions = true,
	Flag = "AutoDeleteDropdown1",
	Callback = function(Options)
		for i, Opt in pairs(Options) do
			AutoDeletePets:InvokeServer(PetIds[Opt])
		end
	end,
})

local EggAmnt = EggTab:CreateSlider({
	Name = "Egg Amount",
	Range = {1, 3},
	Increment = 2,
	Suffix = nil,
	CurrentValue = 1,
	Flag = "EggAmountSlider1",
	Callback = function(Value)
		EggAmount = Value
	end,
})

EggTab:CreateToggle({
	Name = "Auto Open Egg",
	CurrentValue = false,
	Flag = "AutoOpenEggToggle",
	Callback = function(Value)
		Settings.AutoEgg = Value
	end,
})

--// Location Tab
local BuyArea = LocationsTab:CreateDropdown({
	Name = "Buy areas",
	Options = Zones,
	CurrentOption = {"Jungle"},
	MultipleOptions = false,
	Flag = "BuyAreaDropDown1",
	Callback = function(Options)
		for _, Zone in pairs(Options) do
			BuyZone:FireServer(tostring(Zone))
		end
	end,
})

local TeleportTo = LocationsTab:CreateDropdown({
	Name = "Teleport To Area",
	Options = Spawnss,
	CurrentOption = {"Spawn"},
	MultipleOptions = false,
	Flag = "TeleportZoneDropdown1",
	Callback = function(Option)
		local Opt = Option[1]
		Player.Character:SetPrimaryPartCFrame(ZonePositions[Opt])
	end,
})

--// Pet Tab
PetTab:CreateToggle({
	Name = "Auto Equip Best",
	CurrentValue = false,
	Flag = "AutoEquipBest1",
	Callback = function(Value)
		Settings.AutoBest = Value
	end,
})

PetTab:CreateToggle({
	Name = "Auto Craft All",
	CurrentValue = false,
	Flag = "AutoCraftAll1",
	Callback = function(Value)
		Settings.AutoCraft = Value
	end,
})

--// HUMANOID TAB
local WSS = HumanoidTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {1, 100},
	Increment = 1,
	Suffix = nil,
	CurrentValue = 16,
	Flag = "WalkSpeedSlider",
	Callback = function(Number)
		Player.Character:FindFirstChild("Humanoid").WalkSpeed = tonumber(Number)
	end,
})

local JPS = HumanoidTab:CreateSlider({
	Name = "JumpPower",
	Range = {1, 100},
	Increment = 1,
	Suffix = nil,
	CurrentValue = 50.15,
	Flag = "JumpPowerSlider1",
	Callback = function(Number)
		Player.Character:FindFirstChild("Humanoid").JumpHeight = tonumber(Number)
	end,
})


--// MISC TAB
local RedeemCodes = MiscTab:CreateButton({
	Name = "Redeem all codes",
	Callback = function()
		for Code, d in pairs(ActiveCodes) do
			EnterCode:InvokeServer(tostring(Code))
		end
	end,
})

local SpinWheel = MiscTab:CreateButton({
	Name = "Spin wheel",
	Callback = function()
		SpinWheelEvent:FireServer()
	end,
})

--// Loop
coroutine.resume(coroutine.create(function()
	while task.wait(0.5) do
		if Settings.AutoWeight then
			SkillToggle:FireServer("NumberOne", true)
			Weight:FireServer(WeightVal.Value)
		elseif Settings.AutoWeight == false and Settings.AutoCombat then
			AutoWeight:Set(false)
		end
		if Settings.AutoCombat then
			SkillToggle:FireServer("NumberTwo", true)
			CombatEvent:FireServer("Left")
			CombatEvent:FireServer("Right")	
		elseif Settings.AutoCombat == false and Settings.AutoWeight then
			AutoCombat:Set(false)
		end
		if Settings.AutoRebirth then
			Rebirth:FireServer()
		end
		if Settings.AutoBest then
			PetAction:InvokeServer("Equip Best")
		end
		if Settings.AutoCraft then
			PetAction:InvokeServer("Craft All")
		end
		if Settings.AutoEgg then
			HatchEgg:InvokeServer(EggChosen, EggAmount)
		end
		if Settings.AutoDrop then
			DropModule.DropCurrency(Player.Character.PrimaryPart.CFrame, DropMuscle, 1)
		end
		if Settings.AutoAura then
			for i, v in pairs(Auras) do
				if OwnsAura(v) then
					if i == 1 then
						Aura:FireServer("Equip", v)
					else
						if compareAura(Auras[i-1], v) then
							Aura:FireServer("Equip", v)
						end
					end
				end
			end
		end
	end
end))
