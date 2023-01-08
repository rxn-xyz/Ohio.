-- Ohio. | Item Names
-- Total Items
local function TotalItems(Items)
    local Count = 0
    for i,v in pairs(Items) do
        if v:IsA("MeshPart") or v:IsA("Part") then
            Count = Count + 1
        end
    end
    return Count
end
-- Check Item
local function CheckItem(Item)
    -- Variables
    local FoundItem   = nil
    local CurrentItem = nil
    local Count       = 0
    local Items       = {}
    -- Items
    for i,v in pairs(Item:GetChildren()) do
        if not(v == Item.PrimaryPart or v.Parent == Item.PrimaryPart or v.ClassName == "SelectionBox") then
            local Part = {}
            if v:IsA("MeshPart") then
                table.insert(Part, "MeshId") table.insert(Part, "TextureID") table.insert(Part, "Size") table.insert(Part, "Color") table.insert(Part, "Material")
                Part.MeshId    = v.MeshId
                Part.TextureID = v.TextureID
                Part.Size      = v.Size
                Part.Color     = v.Color
                Part.Material  = v.Material
                table.insert(Items, Part)
            elseif v:IsA("Part") then
                table.insert(Part, "Color") table.insert(Part, "Size") table.insert(Part, "Material") 
                Part.Color    = v.Color
                Part.Size     = v.Size
                Part.Material = v.Material
                table.insert(Items, Part)
            end
        end
    end
    -- Check Items
    for a,b in pairs(game:GetService("ReplicatedStorage").Models.Items:GetChildren()) do
        if TotalItems(b:GetChildren()) == #Items then
            Count = 0
            for i,v in pairs(Items) do
                for c,d in pairs(b:GetChildren()) do
                    if d:IsA("MeshPart") then
                        if d.MeshId == v["MeshId"] and d.TextureID == v["TextureID"] and d.Size == v["Size"] and d.Color == v["Color"] and d.Material == v["Material"] then
                            Count = Count + 1
                            Potential = b.Name
                        end
                    elseif d:IsA("Part") then
                        if d.Color == v["Color"] and d.Size == v["Size"] and d.Material == v["Material"] then
                            Count = Count + 1
                            Potential = b.Name
                        end
                    end
                end
            end
        end
        if Count == #Items then
            FoundItem = Potential
            print(Count, #Items, FoundItem)
            return FoundItem
        end
    end
end
-- Rename
for i,v in pairs(Workspace.Game.Entities.ItemPickup:GetChildren()) do
    if CheckItem(v) then
        v.Name = CheckItem(v)
    end
end
Workspace.Game.Entities.ItemPickup.ChildAdded:Connect(function(Child)
    task.wait(1)
    if CheckItem(Child) then
        Child.Name = CheckItem(Child)
    end
end)
