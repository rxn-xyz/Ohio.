-- Ohio.
-- Variables
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Remotes
local Signals = require(ReplicatedStorage["devv-framework"].client.Helpers.remotes.Signal)
local Remotes = debug.getupvalue(Signals.FireServer, 1)
-- Item Names | Users
local ItemNames = loadstring(game:HttpGet("https://raw.githubusercontent.com/rxn-xyz/Ohio./main/ItemNames.lua",true))()
local Users = loadstring(game:HttpGet("https://raw.githubusercontent.com/rxn-xyz/Ohio./main/Users.lua",true))()
-- Sort
local function Sort(Table)
    table.sort(Table, function(a,b)
        return a:lower() < b:lower()
    end)
    return Table
end
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
-- ATM Farm
Farming:AddToggle("ATMFarm", {
    Text = "ATM Farm",
    Default = false,
    Tooltip = "Farms ATMs (Equip Fist)",
})
-- Register Farm
Farming:AddToggle("RegisterFarm", {
    Text = "Register Farm",
    Default = false,
    Tooltip = "Farms Cash Registers (Equip Fist)",
})
-- Bank Farm
Farming:AddToggle("BankFarm", {
    Text = "Bank Farm",
    Default = false,
    Tooltip = "Farms The Bank",
})
-- Cash Farm
Farming:AddToggle("CashFarm", {
    Text = "Cash Farm",
    Default = false,
    Tooltip = "Picks Up Cash",
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
function GetItems()
    local Items = {}
    for i,v in pairs(Workspace.ItemSpawns.items:GetChildren()) do
        table.insert(Items, v.Name)
    end
    return Sort(Items)
end
Farming:AddDropdown("ItemSelection", {
    Values = GetItems(),
    Default = 0,
    Multi = true,
    Text = "Item Selection",
    Tooltip = "Select Items To Farm",
})
-- Clear Selection
local ClearSelection = Farming:AddButton("Clear Selection", function()
    Options["ItemSelection"].Value = {}
    Options["ItemSelection"]:SetValue({})
end)
-- Teleports
local Teleports = Tabs["Main"]:AddLeftGroupbox("Teleports")
-- Player Teleport
Teleports:AddDropdown("TeleportsPlayerDropdown", {
    Values = {},
    Default = 0,
    Multi = false,
    Text = "Player Teleport",
    Tooltip = "Teleports To The Selected Player",
    AllowNull = true
})
-- Player Teleport
function GetShops()
    local Shops = {}
    for i,v in pairs(Workspace.ItemsOnSale:GetChildren()) do
        if not table.find(Shops, v.Name) then
            table.insert(Shops, v.Name)
        end
    end
    return Sort(Shops)
end
Teleports:AddDropdown("ShopsDropdown", {
    Values = GetShops(),
    Default = 0,
    Multi = false,
    Text = "Shops Teleport",
    Tooltip = "Teleports To The Selected Shop",
    AllowNull = true
})
-- Kill Aura
local KillAura = Tabs["Main"]:AddRightGroupbox("Kill Aura")
-- Stomp Aura
KillAura:AddToggle("StompAura", {
    Text = "Stomp Aura",
    Default = false,
    Tooltip = "Stomps Everyone Around You",
})
-- Kill Aura
KillAura:AddToggle("KillAura", {
    Text = "Kill Aura",
    Default = false,
    Tooltip = "Knocks Everyone Around You (Equip Fist)",
})
-- Kill Aura Instant
KillAura:AddToggle("KillAuraInstant", {
    Text = "Kill Aura Instant",
    Default = false,
    Tooltip = "Knocks Everyone Around You (Equip Fist)",
})
-- Kill Aura Whitelist
KillAura:AddDropdown("WhitelistPlayerDropdown", {
    Values = {},
    Default = 0,
    Multi = true,
    Text = "Whitelist Player",
    Tooltip = "Whitelist The Selected Players",
    AllowNull = true
})
-- Clear Whitelist
local ClearWhitelist = KillAura:AddButton("Clear Whitelist", function()
    Options["WhitelistPlayerDropdown"].Value = {}
    Options["WhitelistPlayerDropdown"]:SetValue({})
end)
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
                                ["meleeType"] = "punch", ["guid"] = v:GetAttribute("guid")
                            }
                            Remotes["meleeHit"]:FireServer("prop", Hit)
                            for i,v in pairs(Workspace.Game.Entities.CashBundle:GetDescendants()) do
                                if v:IsA("TouchTransmitter") then
                                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude <= 15 then
                                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                                    end
                                end
                            end
                        end)
                    until v:GetAttribute("state") == "destroyed" or not Toggles["ATMFarm"].Value
                    task.wait(1)
                    pcall(function()
                        for i,v in pairs(Workspace.Game.Entities.CashBundle:GetDescendants()) do
                            if v:IsA("TouchTransmitter") then
                                if (LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude <= 15 then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)
end)
-- Register Farm | Toggle
Toggles["RegisterFarm"]:OnChanged(function()
    if Toggles["RegisterFarm"].Value then
        if Toggles["OneShot"].Value then
            Toggles["OneShot"]:SetValue(false)
        end
    end
    task.spawn(function()
        while Toggles["RegisterFarm"].Value do task.wait()
            for i,v in pairs(Workspace.Game.Props.CashRegister:GetChildren()) do
                if not Toggles["RegisterFarm"].Value then break end
                if v:GetAttribute("state") ~= "destroyed" then 
                    repeat task.wait()
                        pcall(function()
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
                            local Hit = {
                                ["meleeType"] = "punch", ["guid"] = v:GetAttribute("guid")
                            }
                            Remotes["meleeHit"]:FireServer("prop", Hit)
                            for i,v in pairs(Workspace.Game.Entities.CashBundle:GetDescendants()) do
                                if v:IsA("TouchTransmitter") then
                                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude <= 15 then
                                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                                    end
                                end
                            end
                        end)
                    until v:GetAttribute("state") == "destroyed" or not Toggles["RegisterFarm"].Value
                    task.wait(1)
                    pcall(function()
                        for i,v in pairs(Workspace.Game.Entities.CashBundle:GetDescendants()) do
                            if v:IsA("TouchTransmitter") then
                                if (LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude <= 15 then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)
end)
-- Bank Farm | Toggle
Toggles["BankFarm"]:OnChanged(function()
    task.spawn(function()
        while Toggles["BankFarm"].Value do task.wait()
            if #Workspace.BankRobbery.BankCash.Cash:GetChildren() > 0 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Workspace.BankRobbery.BankCash.Pallet.CFrame
                fireproximityprompt(Workspace.BankRobbery.BankCash.Main.Attachment.ProximityPrompt)
            end
        end
    end)
end)
-- Cash Farm | Toggle
Toggles["CashFarm"]:OnChanged(function()
    task.spawn(function()
        while Toggles["CashFarm"].Value do task.wait()
            for i,v in pairs(Workspace.Game.Entities.CashBundle:GetDescendants()) do
                if not Toggles["CashFarm"].Value then break end
                if v:IsA("TouchTransmitter") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
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
                    LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChildOfClass("Part").CFrame task.wait(0.5) Collect(v) task.wait(0.1) continue
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
                if v:FindFirstChildOfClass("Part") and Options["ItemSelection"].Value[v.Name] then
                    if v:FindFirstChildOfClass("Part") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChildOfClass("Part").CFrame task.wait(0.5) Collect(v) task.wait(0.1) continue
                    end
                end
            end
        end
    end)
end)
-- Player Teleport | Toggle
Options['TeleportsPlayerDropdown']:OnChanged(function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Options['TeleportsPlayerDropdown'].Value].Character.HumanoidRootPart.CFrame
        Options['TeleportsPlayerDropdown']:SetValue(nil)
    end)
end)
-- Shops Teleport | Toggle
Options['ShopsDropdown']:OnChanged(function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = Workspace.ItemsOnSale[Options['ShopsDropdown'].Value].Button.CFrame
        Options['ShopsDropdown']:SetValue(nil)
    end)
end)
-- Stomp Aura | Toggle
Toggles["StompAura"]:OnChanged(function()
    task.spawn(function()
        while Toggles["StompAura"].Value do task.wait()
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    if not Options["WhitelistPlayerDropdown"].Value[v.Name] and not table.find(Users, string.reverse(tostring(v.UserId))) then
                        pcall(function()
                            if v.Character.grabPrompt.Enabled then
                                local Distance = LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)
                                if Distance < 20 then
                                    Remotes['stompPlayer']:FireServer(v)
                                end
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
-- Kill Aura | Toggle
Toggles["KillAura"]:OnChanged(function()
    if Toggles["KillAura"].Value then
        if Toggles["KillAuraInstant"].Value then
            Toggles["KillAuraInstant"]:SetValue(false)
        end
    end
    task.spawn(function()
        while Toggles["KillAura"].Value do task.wait()
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    if not Options["WhitelistPlayerDropdown"].Value[v.Name] and not table.find(Users, string.reverse(tostring(v.UserId))) then
                        pcall(function()
                            if not v.Character.grabPrompt.Enabled then
                                local Distance = LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)
                                if Distance < 20 then
                                    local Hit = {
                                        ["meleeType"] = "punch", ["hitPlayerId"] = v.UserId
                                    }
                                    Remotes["meleeHit"]:FireServer("player", Hit)
                                end
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
-- Kill Aura Instant | Toggle
Toggles["KillAuraInstant"]:OnChanged(function()
    if Toggles["KillAuraInstant"].Value then
        if Toggles["KillAura"].Value then
            Toggles["KillAura"]:SetValue(false)
        end
    end
    task.spawn(function()
        while Toggles["KillAuraInstant"].Value do task.wait()
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    if not Options["WhitelistPlayerDropdown"].Value[v.Name] and not table.find(Users, string.reverse(tostring(v.UserId))) then
                        pcall(function()
                            if not v.Character.grabPrompt.Enabled then
                                local Distance = LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)
                                if Distance < 20 then
                                    local Hit = {
                                        ["meleeType"] = "megapunch", ["hitPlayerId"] = v.UserId
                                    }
                                    Remotes["meleeHit"]:FireServer("player", Hit)
                                end
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
-- One Shot | Toggle
Toggles["OneShot"]:OnChanged(function()
    if Toggles["OneShot"].Value then
        for i,v in pairs(Toggles) do
            if string.match(i, "KillAura") then
                if v.Value then
                    v:SetValue(false)
                end
            end
        end
    end
end)
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
-- Refresh Players
function RefreshPlayers()
    local PlayerList = {}
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(PlayerList, v.Name)
        end
    end
    for i,v in pairs(Options) do
        if string.match(i, "PlayerDropdown") then
            v.Values = Sort(PlayerList)
	        v:SetValues()
            if typeof(v.Value) == "table" then
                for Selection,_ in pairs(v.Value) do
                    if table.find(PlayerList, Selection) then continue else
                        table.remove(v.Value, table.find(v.Value, Selection))
                        v:SetValue(v.Value)
                    end
                end
            elseif typeof(v.Value) == "string"then
                if table.find(PlayerList, v.Value) then
                    v:SetValue(v.Value)
                else
                    print(unpack(PlayerList))
                    v:SetValue(nil)
                end
            end
        end
    end
end
RefreshPlayers()
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)