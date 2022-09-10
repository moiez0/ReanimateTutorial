-- [[ Variables ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
Player = Players.LocalPlayer
Character = Player.Character
Humanoid = Character:FindFirstChildOfClass("Humanoid")

Character.Animate.Disabled = true

if Humanoid.RigType == Enum.HumanoidRigType.R6 then
    Character["Torso"]:FindFirstChild("Right Shoulder"):Destroy()
    Character["Torso"]:FindFirstChild("Left Shoulder"):Destroy()
    Character["Torso"]:FindFirstChild("Right Hip"):Destroy()
    Character["Torso"]:FindFirstChild("Left Hip"):Destroy()
    Character["HumanoidRootPart"]:FindFirstChild("RootJoint"):Destroy()
end

local rig = game:GetObjects("rbxassetid://5195737219")[1]
rig.Name = "Dummy"
rig.Parent = Character

rig.HumanoidRootPart.Anchored = false
workspace.CurrentCamera.CameraSubject = rig

rig.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame

function cf(part,rigpart)
    part:ApplyImpulse(Vector3.new(0,50,0))
    --part.Velocity = Vector3.new(0,30,0)
    part.CFrame = rigpart.CFrame
end

Collision = RunService.Stepped:Connect(function()
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

CFLoop = RunService.Heartbeat:Connect(function()
    if not rig then
        CFLoop:Disconnect()
        Collision:Disconnect()
    end
    rig.Humanoid.Jump = Humanoid.Jump
    rig.Humanoid:Move(Humanoid.MoveDirection)
    cf(Character["Torso"],rig["Torso"])
    cf(Character["Left Arm"],rig["Left Arm"])
    cf(Character["Right Arm"],rig["Right Arm"])
    cf(Character["Left Leg"],rig["Left Leg"])
    cf(Character["Right Leg"],rig["Right Leg"])
end)

CAnimate = Character.Animate:Clone()
CAnimate.Parent = rig
CAnimate.Disabled = false
