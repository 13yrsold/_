getgenv().Tick = tick()

if not getgenv()['Coryu_Camlock'] then
    getgenv()['Coryu_Camlock'] = true
getgenv().Users = game:GetService'Players'
getgenv().Client = Users.LocalPlayer
getgenv().CoreGui = game:GetService'CoreGui'
getgenv().UserInputService = game:GetService'UserInputService'
getgenv().gethttp_1 = game:GetService'HttpService'
getgenv().Run = game:GetService'RunService'
getgenv().WorkSpace = game:GetService'Workspace'
getgenv().Camera = WorkSpace.CurrentCamera
getgenv().Mouse = Client:GetMouse()
getgenv().UserNotifications = function(T,E) game:GetService'StarterGui':SetCore('SendNotification', {Title = T; Text = E;}) end

local Arg = {Color3.fromRGB(99, 66, 245); Enum.Font.Code;}
local Camlock = false
local CamlockTarget;
local Commands = {}
local CoryuCamlock;
local Prefix = '-'

local Settings = {
    ['Hotkeys'] = {
        ['Camlock'] = 'C';
        ['KillNotes'] = 'P';
    };
    ['Parts'] = {
        ['HumanoidRootPart'] = 'HumanoidRootPart';
        ['Torso'] = 'Torso';
        ['Head'] = 'Head';
        ['UpperTorso'] = 'UpperTorso';
        ['LowerTorso'] = 'LowerTorso';
    };
    ['Modes'] = { --ill make this customizable when i can actually use an executor, I just free handed this entire script
        ['Stepped'] = true;
        ['RenderStepped'] = false;
        ['Heartbeat'] = false;
    };
}

for _,v in pairs(CoreGui.RobloxGui.NotificationFrame:GetDescendants()) do
    if tostring(v) == 'Notification' then
        v.NotificationText.TextColor3 = Arg[1]
        v.NotificationTitle.TextColor3 = Arg[1]
    end
end

if Client.Character:FindFirstChild('UpperTorso') then
    CamlockedPart = Settings['Parts']['UpperTorso']
elseif Client.Character:FindFirstChild('Torso') then
    CamlockedPart = Settings['Parts']['Torso']
end

_G.Version = 1.3

if not _G.Version == 1.3 then
    UserNotifications('Internal Error', 'Camlock is out of date! For further support contact Coryu @killserver' Button1 = 'Okay!')
end

if not makefolder or readfile or writefile then
    UserNotifications('External Error', 'Sorry!, your executer is non-compatiable')
end

if isfolder('Coryu') == nil then
    makefolder('Coryu')
elseif isfolder('Coryu') ~= nil then
    return nil
end

ypcall(function()
    CoryuCamlock = readfile('Coryu/CoryuCamlock.js')
end)

if CoryuCamlock then
    CoryuCamlock = gethttp_1:JSONDecode(readfile'Coryu/CoryuCamlock.js')
    for i,v in next, Settings do
        Settings[i] = CoryuCamlock[i]
    end
    writefile('Coryu/CoryuCamlock.js', gethttp_1:JSONEncode(Settings))
else
    CoryuCamlock = writefile('Coryu/CoryuCamlock.js', gethttp_1:JSONEncode(Settings))
end

local function writedata()
    if writefile and readfile and makefolder then
        writefile('Coryu/CoryuBlink.js', Http:JSONEncode(File))
    else
        return nil
    end
end

UserInputService.InputBegan:Connect(function(Args, Kill)
    if Kill then 
        return nil
    end
    if Args.KeyCode == Enum.KeyCode[Settings['Hotkeys']['Camlock']] then
        Camlock = not Camlock
        UserNotifications('Coryu', 'Camlock is now '..tostring(Camlock))
    end
    if Args.KeyCode == Enum.KeyCode[Settings['Hotkeys']['KillNotes']] then
        for _,v in pairs(CoreGui.RobloxGui.NotificationFrame:GetDescendants()) do
            if v:FindFirstChild'Notification' then
                Notification.Visible = not Notification.Visible
            end
        end
        if CoreGui.RobloxGui.NotificationFrame:FindFirstChild'Notification'.Visible then
            UserNotifications('Notifications', 'Notifications are now true')
        end  
    end
end)

Run.Stepped:Connect(function()
    if Settings['Modes']['Stepped'] then
        Run.Stepped:Connect(function()
            if Camlock and CamlockTarget and CamlockTarget.Character and CamlockTarget.Character:FindFirstChild(CamlockedPart) then
                Camera.CFrame = CFrame.new(Camera.CFrame.p, CamlockTarget.Character:FindFirstChild(CamlockedPart).CFrame.p)
            else
                return nil
            end
        end)
    end
    if Settings['Modes']['RenderStepped'] then
        Run.RenderStepped:Connect(function()
            if Camlock and CamlockTarget and CamlockTarget.Character and CamlockTarget.Character:FindFirstChild(CamlockedPart) then
                Camera.CFrame = CFrame.new(Camera.CFrame.p, CamlockTarget.Character:FindFirstChild(CamlockedPart).CFrame.p)
            else
                return nil
            end
        end)
    end
    if Settings['Modes']['Heartbeat'] then
        Run.Heartbeat:Connect(function()
            if Camlock and CamlockTarget and CamlockTarget.Character and CamlockTarget.Character:FindFirstChild(CamlockedPart) then
                Camera.CFrame = CFrame.new(Camera.CFrame.p, CamlockTarget.Character:FindFirstChild(CamlockedPart).CFrame.p)
            else
                return nil
            end
        end)
    end
end)

if Camlock then
    Mouse.Button1Down:Connect(function()
        if Mouse.Target or Mouse.Target.Parent then
            local Target = Users:GetPlayerFromCharacter(Mouse.Target.Parent)
            if Target then
                Target.Name = CamlockTarget
                UserNotifications('Coryu', 'Target is now '..Target.DisplayName)
            end
        end
    end)
end

Client.Chatted:Connect(function(Command)
    if string.sub(Command,1,6) == (Prefix..'part ') then
        CamlockedPart = (string.sub(Command, 7,23))
        UserNotifications('Coryu', 'Target Part is now '..CamlockedPart)
        writedata()
    end
    if string.sub(Command,1,6) == (Prefix..'ckey ') then
        Settings['Hotkeys']['Camlock'] = (string.sub(Command, 7))
        UserNotifications('Coryu', 'Camlock hotkey is now'..Settings['Hotkeys']['Camlock'])
        writedata()
    end
    if string.sub(Command,1,6) == (Prefix..'kkey ') then
        Settings['Hotkeys']['KillNotes'] = (string.sub(Command, 7))
        UserNotifications('Coryu', 'Kill notifications hotkey is now '..Settings['Hotkeys']['KillNotes'])
        writedata()
    end
end)

print([[

                                                             _            _    
             ___ ___  _ __ _   _ _   _    ___ __ _ _ __ ___ | | ___   ___| | __
            / __/ _ \| '__| | | | | | |  / __/ _` | '_ ` _ \| |/ _ \ / __| |/ /
            | (_| (_) | |  | |_| | |_| | | (_| (_| | | | | | | | (_) | (__|   < 
            \___\___/|_|   \__, |\__,_|  \___\__,_|_| |_| |_|_|\___/ \___|_|\_\
                        |___/
                        
    Commands: 3                
    [1]: -part (HumanoidRootPart, Torso, Head, UpperTorso, LowerTorso)
        If game is R15 use (HumanoidRootPart, UpperTorso, LowerTorso, Head)
        Default is UpperTorso
        If game is R6 use (HumanoidRootPart, Torso, Head)
        Default is Torso 
    [2]: -ckey (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z)
        Default is C
    [3]: -kkey (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z)
        Default is P
    
    Example Commands:

    -part Torso

    -ckey X

    -kkey J

    Hotkeys: 2

    [1]: C - Toggles camlock on and off

    [2]: P - Removes notifications (Useful if you are recording to make yourself look a bit more legit)

    Made By Coryu (maliciouscodes, spacedgodcoryu)
]])

UserNotifications('Coryu Camlock', 'Press F9 for help, Script took '..math.floor(tick() - Tick)..' Seconds')

end
