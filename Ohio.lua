-- Ohio.
-- Variables
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
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
-- Item Farm
Farming:AddToggle("ItemFarm", {
    Text = "Item Farm",
    Default = false,
    Tooltip = "Picks Up Items",
})
Farming:AddToggle("CashFarm", {
    Text = "Cash Farm",
    Default = false,
    Tooltip = "Picks Up Cash",
})
Farming:AddToggle("ATMFarm", {
    Text = "ATM Farm",
    Default = false,
    Tooltip = "Farms ATMs (Equip Fist)",
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
        if v['model'] == ATM then
            GUID = v['guid']
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
                        Remotes['meleeHit']:FireServer('prop', Hit)
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
