-- Ohio.
-- Variables
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Remotes
local Signals = require(ReplicatedStorage["devv-framework"].client.Helpers.remotes.Signal)
local Remotes = debug.getupvalue(Signals.FireServer, 1)
-- Item Names
local ItemNames = loadstring(game:HttpGet("https://raw.githubusercontent.com/rxn-xyz/ohio./main/ItemNames.lua",true))()
-- Repository
local Repository = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"
-- Library | Themes | Saves
local Library      = loadstring(game:HttpGet(Repository .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))()
-- Window
local Window = Library:CreateWindow({
    Title    = "Ohio.",
    Center   = true, 
    AutoShow = true,
})
-- Tabs
local Tabs = {
    ["Main"]        = Window:AddTab("Main"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
}
-- Player
local Player = Tabs["Main"]:AddLeftGroupbox("Player")
-- Noclip
Player:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Tooltip = "Enables Noclip",
})
-- Infinite Jump
Player:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
    Tooltip = "Enables Infinite Jump",
})
-- WalkSpeed
Player:AddToggle("WalkSpeed", {
    Text = "WalkSpeed",
    Default = false,
    Tooltip = "Enables WalkSpeed",
})
-- WalkSpeed
Player:AddSlider("WalkSpeed", {
    Text = "WalkSpeed",
    Default = 0.1,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Compact = false,
})
-- Godmode
local Godmode = Player:AddButton("Godmode", function()
    local Position, Character = Camera.CFrame, LocalPlayer.Character
    local Human = Character and Character.FindFirstChildWhichIsA(Character, "Humanoid")
    local NewHuman = Human.Clone(Human)
    NewHuman.Parent, LocalPlayer.Character = Character, nil
    NewHuman.SetStateEnabled(NewHuman, 15, false)
    NewHuman.SetStateEnabled(NewHuman, 1, false)
    NewHuman.SetStateEnabled(NewHuman, 0, false)
    NewHuman.BreakJointsOnDeath, Human = true, Human.Destroy(Human)
    LocalPlayer.Character, Camera.CameraSubject, Camera.CFrame = Character, NewHuman, wait() and Position
    NewHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    local Script = Character.FindFirstChild(Character, "Animate")
    if Script then
        Script.Disabled = true
        task.wait()
        Script.Disabled = false
    end
    NewHuman.Health = NewHuman.MaxHealth
end)
-- RemoveGodmode
local RemoveGodmode = Player:AddButton("Remove Godmode", function()
    local Character = LocalPlayer.Character
    if Character:FindFirstChildOfClass("Humanoid") then Character:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
    Character:ClearAllChildren()
    local NewCharacter = Instance.new("Model")
    NewCharacter.Parent = workspace
    LocalPlayer.Character = NewCharacter
    wait()
    LocalPlayer.Character = Character
    NewCharacter:Destroy()
end):AddTooltip("Removes Godmode But You Lose Your Items")
-- Combat
local Combat = Tabs["Main"]:AddLeftGroupbox("Combat")
-- One Shot
Combat:AddToggle("OneShot", {
    Text = "One Shot",
    Default = false,
    Tooltip = "One Shots With Every Melee Weapon",
})
-- Farming
local Farming = Tabs["Main"]:AddRightGroupbox("Farming")
-- Cash Farm
Farming:AddToggle("CashFarm", {
    Text = "Cash Farm",
    Default = false,
    Tooltip = "Picks Up Cash",
})
-- ATM Farm
Farming:AddToggle("ATMFarm", {
    Text = "ATM Farm",
    Default = false,
    Tooltip = "Farms ATMs (Equip Fist)",
})
-- Item Farm
Farming:AddToggle("ItemFarm", {
    Text = "Item Farm",
    Default = false,
    Tooltip = "Picks Up Items",
})
-- Item Selection Farm
Farming:AddToggle("ItemSelectionFarm", {
    Text = "Item Selection Farm",
    Default = false,
    Tooltip = "Picks Up The Selected Items",
})
-- Item Selection
local Models = {}
for i,v in pairs(game:GetService("ReplicatedStorage").Models.Items:GetChildren()) do
    if v.Name ~= 'test accessory' then
        table.insert(Models, v.Name)
    end
end
Farming:AddDropdown("ItemSelection", {
    Values = Models,
    Default = 0,
    Multi = true,
    Text = "Item Selection",
    Tooltip = "Select Items To Farm (Some Items Don't Spawn)",
})
-- Library functions
Library:OnUnload(function()
    print("Unloaded!")
    Library.Unloaded = true
end)
-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton("Unload", function() Library:Unload() end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "LeftAlt", NoUI = true, Text = "Menu keybind" }) 
Library.ToggleKeybind = Options.MenuKeybind
-- Themes | Saves
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
-- Saves
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ "MenuKeybind" }) 
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:BuildConfigSection(Tabs["UI Settings"]) 
-- Themes
ThemeManager:ApplyToTab(Tabs["UI Settings"]) 
local function Collect(Object)
    for i,v in pairs(Object:GetDescendants()) do
        if v:FindFirstChildOfClass("ClickDetector") then
            fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
        end
    end
end
-- Noclip | Toggle
Toggles["Noclip"]:OnChanged(function()
    local Noclip = game:GetService("RunService").Stepped:Connect(function()
        if Toggles["Noclip"].Value then
            for i,v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
    if not Toggles["Noclip"].Value then
        Noclip:Disconnect()
    end
end)
-- Infinite Jump | Toggle
Toggles["InfiniteJump"]:OnChanged(function()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if Toggles["InfiniteJump"].Value then
            pcall(function()
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end)
        end
    end)
end)
-- WalkSpeed | Toggle
Toggles["WalkSpeed"]:OnChanged(function()
    task.spawn(function()
        while Toggles["WalkSpeed"].Value do task.wait()
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * Options["WalkSpeed"].Value
            end)
        end
    end)
end)
-- Cash Farm | Toggle
Toggles["CashFarm"]:OnChanged(function()
    task.spawn(function()
        while Toggles["CashFarm"].Value do task.wait()
            for i,v in pairs(Workspace.Game.Entities.CashBundle:GetChildren()) do
                if not Toggles["CashFarm"].Value then break end
                if v.PrimaryPart then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
                    fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                end
            end
        end
    end)
end)
-- ATM Farm | Setup
local Load  = require(game:GetService("ReplicatedStorage")["devv-framework"].datum).load
local State = Load("State")
local function GetGUID(ATM)
    local GUID = nil
    for i,v in pairs(State.worldPropsByGUID) do
        if v["model"] == ATM then
            GUID = v["guid"]
        end
    end
    return GUID
end
for i,v in pairs(Workspace.Game.Props.ATM:GetChildren()) do
    v.Name = GetGUID(v)
end
Workspace.Game.Props.ATM.ChildAdded:Connect(function(Item)
    task.wait(2)
    if GetGUID(Item) then
        Item.Name = GetGUID(Item)
    end
end)
-- ATM Farm | Toggle
Toggles["ATMFarm"]:OnChanged(function()
    if Toggles["ATMFarm"].Value then
        if Toggles["OneShot"].Value then
            Toggles["OneShot"]:SetValue(false)
        end
    end
    task.spawn(function()
        while Toggles["ATMFarm"].Value do task.wait()
            for i,v in pairs(Workspace.Game.Props.ATM:GetChildren()) do
                if not Toggles["ATMFarm"].Value then break end
                if v:GetAttribute("state") ~= "destroyed" then 
                    repeat task.wait()
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
                        local Hit = {
                            ["meleeType"] = "punch",
                            ["guid"] = GetGUID(v)
                        }
                        Remotes["meleeHit"]:FireServer("prop", Hit)
                        for i,v in pairs(Workspace.Game.Entities.CashBundle:GetChildren()) do
                            if (LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <= 15 then
                                fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                            end
                        end
                    end)
                    until v:GetAttribute("state") == "destroyed" or not Toggles["ATMFarm"].Value
                    task.wait(2)
                    pcall(function()
                        for i,v in pairs(Workspace.Game.Entities.CashBundle:GetChildren()) do
                            if (LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <= 15 then
                                fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                            end
                        end
                    end)
                end
            end
        end
    end)
end)
-- Item Farm | Toggle
Toggles["ItemFarm"]:OnChanged(function()
    task.spawn(function()
        while Toggles["ItemFarm"].Value do task.wait()
            for i,v in pairs(Workspace.Game.Entities.ItemPickup:GetChildren()) do
                if not Toggles["ItemFarm"].Value then break end
                if v:FindFirstChildOfClass("Part") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChildOfClass("Part").CFrame task.wait(0.5) Collect(v) task.wait(0.1)
                    continue
                end
            end
        end
    end)
end)
-- Item Selection Farm | Toggle
Toggles["ItemSelectionFarm"]:OnChanged(function()
    task.spawn(function()
        while Toggles["ItemSelectionFarm"].Value do task.wait()
            for i,v in pairs(Workspace.Game.Entities.ItemPickup:GetChildren()) do
                if not Toggles["ItemSelectionFarm"].Value then break end
                if v:FindFirstChildOfClass("Part") and Options['ItemSelection'].Value[v.Name] then
                    if v:FindFirstChildOfClass("Part") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChildOfClass("Part").CFrame task.wait(0.5) Collect(v) task.wait(0.1)
                        continue
                    end
                end
            end
        end
    end)
end)
-- One Shot | Toggle
local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Arugments  =  {...}
    local Method     =  getnamecallmethod()
    if Method == "FireServer" and Self == Remotes["meleeHit"] then
        if Toggles["OneShot"].Value then
            if Arugments[2]["meleeType"] == "kick" then
                Arugments[2]["meleeType"] = "megapunch"
            end
            if not string.match(tostring(Arugments[2]["meleeType"]), "mega") then
                Arugments[2]["meleeType"] = "mega"..tostring(Arugments[2]["meleeType"])
            end
        end
        return OldNameCall(Self, unpack(Arugments))
    end
    return OldNameCall(Self, ...)
end)
