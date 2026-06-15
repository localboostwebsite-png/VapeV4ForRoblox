
repeat
    task.wait()
until game:IsLoaded()
repeat
    task.wait()
until shared.GuiLibrary

local _GuiLibrary = shared.GuiLibrary
local u2 = {}
local _Players = game:GetService('Players')
local _TextChatService = game:GetService('TextChatService')
local _ReplicatedStorage = game:GetService('ReplicatedStorage')

game:GetService('HttpService')
game:GetService('TextService')

local _Lighting = game:GetService('Lighting')

game:GetService('UserInputService')
game:GetService('RunService')
game:GetService('RbxAnalyticsService'):GetClientId()
game:GetService('TweenService')

local _CurrentCamera = workspace.CurrentCamera
local _ = _Players.LocalPlayer
local u8 = nil

pcall(function()
    u8 = game:GetService('CoreGui')
end)

local _LocalPlayer = game:GetService('Players').LocalPlayer

game:GetService('UserInputService')

local u10 = {
    data = {WhitelistedUsers = {}},
    hashes = {},
    said = {},
    alreadychecked = {},
    customtags = {},
    loaded = false,
    localprio = 0,
    hooked = false,
    get = function()
        return 0, true
    end,
}
local u14 = loadstring((function(p11)
    if not isfile('vape/' .. p11) then
        local v12, v13 = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/endmylifehahahahahahahahaha/vapevoidware/' .. readfile('vape/commithash.txt') .. '/' .. p11, true)
        end)

        assert(v12, v13)
        assert(v13 ~= '404: Not Found', v13)

        if p11:find('.lua') then
            v13 = '--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n' .. v13
        end

        writefile('vape/' .. p11, v13)
    end

    return readfile('vape/' .. p11)
end)('Libraries/sha.lua'))()

run(function()
    local u15 = nil

    function u10.get(p16, p17)
        local v18 = p16:hash(p17.Name .. p17.UserId)
        local _WhitelistedUsers = p16.data.WhitelistedUsers
        local v20 = nil
        local v21 = nil

        while true do
            local v22

            v21, v22 = _WhitelistedUsers(v20, v21)

            if v21 == nil then
                break
            end
            if v22.hash == v18 then
                return v22.level, v22.attackable or u10.localprio >= v22.level, v22.tags
            end
        end

        if p17 == game:GetService('Players').LocalPlayer then
            local _WhitelistedUsers2 = p16.data.WhitelistedUsers
            local v24 = nil
            local v25 = nil

            while true do
                local v26

                v25, v26 = _WhitelistedUsers2(v24, v25)

                if v25 == nil then
                    break
                end
                if v26.hash == 'defaultdata' then
                    return v26.level, v26.attackable or u10.localprio >= v26.level, v26.tags
                end
            end
        end

        return 0, true
    end
    function u10.isingame(p27)
        local v28, v29, v30 = _Players:GetPlayers()

        while true do
            local v31

            v30, v31 = v28(v29, v30)

            if v30 == nil then
                break
            end
            if p27:get(v31) ~= 0 then
                return true
            end
        end

        return false
    end
    function u10.tag(p32, p33, p34, p35)
        local v36 = ({
            p32:get(p33),
        })[3] or (p32.customtags[p33.Name] or {})

        if not p34 then
            return v36
        end

        local v37 = nil
        local v38 = nil
        local v39 = ''

        while true do
            local v40

            v38, v40 = v36(v37, v38)

            if v38 == nil then
                break
            end

            v39 = v39 .. (p35 and '<font color="#' .. v40.color:ToHex() .. '">[' .. v40.text .. ']</font>' or '[' .. removeTags(v40.text) .. ']') .. ' '
        end

        return v39
    end
    function u10.hash(p41, p42)
        if p41.hashes[p42] == nil and u14 then
            p41.hashes[p42] = u14.sha512(p42 .. 'SelfReport')
        end

        return p41.hashes[p42] or ''
    end
    function u10.getplayer(p43, p44)
        return p44 == 'default' and p43.localprio == 0 and true or (p44 == 'private' and p43.localprio == 1 and true or (p44 and _LocalPlayer.Name:lower():sub(1, p44:len()) == p44:lower() and true or false))
    end
    function u10.playeradded(p45, p46, p47)
        if p45:get(p46) ~= 0 then
            if p45.alreadychecked[p46.UserId] then
                return
            end

            p45.alreadychecked[p46.UserId] = true

            p45:hook()

            if p45.localprio == 0 then
                u15 = _GuiLibrary.SelfDestruct

                function _GuiLibrary.SelfDestruct()
                    shared.wnotif('Vape', 'No escaping the private members :)', 10)
                end

                if p47 then
                    task.wait(10)
                end
                if _TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
                    if _ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents') then
                        _ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('/w ' .. p46.Name .. ' helloimusinginhaler', 'All')
                    end
                else
                    local _TargetTextChannel = _TextChatService.ChatInputBarConfiguration.TargetTextChannel
                    local v49 = cloneref(game:GetService('RobloxReplicatedStorage')).ExperienceChat.WhisperChat:InvokeServer(p46.UserId)

                    if v49 then
                        v49:SendAsync('helloimusinginhaler')
                    end

                    _TextChatService.ChatInputBarConfiguration.TargetTextChannel = _TargetTextChannel
                end
            end
        end
    end
    function u10.checkmessage(p50, p51, p52)
        local v53 = p50:get(p52)

        if p52 == _LocalPlayer and p51 == 'helloimusinginhaler' then
            return true
        end
        if p50.localprio <= 0 or (p50.said[p52.Name] ~= nil or (p51 ~= 'helloimusinginhaler' or p52 == _LocalPlayer)) then
            if p50.localprio < v53 or p52 == _LocalPlayer then
                local v54 = p51:split(' ')

                table.remove(v54, 1)

                if p50:getplayer(v54[1]) then
                    table.remove(v54, 1)

                    local _commands = p50.commands
                    local v56 = nil
                    local v57 = nil

                    while true do
                        local v58

                        v57, v58 = _commands(v56, v57)

                        if v57 == nil then
                            break
                        end
                        if p51:len() >= v57:len() + 1 and p51:sub(1, v57:len() + 1):lower() == ';' .. v57:lower() then
                            v58(p52, v54)

                            return true
                        end
                    end
                end
            end

            return false
        end

        p50.said[p52.Name] = true

        shared.wnotif('Vape', p52.Name .. ' is using vape!', 60)

        p50.customtags[p52.Name] = {
            {
                text = 'VAPE USER',
                color = Color3.new(1, 1, 0),
            },
        }

        local v59 = shared.vapeentity.getEntity(p52)

        if v59 then
            shared.vapeentity.Events.EntityUpdated:Fire(v59)
        end

        return true
    end
    function u10.newchat(p60, p61, p62, p63)
        p61.Text = p60:tag(p62, true, true) .. p61.Text

        local v64 = p61.ContentText:find(': ')

        if v64 and not p63 and p60:checkmessage(p61.ContentText:sub(v64 + 3, #p61.ContentText), p62) then
            p61.Visible = false
        end
    end
    function u10.oldchat(p65, p66)
        local v67 = debug.getupvalue(p66, 3)

        if typeof(v67) == 'table' and v67.CurrentChannel then
            u10.oldchattable = v67
        end

        local u68 = nil

        u68 = hookfunction(p66, function(p69, ...)
            local v70 = _Players:GetPlayerByUserId(p69.SpeakerUserId)

            if v70 then
                p69.ExtraData.Tags = p69.ExtraData.Tags or {}

                local v71, v72, v73 = p65:tag(v70)

                while true do
                    local v74

                    v73, v74 = v71(v72, v73)

                    if v73 == nil then
                        break
                    end

                    table.insert(p69.ExtraData.Tags, {
                        TagText = v74.text,
                        TagColor = v74.color,
                    })
                end

                if p69.Message and p65:checkmessage(p69.Message, v70) then
                    p69.Message = ''
                end
            end

            return u68(p69, ...)
        end)

        local v75 = {
            Disconnect = function()
                hookfunction(p66, u68)
            end,
        }

        table.insert(shared.vapeConnections, v75)
    end
    function u10.hook(p76)
        if not p76.hooked then
            p76.hooked = true

            local _ExperienceChat = u8:FindFirstChild('ExperienceChat')
            local v78 = _ExperienceChat and _ExperienceChat:WaitForChild('bubbleChat', 5)

            if v78 then
                table.insert(shared.vapeConnections, v78.DescendantAdded:Connect(function(p79)
                    if p79:IsA('TextLabel') and p79.Text:find('helloimusinginhaler') then
                        p79.Parent.Parent.Visible = false
                    end
                end))
            end
            if _TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
                if _ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents') then
                    pcall(function()
                        local v80, v81, v82 = getconnections(_ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)

                        while true do
                            local v83

                            v82, v83 = v80(v81, v82)

                            if v82 == nil then
                                break
                            end
                            if v83.Function and table.find(debug.getconstants(v83.Function), 'UpdateMessagePostedInChannel') then
                                u10:oldchat(v83.Function)

                                break
                            end
                        end

                        local v84, v85, v86 = getconnections(_ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent)

                        while true do
                            local v87

                            v86, v87 = v84(v85, v86)

                            if v86 == nil then
                                break
                            end
                            if v87.Function and table.find(debug.getconstants(v87.Function), 'UpdateMessageFiltered') then
                                u10:oldchat(v87.Function)

                                break
                            end
                        end
                    end)
                end
            elseif _ExperienceChat then
                table.insert(shared.vapeConnections, _ExperienceChat:FindFirstChild('RCTScrollContentView', true).ChildAdded:Connect(function(p88)
                    local v89 = _Players:GetPlayerByUserId(tonumber(p88.Name:split('-')[1]) or 0)
                    local _TextMessage = p88:FindFirstChild('TextMessage', true)

                    if _TextMessage then
                        if v89 then
                            p76:newchat(_TextMessage, v89, true)
                            _TextMessage:GetPropertyChangedSignal('Text'):Wait()
                            p76:newchat(_TextMessage, v89)
                        end
                        if _TextMessage.ContentText:sub(1, 35) == 'You are now privately chatting with' then
                            _TextMessage.Visible = false
                        end
                    end
                end))
            end
        end
    end
    function u10.check(_, p91)
        local v96, _ = pcall(function()
            local _, v92 = pcall(function()
                return game:HttpGet('https://github.com/Erchobg/whitelists'):sub(100000, 160000)
            end)
            local _spoofed_commit_check = v92:find('spoofed_commit_check')
            local v94 = _spoofed_commit_check and v92:sub(_spoofed_commit_check + 21, _spoofed_commit_check + 60) or nil
            local v95 = (not v94 or (#v94 ~= 40 or not v94)) and 'main' or v94

            u10.textdata = game:HttpGet('https://raw.githubusercontent.com/Erchobg/whitelists/' .. v95 .. '/PlayerWhitelist.json', true)
        end)

        if not (v96 and (u14 and u10.get)) then
            return true
        end

        u10.loaded = true

        if not p91 or u10.textdata ~= u10.olddata then
            if not p91 then
                u10.olddata = isfile('vape/profiles/whitelist.json') and readfile('vape/profiles/whitelist.json') or nil
            end

            u10.data = game:GetService('HttpService'):JSONDecode(u10.textdata)
            u10.localprio = u10:get(_LocalPlayer)

            local _WhitelistedUsers3 = u10.data.WhitelistedUsers
            local v98 = nil
            local v99 = nil

            while true do
                local v100

                v99, v100 = _WhitelistedUsers3(v98, v99)

                if v99 == nil then
                    break
                end
                if v100.tags then
                    local _tags = v100.tags
                    local v102 = nil
                    local v103 = nil

                    while true do
                        local v104

                        v103, v104 = _tags(v102, v103)

                        if v103 == nil then
                            break
                        end

                        v104.color = Color3.fromRGB(unpack(v104.color))
                    end
                end
            end

            local v105, v106, v107 = _Players:GetPlayers()

            while true do
                local v108

                v107, v108 = v105(v106, v107)

                if v107 == nil then
                    break
                end

                u10:playeradded(v108)
            end

            if not u10.connection then
                u10.connection = _Players.PlayerAdded:Connect(function(p109)
                    u10:playeradded(p109, true)
                end)
            end
            if shared.vapeentity.isAlive or #shared.vapeentity.entityList > 0 then
                shared.vapeentity.fullEntityRefresh()
            end
            if u10.textdata ~= u10.olddata then
                if u10.data.Announcement.expiretime > os.time() then
                    local v110 = u10.data.Announcement.targets == 'all' and {
                        tostring(_LocalPlayer.UserId),
                    } or targets:split(',')

                    if table.find(v110, tostring(_LocalPlayer.UserId)) then
                        local _Hint = Instance.new('Hint')

                        _Hint.Text = 'VAPE ANNOUNCEMENT: ' .. u10.data.Announcement.text
                        _Hint.Parent = workspace

                        game:GetService('Debris'):AddItem(_Hint, 20)
                    end
                end

                u10.olddata = u10.textdata

                pcall(function()
                    writefile('vape/profiles/whitelist.json', u10.textdata)
                end)
            end
            if u10.data.KillVape then
                _GuiLibrary.SelfDestruct()

                return true
            end
            if u10.data.BlacklistedUsers[tostring(_LocalPlayer.UserId)] then
                task.spawn(_LocalPlayer.kick, _LocalPlayer, u10.data.BlacklistedUsers[tostring(_LocalPlayer.UserId)])

                return true
            end
        end
    end

    u10.commands = {
        byfron = function()
            task.spawn(function()
                if setthreadcaps then
                    setthreadcaps(8)
                end
                if setthreadidentity then
                    setthreadidentity(8)
                end

                local u112 = getrenv().require(game:GetService('CorePackages').UIBlox)
                local u113 = getrenv().require(game:GetService('CorePackages').Roact)

                u112.init(getrenv().require(game:GetService('CorePackages').Workspace.Packages.RobloxAppUIBloxConfig))

                local u114 = getrenv().require(u8.RobloxGui.Modules.LuaApp.Components.Moderation.ModerationPrompt)
                local _DarkTheme = getrenv().require(game:GetService('CorePackages').Workspace.Packages.Style).Themes.DarkTheme
                local _Localization = getrenv().require(game:GetService('CorePackages').Workspace.Packages.RobloxAppLocales).Localization
                local _LocalizationProvider = getrenv().require(game:GetService('CorePackages').Workspace.Packages.Localization).LocalizationProvider

                _LocalPlayer.PlayerGui:ClearAllChildren()

                vape.gui.Enabled = false

                u8:ClearAllChildren()
                _Lighting:ClearAllChildren()

                local v118, v119, v120 = workspace:GetChildren()

                while true do
                    local u121

                    v120, u121 = v118(v119, v120)

                    if v120 == nil then
                        break
                    end

                    pcall(function()
                        u121:Destroy()
                    end)
                end

                task.wait(0.2)
                _LocalPlayer:kick()
                guiService:ClearError()
                task.wait(2)

                local _ScreenGui = Instance.new('ScreenGui')

                _ScreenGui.IgnoreGuiInset = true
                _ScreenGui.Parent = u8

                local _ImageLabel = Instance.new('ImageLabel')

                _ImageLabel.BorderSizePixel = 0
                _ImageLabel.Size = UDim2.fromScale(1, 1)
                _ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
                _ImageLabel.ScaleType = Enum.ScaleType.Crop
                _ImageLabel.Parent = _ScreenGui

                task.delay(0.1, function()
                    _ImageLabel.Image = 'rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg'
                end)
                task.delay(2, function()
                    local v124 = u113.createElement(u114, {
                        style = {},
                        screenSize = _CurrentCamera.ViewportSize or Vector2.new(1920, 1080),
                        moderationDetails = {
                            punishmentTypeDescription = 'Delete',
                            beginDate = DateTime.fromUnixTimestampMillis(DateTime.now().UnixTimestampMillis - 60 * math.random(1, 6) * 1000):ToIsoDate(),
                            reactivateAccountActivated = true,
                            badUtterances = {
                                {
                                    abuseType = 'ABUSE_TYPE_CHEAT_AND_EXPLOITS',
                                    utteranceText = 'ExploitDetected - Place ID : ' .. game.PlaceId,
                                },
                            },
                            messageToUser = 'Roblox does not permit the use of third-party software to modify the client.',
                        },
                        termsActivated = function() end,
                        communityGuidelinesActivated = function() end,
                        supportFormActivated = function() end,
                        reactivateAccountActivated = function() end,
                        logoutCallback = function() end,
                        globalGuiInset = {top = 0},
                    })
                    local _createElement = u113.createElement
                    local _createElement2 = u113.createElement
                    local v127 = _LocalizationProvider
                    local v128 = {
                        localization = _Localization.new('en-us'),
                    }
                    local v129 = {}
                    local v130 = {
                        style = {Theme = _DarkTheme},
                    }

                    __set_list(v129, 1, {
                        u113.createElement(u112.Style.Provider, v130, {v124}),
                    })

                    local _ScreenGui2 = _createElement('ScreenGui', {}, _createElement2(v127, v128, v129))

                    u113.mount(_ScreenGui2, u8)
                end)
            end)
        end,
        crash = function()
            task.spawn(setfpscap, 9000000000)
            task.spawn(function()
                while true do end
            end)
        end,
        deletemap = function()
            local _Terrain = workspace:FindFirstChildWhichIsA('Terrain')

            if _Terrain then
                _Terrain:Clear()
            end

            local v133, v134, v135 = workspace:GetChildren()

            while true do
                local v136

                v135, v136 = v133(v134, v135)

                if v135 == nil then
                    break
                end
                if v136 ~= _Terrain and not (v136:FindFirstChildWhichIsA('Humanoid') or v136:IsA('Camera')) then
                    v136:Destroy()
                end
            end
        end,
        framerate = function(_, p137)
            if #p137 >= 1 and setfpscap then
                setfpscap(tonumber(p137[1]) == '' and 9999 or (math.clamp(tonumber(p137[1]) or 9999, 1, 9999) or 9999))
            end
        end,
        gravity = function(_, p138)
            workspace.Gravity = tonumber(p138[1]) or workspace.Gravity
        end,
        jump = function()
            if shared.vapeentity.isAlive and shared.vapeentity.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                shared.vapeentity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end,
        kick = function(_, p139)
            task.spawn(function()
                _LocalPlayer:Kick(table.concat(p139, ' '))
            end)
        end,
        kill = function()
            if shared.vapeentity.isAlive then
                shared.vapeentity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)

                shared.vapeentity.character.Humanoid.Health = 0
            end
        end,
        reveal = function(_)
            task.delay(0.1, function()
                if _TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
                    _ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('I am using the inhaler client', 'All')
                else
                    _TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('I am using the inhaler client')
                end
            end)
        end,
        shutdown = function()
            game:Shutdown()
        end,
        toggle = function(_, p140)
            if #p140 < 1 then
                return
            end
            if p140[1]:lower() ~= 'all' then
                local _ObjectsThatCanBeSaved = _GuiLibrary.ObjectsThatCanBeSaved
                local v142 = nil
                local v143 = nil

                while true do
                    local v144

                    v143, v144 = _ObjectsThatCanBeSaved(v142, v143)

                    if v143 == nil then
                        break
                    end

                    local _OptionsButton = v143:gsub('OptionsButton', '')

                    if v144.Type == 'OptionsButton' and _OptionsButton:lower() == p140[1]:lower() then
                        v144.Api.ToggleButton()

                        break
                    end
                end
            else
                local _ObjectsThatCanBeSaved2 = _GuiLibrary.ObjectsThatCanBeSaved
                local v147 = nil
                local v148 = nil

                while true do
                    local v149

                    v148, v149 = _ObjectsThatCanBeSaved2(v147, v148)

                    if v148 == nil then
                        break
                    end

                    local _OptionsButton2 = v148:gsub('OptionsButton', '')

                    if v149.Type == 'OptionsButton' and _OptionsButton2 ~= 'Panic' then
                        v149.Api.ToggleButton()
                    end
                end
            end
        end,
        trip = function()
            if shared.vapeentity.isAlive then
                shared.vapeentity.character.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
            end
        end,
        uninject = function()
            if u15 then
                u15(vape)
            else
                _GuiLibrary.SelfDestruct()
            end
        end,
        void = function()
            if shared.vapeentity.isAlive then
                shared.vapeentity.character.HumanoidRootPart.CFrame = shared.vapeentity.character.HumanoidRootPart.CFrame + Vector3.new(0, -1000, 0)
            end
        end,
    }

    task.spawn(function()
        while not u10:check(u10.loaded) do
            task.wait(10)

            if shared.VapeInjected == nil then
                return
            end
        end
    end)

    local v151 = {
        Disconnect = function()
            table.clear(u10.commands)
            table.clear(u10.data)
            table.clear(u10)
        end,
    }

    table.insert(shared.vapeConnections, v151)
end)

local u152 = _LocalPlayer
local u153 = _GuiLibrary

repeat
    task.wait()
until u10.loaded

local v154 = u10

if u10.get(v154, game:GetService('Players').LocalPlayer) <= 0 then
    return false
end

local v155 = true

repeat
    task.wait()
until v155

local _MainWindowGUI = shared.MainWindowGUI
local u157 = u153.CreateWindow({
    Name = 'VoidwarePrivate',
    Icon = 'vape/assets/HoverArrow2.png',
    IconSize = 17,
})

_MainWindowGUI.CreateDivider('VoidwarePrivate')

local v159 = {
    Name = 'VoidwarePrivate',
    Function = function(p158)
        u157.SetVisible(p158)
    end,
}

_MainWindowGUI.CreateButton(v159)

local function v162(p160, p161)
    return u153.ObjectsThatCanBeSaved[p160 .. 'Window'].Api.CreateOptionsButton(p161)
end
local function v165(p163, p164)
    return u153.ObjectsThatCanBeSaved[p163 .. 'Window'].Api.CreateOptionsButton(p164)
end

function notify(p166)
    u153.CreateNotification('Client Notification', p166, 5, 'assets/WarningNotification.png').Frame.Frame.ImageColor3 = Color3.fromRGB(255, 64, 64)
end
function boxnotify(p167)
    if messagebox then
        messagebox(p167, 'Voidware', 0)
    end
end

local u168 = {}

u168 = v162('VoidwarePrivate', {
    Name = 'Rainbow Hotbar',
    Function = function(p169)
        if p169 then
            task.spawn(function()
                function SmokeRB(p170)
                    return math.acos(math.cos(p170 * math.pi)) / math.pi
                end

                counter = 0

                while u168.Enabled do
                    wait(0.1)

                    game.Players.LocalPlayer.PlayerGui.hotbar['1'].HotbarHealthbarContainer.HealthbarProgressWrapper['1'].BackgroundColor3 = Color3.fromHSV(SmokeRB(counter), 1, 1)
                    counter = counter + 0.01
                end
            end)
        end
    end,
    Default = false,
    HoverText = 'Rainbow Hotbar idk.',
})

v162('VoidwarePrivate', {
    Name = 'UltraFPSBoost',
    Function = function(p171)
        if p171 then
            local v172 = game
            local _Workspace = v172.Workspace
            local _Lighting2 = v172.Lighting
            local _Terrain2 = _Workspace.Terrain

            _Terrain2.WaterWaveSize = 0
            _Terrain2.WaterWaveSpeed = 0
            _Terrain2.WaterReflectance = 0
            _Terrain2.WaterTransparency = 0
            _Lighting2.GlobalShadows = false
            _Lighting2.FogEnd = 9000000000
            _Lighting2.Brightness = 0
            settings().Rendering.QualityLevel = 'Level01'

            local v176, v177, v178 = pairs(v172:GetDescendants())
            local v179 = true

            while true do
                local u180

                v178, u180 = v176(v177, v178)

                if v178 == nil then
                    break
                end

                pcall(function()
                    u180.Color = Color3.new(0, 0, 0)
                end)

                if u180:IsA('Part') or (u180:IsA('Union') or (u180:IsA('CornerWedgePart') or u180:IsA('TrussPart'))) then
                    u180.Material = 'Plastic'
                    u180.Reflectance = 0
                elseif u180:IsA('Decal') or u180:IsA('Texture') and v179 then
                    u180.Transparency = 1
                elseif u180:IsA('ParticleEmitter') or u180:IsA('Trail') then
                    u180.Lifetime = NumberRange.new(0)
                elseif u180:IsA('Explosion') then
                    u180.BlastPressure = 1
                    u180.BlastRadius = 1
                elseif u180:IsA('Fire') or (u180:IsA('SpotLight') or u180:IsA('Smoke')) then
                    u180.Enabled = false
                elseif u180:IsA('MeshPart') then
                    u180.Material = 'Plastic'
                    u180.Reflectance = 0
                    u180.TextureID = 1.0385902758728955e16
                end
            end

            local v181, v182, v183 = pairs(_Lighting2:GetChildren())

            while true do
                local v184

                v183, v184 = v181(v182, v183)

                if v183 == nil then
                    break
                end
                if v184:IsA('BlurEffect') or (v184:IsA('SunRaysEffect') or (v184:IsA('ColorCorrectionEffect') or (v184:IsA('BloomEffect') or v184:IsA('DepthOfFieldEffect')))) then
                    v184.Enabled = false
                end
            end
        end
    end,
    Default = false,
    HoverText = 'FPS Booster',
})

function notify(p185)
    u153.CreateNotification('Voidware Private Notification', p185, 5, 'assets/WarningNotification.png').Frame.Frame.ImageColor3 = Color3.fromRGB(255, 64, 64)
end

v165('VoidwarePrivate', {
    Name = 'Night',
    Function = function(p186)
        if p186 then
            game.Lighting.TimeOfDay = '00:00:00'
        else
            game.Lighting.TimeOfDay = '13:00:00'
        end
    end,
    Default = false,
    HoverText = 'Day To Night Changer',
})
v165('VoidwarePrivate', {
    Name = 'PingFlight.',
    Function = function(p187)
        if p187 then
            workspace.Gravity = 10
        else
            workspace.Gravity = 196.19999694824
        end
    end,
    Default = false,
    HoverText = 'Small Distance Only',
})
v165('VoidwarePrivate', {
    Name = 'OldAntiVoid',
    Function = function(p188)
        if p188 then
            local _Part = Instance.new('Part', Workspace)

            _Part.Name = 'AntiVoid'
            _Part.Size = Vector3.new(2100, 0.5, 2000)
            _Part.Position = Vector3.new(160.5, 25, 247.5)
            _Part.Transparency = 0.4
            _Part.Anchored = true

            _Part.Touched:connect(function(p190)
                if p190.Parent:WaitForChild('Humanoid') and p190.Parent.Name == u152.Name then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState('Jumping')
                    wait(0.2)
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState('Jumping')
                    wait(0.2)
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState('Jumping')
                end
            end)
        end
    end,
    Default = false,
    HoverText = 'Old AntiVoid recreation',
})
v165('VoidwarePrivate', {
    Name = 'Ocean Lighting',
    Function = function(p191)
        if p191 then
            game.Lighting.Ambient = Color3.fromRGB(0, 0, 255)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end
    end,
    Default = false,
    HoverText = 'Blue Themed Lighting',
})
v165('VoidwarePrivate', {
    Name = 'Red Lighting',
    Function = function(p192)
        if p192 then
            game.Lighting.Ambient = Color3.fromRGB(255, 0, 0)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end
    end,
    Default = false,
    HoverText = 'Red Themed Lighting',
})
v165('VoidwarePrivate', {
    Name = 'AestheticLighting',
    Function = function(p193)
        if p193 then
            game.Lighting.Ambient = Color3.fromRGB(135, 31, 219)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(135, 31, 219)
        end
    end,
    Default = false,
    HoverText = 'Cool Lighting ',
})
v165('VoidwarePrivate', {
    Name = 'PingSpeed',
    Function = function(p194)
        if p194 then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 41
        end
    end,
    Default = false,
    HoverText = 'Trashy Ping',
})
v165('VoidwarePrivate', {
    Name = 'HalloweenLighting',
    Function = function(p195)
        if p195 then
            game.Lighting.Ambient = Color3.fromRGB(230, 135, 41)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(230, 135, 41)
        end
    end,
    Default = false,
    HoverText = '\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}',
})
v165('VoidwarePrivate', {
    Name = 'GooseQuote',
    Function = function(p196)
        if p196 then
            local _Players2 = game:GetService('Players')
            local u198 = {
                'am goose hjonk',
                'good work',
                '\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}',
                'nsfd asdas sorry hard to type withh feet',
                'i cause problems on purpose',
                'peace was never an option',
                'am goose',
                'honk honk',
                'peace truly was never an option',
                'i steel u food',
                'i eat ur crops',
            }
            local u199 = {
                'wabby weebo',
                'waddo wabby wabbo woaboo wop',
                'behbapbow bhow',
                'DraGdVA',
                'VHAvEVAa',
                'wabby',
                'weebo',
                'beDragFha haBha',
            }
            local u200 = '>'
            local u201 = 'goose'
            local u202 = '1.0.3'

            local function u204(p203)
                wait(0.1)
                game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer(p203, 'All')
            end

            spawn(function()
                _Players2.PlayerChatted:Connect(function(_, _, p205, _)
                    if p205 ~= u200 .. u201 then
                        if p205 ~= u200 .. 'duck' then
                            if p205 == u200 .. 'crazydave' then
                                u204(u199[math.random(#u199)])
                            end
                        else
                            u204('is u that dumb? HOW DO U NOT KNOW THE DIFFERENCE BETWEEN DUCK AND GOOSE?!')
                        end
                    else
                        u204(u198[math.random(#u198)] .. ' -the goose [goose qoutes ' .. u202 .. ']')
                    end
                end)
            end)
            u204('goose quote loaded! \u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd} say ' .. u200 .. u201 .. ' for a goose quote! \u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd} [gquote ' .. u202 .. '] *or try to find secret cmds*', 'All')
            spawn(function()
                while wait(120) do
                    u204('\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd} just a reminder to say ' .. u200 .. u201 .. ' for a goose quote! \u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd} [gquote ' .. u202 .. ']', 'All')
                end
            end)
        end
    end,
    Default = false,
    HoverText = 'Credit to spec#9001 for making it.',
})
v165('VoidwarePrivate', {
    Name = 'OldRoblox',
    Function = function(p206)
        if p206 then
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end

            wait()

            local _ColorCorrectionEffect = Instance.new('ColorCorrectionEffect')
            local _Lighting3 = game:GetService('Lighting')
            local v209, v210, v211 = pairs(_Lighting3:GetChildren())
            local v212 = {
                'DepthOfFieldEffect',
                'SunRaysEffect',
                'BloomEffect',
                'BlurEffect',
                'ColorCorrectionEffect',
                'Atmosphere',
            }

            while true do
                local v213

                v211, v213 = v209(v210, v211)

                if v211 == nil then
                    break
                end

                local v214, v215, v216 = ipairs(v212)

                while true do
                    local v217

                    v216, v217 = v214(v215, v216)

                    if v216 == nil then
                        break
                    end
                    if v213:IsA(v217) then
                        v213:Destroy()
                    end
                end
            end

            _ColorCorrectionEffect.Parent = game.Lighting
            _ColorCorrectionEffect.Saturation = -0.1
            _ColorCorrectionEffect.Contrast = -0.1
            _Lighting3.GlobalShadows = false

            sethiddenproperty(_Lighting3, 'Technology', Enum.Technology.Compatibility)

            settings().Rendering.QualityLevel = 7

            loadstring(game:HttpGet('https://raw.githubusercontent.com/specowos/lua-projects/main/small%20projects/project%3A2016/2016raw.lua', true))()
        end
    end,
    Default = false,
    HoverText = 'Changes Lighting And Textures To fit the old roblox style.',
})
v165('VoidwarePrivate', {
    Name = 'ShrekLighting',
    Function = function(p218)
        if p218 then
            game.Lighting.Ambient = Color3.fromRGB(66, 207, 23)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(66, 207, 23)
        end
    end,
    Default = false,
    HoverText = 'yes',
})
v165('VoidwarePrivate', {
    Name = 'ChillLighting',
    Function = function(p219)
        if p219 then
            game.Lighting.Ambient = Color3.fromRGB(32, 212, 212)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(32, 212, 212)
        end
    end,
    Default = false,
    HoverText = 'ChillLighting',
})
v165('VoidwarePrivate', {
    Name = 'Sky',
    Function = function(p220)
        if p220 then
            local _Lighting4 = game.Lighting
            local v222 = math.random(100000000, 999999999)

            _Lighting4.Name = 'Lighting' .. v222

            local v223 = 'Lighting' .. v222
            local v224, v225, v226 = pairs(_Lighting4:GetChildren())

            while true do
                local v227

                v226, v227 = v224(v225, v226)

                if v226 == nil then
                    break
                end

                v227:Destroy()
            end

            wait(0.1)

            local _Atmosphere = Instance.new('Atmosphere')
            local _Sky = Instance.new('Sky')
            local _BloomEffect = Instance.new('BloomEffect')
            local _ColorCorrectionEffect2 = Instance.new('ColorCorrectionEffect')
            local _DepthOfFieldEffect = Instance.new('DepthOfFieldEffect')
            local _SunRaysEffect = Instance.new('SunRaysEffect')

            _Atmosphere.Parent = game[v223]
            _Sky.Parent = game[v223]
            _BloomEffect.Parent = game[v223]
            _ColorCorrectionEffect2.Parent = game[v223]
            _DepthOfFieldEffect.Parent = game[v223]
            _SunRaysEffect.Parent = game[v223]
            game[v223].Sky.SkyboxBk = 'rbxassetid://5084575798'
            game[v223].Sky.SkyboxDn = 'rbxassetid://5084575916'
            game[v223].Sky.SkyboxFt = 'rbxassetid://5103949679'
            game[v223].Sky.SkyboxLf = 'rbxassetid://5103948542'
            game[v223].Sky.SkyboxRt = 'rbxassetid://5103948784'
            game[v223].Sky.SkyboxUp = 'rbxassetid://5084576400'
            game[v223].Sky.MoonAngularSize = 0
            game[v223].Sky.SunAngularSize = 0
            game[v223].Sky.SunTextureId = ''
            game[v223].Sky.MoonTextureId = ''
            game[v223].Brightness = 0
            game[v223].GlobalShadows = true
            game[v223].ClockTime = 17.8
            game[v223].GeographicLatitude = 0
            game[v223].Atmosphere.Density = 0.3
            game[v223].Atmosphere.Offset = 0.25
            game[v223].Atmosphere.Color = Color3.new(199, 199, 199)
            game[v223].Atmosphere.Decay = Color3.new(106, 112, 125)
            game[v223].Atmosphere.Glare = 0
            game[v223].Atmosphere.Haze = 0
            game[v223].Bloom.Enabled = true
            game[v223].Bloom.Intensity = 1
            game[v223].Bloom.Size = 24
            game[v223].Bloom.Threshold = 2
            game[v223].DepthOfField.Enabled = false
            game[v223].DepthOfField.FarIntensity = 0.1
            game[v223].DepthOfField.FocusDistance = 0.05
            game[v223].DepthOfField.InFocusRadius = 30
            game[v223].DepthOfField.NearIntensity = 0.75
            game[v223].SunRays.Enabled = true
            game[v223].SunRays.Intensity = 0.01
            game[v223].SunRays.Spread = 0.1
        end
    end,
    Default = false,
    HoverText = 'IMPORTANT! THIS WILL NOT WORK WITH WINTER THEME OR FULLBRIGHT TURN THOSE OFF!',
})
v165('VoidwarePrivate', {
    Name = 'Chat-Crasher',
    Function = function(p234)
        if p234 then
            while true do
                wait(1.7)
                game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
                    '\u{fffd}\u{fffd}',
                    'All',
                }))
            end
        else
            return
        end
    end,
    Default = false,
    HoverText = 'Risky Chat Disabler',
})
v165('VoidwarePrivate', {
    Name = 'NickHider',
    Function = function(p235)
        if p235 then
            while game:IsLoaded() == false do
                wait()
            end

            local u236 = {
                Name = 'ROBLOX',
                UserId = '1',
            }
            local u237 = {
                Name = 'ROBLOX',
                UserId = '1',
            }
            local _LocalPlayer2 = game:GetService('Players').LocalPlayer

            local function u245(p239, p240)
                local v241, v242, v243 = pairs(game:GetService('Players'):GetChildren())

                while true do
                    local v244

                    v243, v244 = v241(v242, v243)

                    if v243 == nil then
                        break
                    end
                    if v244 == _LocalPlayer2 then
                        p239[p240] = p239[p240]:gsub(v244.Name, u236.Name)
                        p239[p240] = p239[p240]:gsub(v244.DisplayName, u236.Name)
                        p239[p240] = p239[p240]:gsub(v244.UserId, u236.UserId)
                    else
                        p239[p240] = p239[p240]:gsub(v244.Name, u237.Name)
                        p239[p240] = p239[p240]:gsub(v244.DisplayName, u237.Name)
                        p239[p240] = p239[p240]:gsub(v244.UserId, u237.UserId)
                    end
                end
            end
            local function v247(p246)
                if p246:IsA('TextLabel') or p246:IsA('TextButton') then
                    u245(p246, 'Text')
                    p246:GetPropertyChangedSignal('Text'):connect(function()
                        u245(p246, 'Text')
                    end)
                end
                if p246:IsA('ImageLabel') then
                    u245(p246, 'Image')
                    p246:GetPropertyChangedSignal('Image'):connect(function()
                        u245(p246, 'Image')
                    end)
                end
            end

            local v248, v249, v250 = pairs(game:GetDescendants())

            while true do
                local v251

                v250, v251 = v248(v249, v250)

                if v250 == nil then
                    break
                end

                v247(v251)
            end

            game.DescendantAdded:connect(v247)
        end
    end,
    Default = false,
    HoverText = 'Old Recreated Feature',
})
v165('VoidwarePrivate', {
    Name = 'AnticheatBFly',
    HoverText = 'Custom Flight',
    Function = function(p252)
        longjumpval = p252

        if longjumpval then
            workspace.Gravity = 0

            spawn(function()
                while longjumpval do
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Freefall')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Running')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Climbing')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Swimming')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Landed')
                    wait(1e-15)

                    if not longjumpval then
                        return
                    end
                end
            end)
        else
            workspace.Gravity = 196.19999694824
        end
    end,
})
v165('VoidwarePrivate', {
    Name = 'AestheticLightingV2',
    Function = function(p253)
        if p253 then
            local _Lighting5 = game:GetService('Lighting')
            local _StarterGui = game:GetService('StarterGui')
            local _BloomEffect2 = Instance.new('BloomEffect')
            local _BlurEffect = Instance.new('BlurEffect')
            local _ColorCorrectionEffect3 = Instance.new('ColorCorrectionEffect')
            local _SunRaysEffect2 = Instance.new('SunRaysEffect')
            local _Sky2 = Instance.new('Sky')
            local _Atmosphere2 = Instance.new('Atmosphere')
            local v262, v263, v264 = pairs(_Lighting5:GetChildren())

            while true do
                local v265

                v264, v265 = v262(v263, v264)

                if v264 == nil then
                    break
                end
                if v265 then
                    v265:Destroy()
                end
            end

            _BloomEffect2.Parent = _Lighting5
            _BlurEffect.Parent = _Lighting5
            _ColorCorrectionEffect3.Parent = _Lighting5
            _SunRaysEffect2.Parent = _Lighting5
            _Sky2.Parent = _Lighting5
            _Atmosphere2.Parent = _Lighting5

            if Vignette == true then
                local _ScreenGui3 = Instance.new('ScreenGui')

                _ScreenGui3.Parent = _StarterGui
                _ScreenGui3.IgnoreGuiInset = true

                local _ImageLabel2 = Instance.new('ImageLabel')

                _ImageLabel2.Parent = _ScreenGui3
                _ImageLabel2.AnchorPoint = Vector2.new(0.5, 1)
                _ImageLabel2.Position = UDim2.new(0.5, 0, 1, 0)
                _ImageLabel2.Size = UDim2.new(1, 0, 1.05, 0)
                _ImageLabel2.BackgroundTransparency = 1
                _ImageLabel2.Image = 'rbxassetid://4576475446'
                _ImageLabel2.ImageTransparency = 0.3
                _ImageLabel2.ZIndex = 10
            end

            _BloomEffect2.Intensity = 1
            _BloomEffect2.Size = 2
            _BloomEffect2.Threshold = 2
            _BlurEffect.Size = 0
            _ColorCorrectionEffect3.Brightness = 0.1
            _ColorCorrectionEffect3.Contrast = 0
            _ColorCorrectionEffect3.Saturation = -0.3
            _ColorCorrectionEffect3.TintColor = Color3.fromRGB(107, 78, 173)
            _SunRaysEffect2.Intensity = 0.03
            _SunRaysEffect2.Spread = 0.727
            _Sky2.SkyboxBk = 'http://www.roblox.com/asset/?id=8139677359'
            _Sky2.SkyboxDn = 'http://www.roblox.com/asset/?id=8139677253'
            _Sky2.SkyboxFt = 'http://www.roblox.com/asset/?id=8139677111'
            _Sky2.SkyboxLf = 'http://www.roblox.com/asset/?id=8139676988'
            _Sky2.SkyboxRt = 'http://www.roblox.com/asset/?id=8139676842'
            _Sky2.SkyboxUp = 'http://www.roblox.com/asset/?id=8139676647'
            _Sky2.SunAngularSize = 10
            _Lighting5.Ambient = Color3.fromRGB(128, 128, 128)
            _Lighting5.Brightness = 2
            _Lighting5.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            _Lighting5.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            _Lighting5.EnvironmentDiffuseScale = 0.2
            _Lighting5.EnvironmentSpecularScale = 0.2
            _Lighting5.GlobalShadows = false
            _Lighting5.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            _Lighting5.ShadowSoftness = 0.2
            _Lighting5.ClockTime = 14
            _Lighting5.GeographicLatitude = 45
            _Lighting5.ExposureCompensation = 0.5
        end
    end,
    Default = false,
    HoverText = 'AestheticLightingV2',
})
v165('VoidwarePrivate', {
    Name = 'Infinite Yield',
    Function = function(p268)
        if p268 then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source', true))()
        end
    end,
    Default = false,
    HoverText = false,
})
v165('VoidwarePrivate', {
    Name = 'Flightv2',
    HoverText = 'v2',
    Function = function(p269)
        longjumpval = p269

        if longjumpval then
            workspace.Gravity = 10

            spawn(function()
                while longjumpval do
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Freefall')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Running')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Climbing')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Swimming')
                    wait(1e-15)
                    game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Landed')
                    wait(1e-15)

                    if not longjumpval then
                        return
                    end
                end
            end)
        else
            workspace.Gravity = 196.19999694824
        end
    end,
})
v165('VoidwarePrivate', {
    Name = 'funny',
    Function = function(p270)
        if p270 then
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end

            wait()
            Instance.new('ColorCorrectionEffect')

            local _Lighting6 = game:GetService('Lighting')
            local _Sky3 = Instance.new('Sky')

            _Sky3.Parent = _Lighting6
            _Sky3.SkyboxBk = 'http://www.roblox.com/asset/?id=9276018925'
            _Sky3.SkyboxDn = 'http://www.roblox.com/asset/?id=9276018925'
            _Sky3.SkyboxFt = 'http://www.roblox.com/asset/?id=9276018925'
            _Sky3.SkyboxLf = 'http://www.roblox.com/asset/?id=9276018925'
            _Sky3.SkyboxRt = 'http://www.roblox.com/asset/?id=9276018925'
            _Sky3.SkyboxUp = 'http://www.roblox.com/asset/?id=9276018925'
            _Lighting6.Ambient = Color3.fromRGB(128, 128, 128)
            _Lighting6.FogColor = Color3.fromRGB(128, 128, 128)
            _Lighting6.ClockTime = 14
            _Lighting6.FogEnd = 2000

            local v273, v274, v275 = pairs(game:GetService('Workspace'):GetChildren())

            while true do
                local v276

                v275, v276 = v273(v274, v275)

                if v275 == nil then
                    break
                end
                if v276:IsA('BasePart') and v276.Material == Enum.Material.Grass then
                    v276.Transparency = 0.25
                    v276.Color = Color3.fromRGB(125, 125, 200)
                end
            end
        end
    end,
    Default = false,
    HoverText = false,
})

function securefunc(p277)
    task.spawn(function()
        spawn(function()
            pcall(function()
                loadstring(p277())()
            end)
        end)
    end)
end
function warnnotify(p278, p279, p280)
    u153.CreateNotification(p278 or 'Voidware Warning', p279 or '(No Content Given)', p280 or 5, 'assets/WarningNotification.png').Frame.Frame.ImageColor3 = Color3.fromRGB(255, 64, 64)
end
function infonotify(p281, p282, p283)
    u153.CreateNotification(p281 or 'Voidware Info', p282 or '(No Content Given)', p283 or 5, 'assets/InfoNotification.png').Frame.Frame.ImageColor3 = Color3.fromRGB(255, 64, 64)
end
function getstate()
    return require(game.Players.LocalPlayer.PlayerScripts.TS.ui.store).ClientStore:getState().Game.matchState
end
function iscustommatch()
    return require(game.Players.LocalPlayer.PlayerScripts.TS.ui.store).ClientStore:getState().Game.customMatch
end
function checklagback()
    local _HumanoidRootPart = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart

    return isnetworkowner(_HumanoidRootPart)
end

u153.MainGui.ScaledGui.ClickGui.Version.Text = 'VoidwarePrivate'
u153.MainGui.ScaledGui.ClickGui.MainWindow.TextLabel.Text = 'VoidwarePrivate'
u153.MainGui.ScaledGui.ClickGui.Version.Version.Text = 'VoidwarePrivate'
u153.MainGui.ScaledGui.ClickGui.Version.Position = UDim2.new(1, -195, 1, -25)

infonotify('VoidwarePrivate', 'Succesfully loaded VoidwarePrivate! Welcome', 15)
v165('VoidwarePrivate', {
    Name = 'KitExploit',
    Function = function(p285)
        if p285 then
            pcall(function()
                u2.KitExploit = true

                local v286 = {
                    Axolotl = require(game:GetService('ReplicatedStorage').TS.games.bedwars.kit.kits.axolotl['axolotl-kit']).AxolotlKit,
                    Beast = require(game:GetService('ReplicatedStorage').TS.games.bedwars.kit.kits.beast['beast-util']).BeastKit,
                    Dasher = require(game:GetService('ReplicatedStorage').TS.games.bedwars.kit.kits.dasher['dasher-kit']).DasherKit,
                    Fisherman = require(game:GetService('ReplicatedStorage').TS.games.bedwars.kit.kits.fisherman['fisherman-util']).FishermanUtil,
                    IceQueen = require(game:GetService('ReplicatedStorage').TS.games.bedwars.kit.kits['ice-queen']['ice-queen-kit']).IceQueenKit,
                    Santa = require(game:GetService('ReplicatedStorage').TS.games.bedwars.kit.kits.santa['santa-util']).SantaUtil,
                }

                v286.Axolotl.SWIM_TO_CHARACTER_TIME = 1e-13
                v286.Axolotl.ACTIVE_COOLDOWN = 1e-13
                v286.Beast.WALK_SPEED_MULTIPLIER = 5
                v286.Beast.KNOCKBACK_MULTIPLIER = 5
                v286.Dasher.DASH_COOLDOWN = 1e-13
                v286.Dasher.CHARGE_TIME = 1e-13
                v286.Dasher.CHARGE_TIME_BEFORE_CHARGING_STATE = 1e-13
                v286.Dasher.TOTAL_CHARGE_TIME = 1e-13
                v286.Fisherman.minigameDuration = 60
                v286.Fisherman.markerSize = UDim2.fromScale(0.05, 1)
                v286.Fisherman.totalDecaySpeedSec = 2
                v286.Fisherman.startingMarkerIncrementSpeed = 0.2
                v286.Fisherman.holdMinimumMarkerIncrementSpeed = 0.1
                v286.Fisherman.markerIncrementAmount = 0.025
                v286.Fisherman.fishZoneSize = UDim2.fromScale(0, 5, 1)
                v286.Fisherman.fishZoneSpeedMultiplier = 5
                v286.Fisherman.fishZoneMoveCooldown = 10
                v286.Fisherman.fillAmount = 0.1
                v286.Fisherman.drainAmount = 0.0001
                v286.IceQueen.DAMAGE_REQUIREMENT = 1e-13
                v286.IceQueen.PASSIVE_STACK_COOLDOWN = 1e-13
                v286.IceQueen.PROC_COOLDOWN = 1e-13
                v286.IceQueen.BAR_COUNT = 4
                v286.IceQueen.BASE_PASSIVE_DAMAGE = 0.1
                v286.IceQueen.BASE_SPEED_MULTIPLIER = 99
                v286.IceQueen.BASE_SLOW_LENGHT = 1e-13
                v286.IceQueen.ICE_SWORD_PASSIVE_DAMAGE = 0.1
                v286.IceQueen.ICE_SWORD_SLOW_LENGTH = 1e-13
                v286.IceQueen.ICE_SWORD_STUN_DURATION = 99
                v286.IceQueen.PASSIVE_EXPIRATION_TIME = 99
                v286.Santa.BOMB_DROP_DELAY = 1e-13
                v286.Santa.TOTAL_BOMBS = 99
                v286.Santa.DROP_HEIGHT = 150
                v286.Santa.DROP_DELAY = 1e-13
            end)
        else
            pcall(function()
                u2.KitExploit = false

                infonotify('ItemExploit', 'Unable to revert changes', '5')
            end)
        end
    end,
    Default = false,
    HoverText = 'Exploits Axolotl, Beast, Dasher, Fisherman, IceQueen and Santa kit settings',
})
v165('VoidwarePrivate', {
    Name = 'ItemExploit',
    Function = function(p287)
        if p287 then
            pcall(function()
                u2.ItemExploit = true

                local _StopwatchConstants = require(game:GetService('ReplicatedStorage').TS.games.bedwars.items.stopwatch['stopwatch-constants']).StopwatchConstants
                local _TwirlbladeUtil = require(game:GetService('ReplicatedStorage').TS.games.bedwars.items.twirlblade['twirlblade-util']).TwirlbladeUtil
                local _ChargeShieldUtil = require(game:GetService('ReplicatedStorage').TS.games.bedwars['charge-shield']['charge-shield-util']).ChargeShieldUtil
                local v291 = require(game:GetService('ReplicatedStorage').TS['grappling-hook']['grappling-hook-util'])
                local v292 = require(game:GetService('ReplicatedStorage').TS.vehicle.helicopter['helicopter-missile'])

                _StopwatchConstants.DURATION = 60
                _StopwatchConstants.EFFECT_DURATION = 60
                _TwirlbladeUtil.SPIN_DAMAGE = 100
                _ChargeShieldUtil.CHARGE_SHIELD_COOLDOWN_SEC = 1e-13
                _ChargeShieldUtil.CHARGE_DURATION = 10
                _ChargeShieldUtil.CHARGE_SPEED_MULTIPLIER = 5
                _ChargeShieldUtil.MAX_HIT_DISTANCE = 50
                _ChargeShieldUtil.MAX_HIT_ANGLE = 360
                _ChargeShieldUtil.MAX_HIT_HEIGHT = 100
                _ChargeShieldUtil.HIT_DAMAGE = 100
                _ChargeShieldUtil.VERTICAL_KNOCKBACK = 5
                _ChargeShieldUtil.HORIZONTAL_KNOCKBACK = 5
                v291.SPEED = 5000
                v291.FIRE_COOLDOWN = 1e-13
                v291.HIT_PLAYER_COOLDOWN = 1e-13
                v291.HIT_BLOCK_COOLDOWN = 1e-13
                v292.MISSLE_FIRE_RATE = 1e-13
            end)
        else
            pcall(function()
                u2.ItemExploit = false

                infonotify('ItemExploit', 'Unable to revert changes', '5')
            end)
        end
    end,
    Default = false,
    HoverText = 'Exploits like 5 item settings settings',
})
v165('VoidwarePrivate', {
    Name = 'MageAnimation',
    Function = function(p293)
        if p293 then
            pcall(function()
                u2.MageAnimation = true

                local _Animate = game:GetService('Players').LocalPlayer.Character.Animate

                _Animate.idle.Animation1.AnimationId = 'http://www.roblox.com/asset/?id=707742142'
                _Animate.idle.Animation2.AnimationId = 'http://www.roblox.com/asset/?id=707855907'
                _Animate.walk.WalkAnim.AnimationId = 'http://www.roblox.com/asset/?id=707897309'
                _Animate.run.RunAnim.AnimationId = 'http://www.roblox.com/asset/?id=707861613'
                _Animate.jump.JumpAnim.AnimationId = 'http://www.roblox.com/asset/?id=707853694'
                _Animate.climb.ClimbAnim.AnimationId = 'http://www.roblox.com/asset/?id=707826056'
                _Animate.fall.FallAnim.AnimationId = 'http://www.roblox.com/asset/?id=707829716'
            end)
        else
            pcall(function()
                u2.MageAnimation = false
            end)
        end
    end,
    Default = false,
    HoverText = 'Makes you get mage animation (FE)',
})
v165('VoidwarePrivate', {
    Name = 'SpamSwordSwing',
    Function = function(p295)
        if p295 then
            pcall(function()
                u2.SpamSwordSwing = true

                while task.wait(0.01) do
                    if not u2.SpamSwordSwing == true then
                        return
                    end

                    require(game:GetService('Players').LocalPlayer.PlayerScripts.TS.controllers.global.combat.sword['sword-controller']).SwordController:swingSwordAtMouse()
                end
            end)
        else
            pcall(function()
                u2.SpamSwordSwing = false
            end)
        end
    end,
    Default = false,
    HoverText = 'Spam swings your sword',
})
v165('VoidwarePrivate', {
    Name = 'NoClickDelay',
    Function = function(p296)
        if p296 then
            pcall(function()
                u2.NoClickDelay = true

                local _SwordController = require(game:GetService('Players').LocalPlayer.PlayerScripts.TS.controllers.global.combat.sword['sword-controller']).SwordController
                local _getItemMeta = require(game:GetService('ReplicatedStorage').TS.item['item-meta']).getItemMeta
                local v299 = debug.getupvalue(_getItemMeta, 1)
                local v300, v301, v302 = pairs(v299)

                while true do
                    local v303

                    v302, v303 = v300(v301, v302)

                    if v302 == nil then
                        break
                    end
                    if type(v303) == 'table' and rawget(v303, 'sword') then
                        v303.sword.attackSpeed = 1e-37
                    end

                    function _SwordController.isClickingTooFast()
                        return false
                    end
                end
            end)
        else
            pcall(function()
                u2.NoClickDelay = false

                local _SwordController2 = require(game:GetService('Players').LocalPlayer.PlayerScripts.TS.controllers.global.combat.sword['sword-controller']).SwordController
                local _getItemMeta2 = require(game:GetService('ReplicatedStorage').TS.item['item-meta']).getItemMeta
                local v306 = debug.getupvalue(_getItemMeta2, 1)
                local v307, v308, v309 = pairs(v306)

                while true do
                    local v310

                    v309, v310 = v307(v308, v309)

                    if v309 == nil then
                        break
                    end
                    if type(v310) == 'table' and rawget(v310, 'sword') then
                        v310.sword.attackSpeed = 0.24
                    end

                    function _SwordController2.isClickingTooFast()
                        return false
                    end
                end
            end)
        end
    end,
    Default = false,
    HoverText = 'Spam swings your sword',
})
v165('VoidwarePrivate', {
    Name = 'AnimDisabler',
    Function = function(p311)
        if p311 then
            pcall(function()
                u2.AnimDisabler = true
                game:GetService('Players').LocalPlayer.Character.Animate.Disabled = true

                while task.wait(1.5) do
                    if not u2.AnimDisabler == true then
                        return
                    end

                    repeat
                        task.wait()
                    until game:GetService('Players').LocalPlayer.Character.Animate

                    game:GetService('Players').LocalPlayer.Character.Animate.Disabled = true
                end
            end)
        else
            pcall(function()
                u2.AnimDisabler = false
                game:GetService('Players').LocalPlayer.Character.Animate.Disabled = false
            end)
        end
    end,
    Default = false,
    HoverText = 'Disables your animation',
})
v165('VoidwarePrivate', {
    Name = 'Shaders',
    Function = function(p312)
        if p312 then
            pcall(function()
                u2.Shaders = true

                game:GetService('Lighting'):ClearAllChildren()

                local _BloomEffect3 = Instance.new('BloomEffect')

                _BloomEffect3.Intensity = 0.1
                _BloomEffect3.Threshold = 0
                _BloomEffect3.Size = 100

                local _Sky4 = Instance.new('Sky')

                _Sky4.Name = 'Tropic'
                _Sky4.SkyboxUp = 'http://www.roblox.com/asset/?id=169210149'
                _Sky4.SkyboxLf = 'http://www.roblox.com/asset/?id=169210133'
                _Sky4.SkyboxBk = 'http://www.roblox.com/asset/?id=169210090'
                _Sky4.SkyboxFt = 'http://www.roblox.com/asset/?id=169210121'
                _Sky4.StarCount = 100
                _Sky4.SkyboxDn = 'http://www.roblox.com/asset/?id=169210108'
                _Sky4.SkyboxRt = 'http://www.roblox.com/asset/?id=169210143'
                _Sky4.Parent = _BloomEffect3

                local _Sky5 = Instance.new('Sky')

                _Sky5.SkyboxUp = 'http://www.roblox.com/asset/?id=196263782'
                _Sky5.SkyboxLf = 'http://www.roblox.com/asset/?id=196263721'
                _Sky5.SkyboxBk = 'http://www.roblox.com/asset/?id=196263721'
                _Sky5.SkyboxFt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky5.CelestialBodiesShown = false
                _Sky5.SkyboxDn = 'http://www.roblox.com/asset/?id=196263643'
                _Sky5.SkyboxRt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky5.Parent = _BloomEffect3
                _BloomEffect3.Parent = game:GetService('Lighting')

                local _BloomEffect4 = Instance.new('BloomEffect')

                _BloomEffect4.Enabled = false
                _BloomEffect4.Intensity = 0.35
                _BloomEffect4.Threshold = 0.2
                _BloomEffect4.Size = 56

                local _Sky6 = Instance.new('Sky')

                _Sky6.Name = 'Tropic'
                _Sky6.SkyboxUp = 'http://www.roblox.com/asset/?id=169210149'
                _Sky6.SkyboxLf = 'http://www.roblox.com/asset/?id=169210133'
                _Sky6.SkyboxBk = 'http://www.roblox.com/asset/?id=169210090'
                _Sky6.SkyboxFt = 'http://www.roblox.com/asset/?id=169210121'
                _Sky6.StarCount = 100
                _Sky6.SkyboxDn = 'http://www.roblox.com/asset/?id=169210108'
                _Sky6.SkyboxRt = 'http://www.roblox.com/asset/?id=169210143'
                _Sky6.Parent = _BloomEffect4

                local _Sky7 = Instance.new('Sky')

                _Sky7.SkyboxUp = 'http://www.roblox.com/asset/?id=196263782'
                _Sky7.SkyboxLf = 'http://www.roblox.com/asset/?id=196263721'
                _Sky7.SkyboxBk = 'http://www.roblox.com/asset/?id=196263721'
                _Sky7.SkyboxFt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky7.CelestialBodiesShown = false
                _Sky7.SkyboxDn = 'http://www.roblox.com/asset/?id=196263643'
                _Sky7.SkyboxRt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky7.Parent = _BloomEffect4
                _BloomEffect4.Parent = game:GetService('Lighting')

                local _BlurEffect2 = Instance.new('BlurEffect')

                _BlurEffect2.Size = 2
                _BlurEffect2.Parent = game:GetService('Lighting')

                local _BlurEffect3 = Instance.new('BlurEffect')

                _BlurEffect3.Name = 'Efecto'
                _BlurEffect3.Enabled = false
                _BlurEffect3.Size = 2
                _BlurEffect3.Parent = game:GetService('Lighting')

                local _ColorCorrectionEffect4 = Instance.new('ColorCorrectionEffect')

                _ColorCorrectionEffect4.Name = 'Inari taisha'
                _ColorCorrectionEffect4.Saturation = 0.05
                _ColorCorrectionEffect4.TintColor = Color3.fromRGB(255, 224, 219)
                _ColorCorrectionEffect4.Parent = game:GetService('Lighting')

                local _ColorCorrectionEffect5 = Instance.new('ColorCorrectionEffect')

                _ColorCorrectionEffect5.Name = 'Normal'
                _ColorCorrectionEffect5.Enabled = false
                _ColorCorrectionEffect5.Saturation = -0.2
                _ColorCorrectionEffect5.TintColor = Color3.fromRGB(255, 232, 215)
                _ColorCorrectionEffect5.Parent = game:GetService('Lighting')

                local _SunRaysEffect3 = Instance.new('SunRaysEffect')

                _SunRaysEffect3.Intensity = 0.05
                _SunRaysEffect3.Parent = game:GetService('Lighting')

                local _Sky8 = Instance.new('Sky')

                _Sky8.Name = 'Sunset'
                _Sky8.SkyboxUp = 'rbxassetid://323493360'
                _Sky8.SkyboxLf = 'rbxassetid://323494252'
                _Sky8.SkyboxBk = 'rbxassetid://323494035'
                _Sky8.SkyboxFt = 'rbxassetid://323494130'
                _Sky8.SkyboxDn = 'rbxassetid://323494368'
                _Sky8.SunAngularSize = 14
                _Sky8.SkyboxRt = 'rbxassetid://323494067'
                _Sky8.Parent = game:GetService('Lighting')

                local _ColorCorrectionEffect6 = Instance.new('ColorCorrectionEffect')

                _ColorCorrectionEffect6.Name = 'Takayama'
                _ColorCorrectionEffect6.Enabled = false
                _ColorCorrectionEffect6.Saturation = -0.3
                _ColorCorrectionEffect6.Contrast = 0.1
                _ColorCorrectionEffect6.TintColor = Color3.fromRGB(235, 214, 204)
                _ColorCorrectionEffect6.Parent = game:GetService('Lighting')

                local _Lighting7 = game:GetService('Lighting')

                _Lighting7.Brightness = 2.14
                _Lighting7.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
                _Lighting7.ColorShift_Top = Color3.fromRGB(240, 127, 14)
                _Lighting7.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
                _Lighting7.ClockTime = 6.7
                _Lighting7.FogColor = Color3.fromRGB(94, 76, 106)
                _Lighting7.FogEnd = 1000
                _Lighting7.FogStart = 0
                _Lighting7.ExposureCompensation = 0.24
                _Lighting7.ShadowSoftness = 0
                _Lighting7.Ambient = Color3.fromRGB(59, 33, 27)

                local _BloomEffect5 = Instance.new('BloomEffect')

                _BloomEffect5.Intensity = 0.1
                _BloomEffect5.Threshold = 0
                _BloomEffect5.Size = 100

                local _Sky9 = Instance.new('Sky')

                _Sky9.Name = 'Tropic'
                _Sky9.SkyboxUp = 'http://www.roblox.com/asset/?id=169210149'
                _Sky9.SkyboxLf = 'http://www.roblox.com/asset/?id=169210133'
                _Sky9.SkyboxBk = 'http://www.roblox.com/asset/?id=169210090'
                _Sky9.SkyboxFt = 'http://www.roblox.com/asset/?id=169210121'
                _Sky9.StarCount = 100
                _Sky9.SkyboxDn = 'http://www.roblox.com/asset/?id=169210108'
                _Sky9.SkyboxRt = 'http://www.roblox.com/asset/?id=169210143'
                _Sky9.Parent = _BloomEffect5

                local _Sky10 = Instance.new('Sky')

                _Sky10.SkyboxUp = 'http://www.roblox.com/asset/?id=196263782'
                _Sky10.SkyboxLf = 'http://www.roblox.com/asset/?id=196263721'
                _Sky10.SkyboxBk = 'http://www.roblox.com/asset/?id=196263721'
                _Sky10.SkyboxFt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky10.CelestialBodiesShown = false
                _Sky10.SkyboxDn = 'http://www.roblox.com/asset/?id=196263643'
                _Sky10.SkyboxRt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky10.Parent = _BloomEffect5
                _BloomEffect5.Parent = game:GetService('Lighting')

                local _BloomEffect6 = Instance.new('BloomEffect')

                _BloomEffect6.Enabled = false
                _BloomEffect6.Intensity = 0.35
                _BloomEffect6.Threshold = 0.2
                _BloomEffect6.Size = 56

                local _Sky11 = Instance.new('Sky')

                _Sky11.Name = 'Tropic'
                _Sky11.SkyboxUp = 'http://www.roblox.com/asset/?id=169210149'
                _Sky11.SkyboxLf = 'http://www.roblox.com/asset/?id=169210133'
                _Sky11.SkyboxBk = 'http://www.roblox.com/asset/?id=169210090'
                _Sky11.SkyboxFt = 'http://www.roblox.com/asset/?id=169210121'
                _Sky11.StarCount = 100
                _Sky11.SkyboxDn = 'http://www.roblox.com/asset/?id=169210108'
                _Sky11.SkyboxRt = 'http://www.roblox.com/asset/?id=169210143'
                _Sky11.Parent = _BloomEffect6

                local _Sky12 = Instance.new('Sky')

                _Sky12.SkyboxUp = 'http://www.roblox.com/asset/?id=196263782'
                _Sky12.SkyboxLf = 'http://www.roblox.com/asset/?id=196263721'
                _Sky12.SkyboxBk = 'http://www.roblox.com/asset/?id=196263721'
                _Sky12.SkyboxFt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky12.CelestialBodiesShown = false
                _Sky12.SkyboxDn = 'http://www.roblox.com/asset/?id=196263643'
                _Sky12.SkyboxRt = 'http://www.roblox.com/asset/?id=196263721'
                _Sky12.Parent = _BloomEffect6
                _BloomEffect6.Parent = game:GetService('Lighting')

                local _BlurEffect4 = Instance.new('BlurEffect')

                _BlurEffect4.Size = 2
                _BlurEffect4.Parent = game:GetService('Lighting')

                local _BlurEffect5 = Instance.new('BlurEffect')

                _BlurEffect5.Name = 'Efecto'
                _BlurEffect5.Enabled = false
                _BlurEffect5.Size = 4
                _BlurEffect5.Parent = game:GetService('Lighting')

                local _ColorCorrectionEffect7 = Instance.new('ColorCorrectionEffect')

                _ColorCorrectionEffect7.Name = 'Inari taisha'
                _ColorCorrectionEffect7.Saturation = 0.05
                _ColorCorrectionEffect7.TintColor = Color3.fromRGB(255, 224, 219)
                _ColorCorrectionEffect7.Parent = game:GetService('Lighting')

                local _ColorCorrectionEffect8 = Instance.new('ColorCorrectionEffect')

                _ColorCorrectionEffect8.Name = 'Normal'
                _ColorCorrectionEffect8.Enabled = false
                _ColorCorrectionEffect8.Saturation = -0.2
                _ColorCorrectionEffect8.TintColor = Color3.fromRGB(255, 232, 215)
                _ColorCorrectionEffect8.Parent = game:GetService('Lighting')

                local _SunRaysEffect4 = Instance.new('SunRaysEffect')

                _SunRaysEffect4.Intensity = 0.05
                _SunRaysEffect4.Parent = game:GetService('Lighting')

                local _Sky13 = Instance.new('Sky')

                _Sky13.Name = 'Sunset'
                _Sky13.SkyboxUp = 'rbxassetid://323493360'
                _Sky13.SkyboxLf = 'rbxassetid://323494252'
                _Sky13.SkyboxBk = 'rbxassetid://323494035'
                _Sky13.SkyboxFt = 'rbxassetid://323494130'
                _Sky13.SkyboxDn = 'rbxassetid://323494368'
                _Sky13.SunAngularSize = 14
                _Sky13.SkyboxRt = 'rbxassetid://323494067'
                _Sky13.Parent = game:GetService('Lighting')

                local _ColorCorrectionEffect9 = Instance.new('ColorCorrectionEffect')

                _ColorCorrectionEffect9.Name = 'Takayama'
                _ColorCorrectionEffect9.Enabled = false
                _ColorCorrectionEffect9.Saturation = -0.3
                _ColorCorrectionEffect9.Contrast = 0.1
                _ColorCorrectionEffect9.TintColor = Color3.fromRGB(235, 214, 204)
                _ColorCorrectionEffect9.Parent = game:GetService('Lighting')

                local _Lighting8 = game:GetService('Lighting')

                _Lighting8.Brightness = 2.3
                _Lighting8.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
                _Lighting8.ColorShift_Top = Color3.fromRGB(240, 127, 14)
                _Lighting8.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
                _Lighting8.TimeOfDay = '07:30:00'
                _Lighting8.FogColor = Color3.fromRGB(94, 76, 106)
                _Lighting8.FogEnd = 300
                _Lighting8.FogStart = 0
                _Lighting8.ExposureCompensation = 0.24
                _Lighting8.ShadowSoftness = 0
                _Lighting8.Ambient = Color3.fromRGB(59, 33, 27)
            end)
        else
            pcall(function()
                u2.Shaders = false

                infonotify('Shaders', 'Unable to revert changes', 5)
            end)
        end
    end,
    Default = false,
    HoverText = 'Cool shader',
})
v165('VoidwarePrivate', {
    Name = 'HostCrasher',
    Function = function(p341)
        if p341 then
            pcall(function()
                u2.HostCrasher = true

                local v342, v343, v344 = pairs(game:GetService('Players'):GetChildren())

                while true do
                    local v345

                    v344, v345 = v342(v343, v344)

                    if v344 == nil then
                        break
                    end

                    local v346 = {
                        '',
                        {
                            {
                                userId = v345.UserId,
                                name = v345.Name,
                                displayName = v345.DisplayName,
                            },
                        },
                    }

                    game:GetService('ReplicatedStorage').rbxts_include.node_modules.net.out._NetManaged:FindFirstChild('CustomMatches:CohostPlayer'):FireServer(unpack(v346))
                end
                while task.wait() do
                    if not u2.HostCrasher == true then
                        return
                    end

                    local v347, v348, v349 = pairs(game:GetService('Players'):GetChildren())

                    while true do
                        local v350

                        v349, v350 = v347(v348, v349)

                        if v349 == nil then
                            break
                        end

                        local v351 = {
                            '',
                            {
                                {
                                    userId = v350.UserId,
                                    name = v350.Name,
                                    displayName = v350.DisplayName,
                                },
                                math.random(1, 999999999),
                            },
                        }

                        game:GetService('ReplicatedStorage').rbxts_include.node_modules.net.out._NetManaged:FindFirstChild('CustomMatches:SetPlayerMaxHealth'):FireServer(unpack(v351))
                    end
                end
            end)
        else
            pcall(function()
                u2.HostCrasher = false
            end)
        end
    end,
    Default = false,
    HoverText = 'Requires you to be host to let it work',
})
v165('VoidwarePrivate', {
    Name = 'Crosshair',
    Function = function(p352)
        if p352 then
            pcall(function()
                u2.Crosshair = true

                local u353 = game:GetService('Players').LocalPlayer:GetMouse()

                u353.Icon = 'rbxassetid://9943168532'

                local v354 = u353

                u353.GetPropertyChangedSignal(v354, 'Icon'):Connect(function()
                    if not u2.Crosshair ~= true then
                        u353.Icon = 'rbxassetid://9943168532'
                    end
                end)
            end)
        else
            pcall(function()
                u2.Crosshair = false
                game:GetService('Players').LocalPlayer:GetMouse().Icon = ''
            end)
        end
    end,
    Default = false,
    HoverText = 'Custom crosshair',
})
v165('VoidwarePrivate', {
    Name = 'Night',
    Function = function(p355)
        if p355 then
            pcall(function()
                u2.Night = true
                game:GetService('Lighting').TimeOfDay = '00:00:00'

                while task.wait(5) do
                    if not u2.Night == true then
                        return
                    end

                    game:GetService('Lighting').TimeOfDay = '00:00:00'
                end
            end)
        else
            pcall(function()
                u2.Night = false
                game:GetService('Lighting').TimeOfDay = '13:00:00'
            end)
        end
    end,
    Default = false,
    HoverText = 'Cool night render',
})
v165('VoidwarePrivate', {
    Name = 'ChatCrasher',
    Function = function(p356)
        if p356 then
            pcall(function()
                u2.ChatCrasher = true

                while task.wait() do
                    if not u2.ChatCrasher == true then
                        return
                    end

                    game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer('\u{fffd}\u{fffd}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}\u{1cbc}', 'All')
                end
            end)
        else
            pcall(function()
                u2.ChatCrasher = false
            end)
        end
    end,
    Default = false,
    HoverText = 'cool',
})
v165('VoidwarePrivate', {
    Name = 'CustomAntivoid',
    Function = function(p357)
        if p357 then
            pcall(function()
                u2.CustomAntivoid = true

                local _Part2 = Instance.new('Part')

                _Part2.Name = 'AVOID_PART'
                _Part2.Anchored = true
                _Part2.Color = Color3.fromRGB(255, 65, 65)
                _Part2.Size = Vector3.new(5000, 3, 5000)
                _Part2.Parent = game:GetService('Workspace')
                _Part2.CFrame = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame - Vector3.new(0, 20, 0)
                u2.CustomAntivoid_Part = _Part2

                _Part2.Touched:Connect(function(p359)
                    if p359.Parent:FindFirstChild('Humanoid') and (p359.Parent.Parent.Name == game:GetService('Players').LocalPlayer.Name and not p359.Parent:FindFirstChild('Humanoid').Health == 0) then
                        game:GetService('Players').LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.12)
                        game:GetService('Players').LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.12)
                        game:GetService('Players').LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.12)
                        game:GetService('Players').LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end)
        else
            pcall(function()
                u2.CustomAntivoid = false

                u2.CustomAntivoid_Part:Destroy()
            end)
        end
    end,
    Default = false,
    HoverText = 'custom anti void (broken on beach map)',
})
v165('VoidwarePrivate', {
    Name = 'RagdollDisabler',
    Function = function(p360)
        if p360 then
            pcall(function()
                u2.RagdollDisabler = true

                while task.wait(0.1) do
                    if not u2.RagdollDisabler == true then
                        return
                    end

                    game:GetService('Players').LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
                    task.wait(0.085)
                    game:GetService('Players').LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        else
            pcall(function()
                u2.RagdollDisabler = false
            end)
        end
    end,
    Default = false,
    HoverText = 'Makes you ragdoll to bypass anticheat',
})
v165('VoidwarePrivate', {
    Name = 'LandmindeAura',
    Function = function(p361)
        if p361 then
            pcall(function()
                u2.LandmindeAura = true

                while task.wait(0.15) do
                    if not u2.LandmindeAura == true then
                        return
                    end

                    local v362, v363, v364 = pairs(game:GetService('Players'):GetChildren())

                    while true do
                        local v365

                        v364, v365 = v362(v363, v364)

                        if v364 == nil then
                            break
                        end
                        if not v365.Name == game:GetService('Players').LocalPlayer.Name and ((v365.Character:FindFirstChild('HumanoidRootPart').Position - game:GetService('Players').LocalPlayer.Character:FindFirstChild('Humanoid').Position).magnitude > 11 and (not v365.Team.BrickColor == game:GetService('Players').LocalPlayer.Team.BrickColor and not v365.Team.Name == game:GetService('Players').LocalPlayer.Team.Name)) then
                            game:GetService('ReplicatedStorage').rbxts_include.node_modules.net.out._NetManaged.landmineremote:FireServer({
                                invisibleLandmine = v365.Character:FindFirstChild('Head'),
                            })
                        end
                    end
                end
            end)
        else
            pcall(function()
                u2.LandmindeAura = false
            end)
        end
    end,
    Default = false,
    HoverText = '(Actually) a dumb aura i made',
})

local u366 = nil

v165('VoidwarePrivate', {
    Name = 'BiMode',
    Function = function(p367)
        if p367 then
            pcall(function()
                u2.BiMode = true
                game:GetService('Lighting').Ambient = Color3.fromRGB(130, 12, 110)
                game:GetService('Lighting').OutdoorAmbient = Color3.fromRGB(130, 12, 110)
                game:GetService('Lighting').ColorShift_Bottom = Color3.fromRGB(130, 12, 110)
                game:GetService('Lighting').ColorShift_Top = Color3.fromRGB(130, 12, 110)
                game:GetService('Lighting').TimeOfDay = '03:00:00'
                game:GetService('Lighting').FogColor = Color3.fromRGB(130, 12, 110)
                game:GetService('Lighting').FogStart = 500
                game:GetService('Lighting').FogEnd = 100000
                game:GetService('Lighting').ExposureCompensation = 1
                u366 = Instance.new('Blur')

                local v368 = u366

                v368.Size = 4
                v368.Name = game:GetService('HttpService'):GenerateGUID(true)
            end)
        else
            pcall(function()
                u2.BiMode = false
                game:GetService('Lighting').Ambient = Color3.fromRGB(165, 165, 165)
                game:GetService('Lighting').OutdoorAmbient = Color3.fromRGB(104, 104, 104)
                game:GetService('Lighting').ColorShift_Bottom = Color3.fromRGB(146, 190, 255)
                game:GetService('Lighting').ColorShift_Top = Color3.fromRGB(228, 249, 255)
                game:GetService('Lighting').TimeOfDay = '13:00:00'
                game:GetService('Lighting').FogColor = Color3.fromRGB(255, 255, 255)
                game:GetService('Lighting').FogStart = 0
                game:GetService('Lighting').FogEnd = 100000
                game:GetService('Lighting').ExposureCompensation = 0

                if u366 then
                    u366:Destroy()
                end
            end)
        end
    end,
    Default = false,
    HoverText = 'ok',
})
v165('VoidwarePrivate', {
    Name = 'InviteCrash',
    Function = function(p369)
        if p369 then
            pcall(function()
                u2.InviteCrash = true

                while task.wait() do
                    if not u2.InviteCrash == true then
                        return
                    end

                    local v370, v371, v372 = pairs(game:GetService('Players'):GetChildren())

                    while true do
                        local v373

                        v372, v373 = v370(v371, v372)

                        if v372 == nil then
                            break
                        end
                        if not v373.Name == game:GetService('Players').LocalPlayer.Name then
                            local _inviteToParty = game:GetService('ReplicatedStorage')['events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events'].inviteToParty
                            local _FireServer = _inviteToParty.FireServer
                            local v376 = {
                                player = game:GetService('Players')[v373.Name],
                            }

                            _FireServer(_inviteToParty, v376)
                        end
                    end
                end
            end)
        else
            pcall(function()
                u2.InviteCrash = false
            end)
        end
    end,
    Default = false,
    HoverText = 'Spam invites other players',
})

local _LocalPlayer3 = game:GetService('Players').LocalPlayer
local u379 = getsynasset or (getcustomasset or function(p378)
    return 'rbxasset://' .. p378
end)
local _PlayerList = game:GetService('CoreGui'):FindFirstChild('PlayerList')

if _PlayerList then
    pcall(function()
        local v381 = _PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame:FindFirstChild('p_' .. _LocalPlayer3.UserId)

        if v381 then
            v381.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = u379('vape/VapeIcon.png')
        end
    end)
end

v165('VoidwarePrivate', {
    Name = 'BallChanger',
    Function = function(p382)
        if p382 then
            pcall(function()
                local _UserInputService = game:GetService('UserInputService')
                local _RunService = game:GetService('RunService')
                local _CurrentCamera2 = workspace.CurrentCamera
                local _Character = game.Players.LocalPlayer.Character
                local v387, v388, v389 = ipairs(_Character:GetDescendants())
                local u390 = 30
                local u391 = 0.3
                local u392 = 60

                while true do
                    local v393, v394 = v387(v388, v389)

                    if v393 == nil then
                        break
                    end

                    v389 = v393

                    if v394:IsA('BasePart') then
                        v394.CanCollide = false
                    end
                end

                local _HumanoidRootPart2 = _Character.HumanoidRootPart

                _HumanoidRootPart2.Shape = Enum.PartType.Ball
                _HumanoidRootPart2.Size = Vector3.new(5, 5, 5)

                local _Humanoid = _Character:WaitForChild('Humanoid')
                local u397 = RaycastParams.new()

                u397.FilterType = Enum.RaycastFilterType.Blacklist
                u397.FilterDescendantsInstances = {_Character}

                local u399 = _RunService.RenderStepped:Connect(function(p398)
                    _HumanoidRootPart2.CanCollide = true
                    _Humanoid.PlatformStand = true

                    if not _UserInputService:GetFocusedTextBox() then
                        if _UserInputService:IsKeyDown('W') then
                            _HumanoidRootPart2.RotVelocity = _HumanoidRootPart2.RotVelocity - _CurrentCamera2.CFrame.RightVector * p398 * u390
                        end
                        if _UserInputService:IsKeyDown('A') then
                            _HumanoidRootPart2.RotVelocity = _HumanoidRootPart2.RotVelocity - _CurrentCamera2.CFrame.LookVector * p398 * u390
                        end
                        if _UserInputService:IsKeyDown('S') then
                            _HumanoidRootPart2.RotVelocity = _HumanoidRootPart2.RotVelocity + _CurrentCamera2.CFrame.RightVector * p398 * u390
                        end
                        if _UserInputService:IsKeyDown('D') then
                            _HumanoidRootPart2.RotVelocity = _HumanoidRootPart2.RotVelocity + _CurrentCamera2.CFrame.LookVector * p398 * u390
                        end
                    end
                end)

                _UserInputService.JumpRequest:Connect(function()
                    if workspace:Raycast(_HumanoidRootPart2.Position, Vector3.new(0, -(_HumanoidRootPart2.Size.Y / 2 + u391), 0), u397) then
                        _HumanoidRootPart2.Velocity = _HumanoidRootPart2.Velocity + Vector3.new(0, u392, 0)
                    end
                end)

                _CurrentCamera2.CameraSubject = _HumanoidRootPart2

                _Humanoid.Died:Connect(function()
                    u399:Disconnect()
                end)
            end)
        end
    end,
    HoverText = 'idk',
})
v165('VoidwarePrivate', {
    Name = 'WinStreakTracker',
    Function = function(p400)
        if p400 then
            pcall(function()
                wait(2)

                if shared.VapeExecuted then
                    spawn(function()
                        local _Players3 = game:GetService('Players')
                        local _LocalPlayer4 = _Players3.LocalPlayer
                        local _TextLabel = Instance.new('TextLabel')

                        _TextLabel.TextSize = 17
                        _TextLabel.Name = 'WinStreakTracker'
                        _TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                        _TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
                        _TextLabel.TextColor3 = Color3.new(1, 1, 1)
                        _TextLabel.BackgroundTransparency = 1
                        _TextLabel.Text = ' '
                        _TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel.Active = false
                        _TextLabel.Font = Enum.Font.SourceSansBold
                        _TextLabel.TextStrokeTransparency = 0
                        _TextLabel.Parent = game.CoreGui.RobloxGui

                        local function v410()
                            local v404 = _Players3
                            local v405, v406, v407 = pairs(v404:GetChildren())
                            local v408 = '-- WINSTREAK TRACKER --'

                            while true do
                                local v409

                                v407, v409 = v405(v406, v407)

                                if v407 == nil then
                                    break
                                end
                                if v409:GetAttribute('WinStreak') and (v409:GetAttribute('WinStreak') > 0 and v409 ~= _LocalPlayer4) then
                                    v408 = v408 .. '\n' .. (v409.DisplayName or v409.Name) .. ' : ' .. v409:GetAttribute('WinStreak')
                                end
                            end

                            _TextLabel.Text = v408
                        end

                        v410()

                        repeat
                            wait(3)
                            v410()
                        until true == false
                    end)
                end
            end)
        end
    end,
    HoverText = 'working in lobby only',
})
