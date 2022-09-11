-- [[ Variables ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player.Character
local Children = Character:GetChildren()
local Descendants = Character:GetDescendants()
Humanoid = Character:FindFirstChildOfClass("Humanoid")

Character.Animate.Disabled = true

if Humanoid.RigType == Enum.HumanoidRigType.R6 then
    R6 = true
end

for i,v in pairs(Character.Humanoid:GetPlayingAnimationTracks()) do
    v:Stop()
end

for i,v in pairs(Descendants) do
    if v:IsA("Motor6D") and v.Name ~= "Neck" and v.Name ~= "Waist" then
        v:Destroy()
    end
end

local rig = game:GetObjects("rbxassetid://5195737219")[1]
rig.Name = "Dummy"
rig.Parent = Character

rig.HumanoidRootPart.Anchored = false
workspace.CurrentCamera.CameraSubject = rig

rig.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame

function cf(part,rigpart,offset)
    --part.Velocity = Vector3.new(0,30,0)
    part.Velocity = Vector3.new(rig.HumanoidRootPart.CFrame.LookVector.X * 50, rig.HumanoidRootPart.Velocity.Y * 5, rig.HumanoidRootPart.CFrame.LookVector.Z * 50)
    if offset then
        part.CFrame = rigpart.CFrame * offset
    else
        part.CFrame = rigpart.CFrame
    end
end

Collision = RunService.Stepped:Connect(function()
    for i,v in pairs(Children) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

local offsets = {
    HumanoidRootPart={"HumanoidRootPart",CFrame.new(0,0,0)},
    RightUpperArm={"Right Arm",CFrame.new(0,0.45,0)},
    LeftUpperArm={"Left Arm",CFrame.new(0,0.45,0)},
    RightLowerArm={"Right Arm",CFrame.new(0,-0.15,0)},
    LeftLowerArm={"Left Arm",CFrame.new(0,-0.15,0)},
    RightHand={"Right Arm",CFrame.new(0,-0.8,0)},
    LeftHand={"Left Arm",CFrame.new(0,-0.8,0)},
    UpperTorso={"Torso",CFrame.new(0,0.25,0)},
    RightUpperLeg={"Right Leg",CFrame.new(0,0.6,0)},
    LeftUpperLeg={"Left Leg",CFrame.new(0,0.6,0)},
    RightLowerLeg={"Right Leg",CFrame.new(0,-0.15,0)},
    LeftLowerLeg={"Left Leg",CFrame.new(0,-0.15,0)},
    RightFoot={"Right Leg",CFrame.new(0,-0.8,0)},
    LeftFoot={"Left Leg",CFrame.new(0,-0.8,0)}
}

CFLoop = RunService.Heartbeat:Connect(function()
    if not rig then
        CFLoop:Disconnect()
        Collision:Disconnect()
    end
    rig.Humanoid.Jump = Humanoid.Jump
    rig.Humanoid:Move(Humanoid.MoveDirection)
    if R6 then
        cf(Character["Torso"],rig["Torso"])
        cf(Character["Left Arm"],rig["Left Arm"])
        cf(Character["Right Arm"],rig["Right Arm"])
        cf(Character["Left Leg"],rig["Left Leg"])
        cf(Character["Right Leg"],rig["Right Leg"])
    else
        for i,v in pairs(offsets) do
            cf(Character[i],rig[v[1]],v[2])
        end
    end
end)

if R6 then
    CAnimate = Character.Animate:Clone()
    CAnimate.Parent = rig
    CAnimate.Disabled = false
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Syntaxx64/ReanimationTutorial/main/Reanimation.lua"))()
end
