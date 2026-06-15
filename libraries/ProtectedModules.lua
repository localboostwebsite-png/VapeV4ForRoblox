local v1 = {}
local u2 = nil

if shared.GuiLibrary then
    u2 = shared.GuiLibrary
else
    warn('GuiLibrary not found!')
end

local _Players = game:GetService('Players')

game:GetService('TextService')
game:GetService('Lighting')
game:GetService('TextChatService')
game:GetService('UserInputService')
game:GetService('RunService')
game:GetService('TweenService')
game:GetService('CollectionService')
game:GetService('ReplicatedStorage')

local _CurrentCamera = workspace.CurrentCamera
local _LocalPlayer = _Players.LocalPlayer

local function u12(p6, p7, p8)
    local v11, v11 = pcall(function()
        local v9 = u2.CreateNotification(p6, p7, p8, 'assets/InfoNotification.png')

        v9.Frame.Frame.ImageColor3 = Color3.fromRGB(255, 0, 255)

        return v9
    end)

    return v11
end

local u13

if shared.vapeConnections and type(shared.vapeConnections) == 'table' then
    u13 = shared.vapeConnections
else
    u13 = {}
    shared.vapeConnections = u13
end

local u287 = {
    [6872274481] = function()
        if shared.GlobalStore then
            local _ = shared.GlobalStore
        end

        run(function()
            local _TweenService = game:GetService('TweenService')
            local _LocalPlayer2 = game:GetService('Players').LocalPlayer
            local v16

            if shared.vapeConnections and type(shared.vapeConnections) == 'table' then
                v16 = shared.vapeConnections
            else
                v16 = {}
                shared.vapeConnections = v16
            end

            local function u23(p17, p18, p19)
                local v22, v22 = pcall(function()
                    local v20 = u2.CreateNotification(p17, p18, p19, 'assets/InfoNotification.png')

                    v20.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)

                    return v20
                end)

                return v22
            end

            local u24 = nil
            local u25 = {Enabled = false}
            local u26 = 0.7
            local u27 = 5

            local function u33(p28, p29)
                local _HumanoidRootPart = p28:FindFirstChild('HumanoidRootPart')

                if _HumanoidRootPart then
                    local v31 = p29 + Vector3.new(0, u27, 0)

                    if (v31 - _HumanoidRootPart.Position).Magnitude > 0.5 then
                        local v32 = _TweenService:Create(_HumanoidRootPart, TweenInfo.new(u26, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                            CFrame = CFrame.new(v31),
                        })

                        v32:Play()
                        v32.Completed:Wait()
                    end
                end
            end
            local function u37(p34)
                local _Character = p34.Character
                local v36 = _Character and _Character:FindFirstChildOfClass('Humanoid')

                if v36 then
                    v36.Health = 0
                end
            end
            local function v39(p38)
                if u24 then
                    task.spawn(function()
                        if p38:WaitForChild('HumanoidRootPart', 9000000000) and u24 then
                            u33(p38, u24)

                            u24 = nil
                        end
                    end)
                end
            end

            v16[#v16 + 1] = _LocalPlayer2.CharacterAdded:Connect(v39)

            local function u50()
                local _UserInputService = game:GetService('UserInputService')
                local _TouchEnabled = _UserInputService.TouchEnabled

                if _TouchEnabled then
                    _TouchEnabled = not _UserInputService.KeyboardEnabled
                end
                if _TouchEnabled then
                    u23('DeathTP', 'Please tap on the screen to set TP position.', 3)

                    local u42 = nil

                    u42 = _UserInputService.TouchTapInWorld:Connect(function(_, p43)
                        if not p43 then
                            local _UnitRay = _LocalPlayer2:GetMouse().UnitRay
                            local v45 = RaycastParams.new()

                            v45.FilterDescendantsInstances = {
                                workspace.Map,
                                workspace:FindFirstChild('SpectatorPlatform'),
                            }
                            v45.FilterType = Enum.RaycastFilterType.Whitelist

                            local v46 = workspace:Raycast(_UnitRay.Origin, _UnitRay.Direction * 10000, v45)

                            if v46 then
                                u24 = v46.Position

                                u23('DeathTP', 'Set TP Position. Resetting to teleport...', 3)
                                u37(_LocalPlayer2)
                            end

                            u42:Disconnect()
                            u25.ToggleButton(false)
                        end
                    end)
                else
                    local _UnitRay2 = _LocalPlayer2:GetMouse().UnitRay
                    local v48 = RaycastParams.new()

                    v48.FilterDescendantsInstances = {
                        workspace.Map,
                        workspace:FindFirstChild('SpectatorPlatform'),
                    }
                    v48.FilterType = Enum.RaycastFilterType.Whitelist

                    local v49 = workspace:Raycast(_UnitRay2.Origin, _UnitRay2.Direction * 10000, v48)

                    if v49 then
                        u24 = v49.Position

                        u23('DeathTP', 'Set TP Position. Resetting to teleport...', 3)
                        u37(_LocalPlayer2)
                    end

                    u25.ToggleButton(false)
                end
            end

            local v54 = {
                Name = 'DeathTP',
                Function = function(p51)
                    if p51 then
                        if (function()
                            local v53, v53 = pcall(function()
                                return _LocalPlayer2.leaderstats.Bed.Value == '\u{fffd}\u{fffd}'
                            end)

                            return v53
                        end)() then
                            u50()
                        else
                            u23('DeathTP', 'Unable to use DeathTP without bed!', 5)
                            u25.ToggleButton()
                        end
                    end
                end,
            }

            u25 = u2.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton(v54)
        end)

        function IsAlive(p55)
            local v56 = p55 or _LocalPlayer

            if v56.Character then
                if v56.Character:FindFirstChild('Head') then
                    if v56.Character:FindFirstChild('Humanoid') then
                        return v56.Character:FindFirstChild('Humanoid').Health >= 0.11
                    else
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        end

        run(function()
            local u57 = {Enabled = false}
            local v68 = {
                Name = 'AntiHit/Godmode',
                Function = function(p58)
                    if p58 then
                        spawn(function()
                            while task.wait() do
                                if not u57.Enabled then
                                    return
                                end
                                if not (u2.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled or u2.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled) then
                                    local v59, v60, v61 = pairs(game:GetService('Players'):GetChildren())

                                    while true do
                                        local v62

                                        v61, v62 = v59(v60, v61)

                                        if v61 == nil then
                                            break
                                        end
                                        if v62.Team ~= _LocalPlayer.Team and (IsAlive(v62) and (IsAlive(_LocalPlayer) and (v62 and v62 ~= _LocalPlayer))) and (_LocalPlayer:DistanceFromCharacter(v62.Character:FindFirstChild('HumanoidRootPart').CFrame.p) < 25 and not _LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass('BodyVelocity')) then
                                            repeat
                                                task.wait()
                                            until shared.GlobalStore.matchState ~= 0

                                            if v62.Character.HumanoidRootPart.Velocity.Y >= -50 then
                                                _LocalPlayer.Character.Archivable = true

                                                local u63 = _LocalPlayer.Character:Clone()

                                                u63.Parent = workspace

                                                u63.Head:ClearAllChildren()

                                                _CurrentCamera.CameraSubject = u63:FindFirstChild('Humanoid')

                                                local v64, v65, v66 = pairs(u63:GetChildren())

                                                while true do
                                                    local v67

                                                    v66, v67 = v64(v65, v66)

                                                    if v66 == nil then
                                                        break
                                                    end
                                                    if string.lower(v67.ClassName):find('part') and v67.Name ~= 'HumanoidRootPart' then
                                                        v67.Transparency = 1
                                                    end
                                                    if v67:IsA('Accessory') then
                                                        v67:FindFirstChild('Handle').Transparency = 1
                                                    end
                                                end

                                                _LocalPlayer.Character.HumanoidRootPart.CFrame = _LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100000, 0)

                                                game:GetService('RunService').RenderStepped:Connect(function()
                                                    if u63 ~= nil and u63:FindFirstChild('HumanoidRootPart') then
                                                        u63.HumanoidRootPart.Position = Vector3.new(_LocalPlayer.Character.HumanoidRootPart.Position.X, u63.HumanoidRootPart.Position.Y, _LocalPlayer.Character.HumanoidRootPart.Position.Z)
                                                    end
                                                end)
                                                task.wait(0.3)

                                                _LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(_LocalPlayer.Character.HumanoidRootPart.Velocity.X, -1, _LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
                                                _LocalPlayer.Character.HumanoidRootPart.CFrame = u63.HumanoidRootPart.CFrame
                                                _CurrentCamera.CameraSubject = _LocalPlayer.Character:FindFirstChild('Humanoid')

                                                u63:Destroy()
                                                task.wait(0.15)
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end,
            }

            u57 = u2.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton(v68)

            u57.CreateCredits({
                Name = 'CreditsButtonInstance',
                Credits = 'Nebula',
            })
        end)
        run(function()
            local u69 = {}
            local u70 = {
                Value = 'Shield',
            }
            local u71 = {
                Shield = function()
                    return game:GetService('ReplicatedStorage'):WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('UpgradeFrostyHammer'):InvokeServer(unpack({
                        'shield',
                    }))
                end,
                Speed = function()
                    return game:GetService('ReplicatedStorage'):WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('UpgradeFrostyHammer'):InvokeServer(unpack({
                        'speed',
                    }))
                end,
                Strength = function()
                    return game:GetService('ReplicatedStorage'):WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('UpgradeFrostyHammer'):InvokeServer(unpack({
                        'strength',
                    }))
                end,
            }
            local u72 = 'Shield'
            local u73 = true
            local v97 = {
                Name = 'AdetundeExploit',
                Function = function(p74)
                    if p74 then
                        u72 = u70.Value

                        task.spawn(function()
                            while true do
                                local v75 = u71[u72]()

                                if type(v75) == 'table' then
                                    break
                                end

                                local v76, v77, v78 = pairs(u71)
                                local v79 = {}

                                while true do
                                    local v80

                                    v78, v80 = v76(v77, v78)

                                    if v78 == nil then
                                        break
                                    end

                                    table.insert(v79, v78)
                                end

                                local v81, v82, v83 = pairs(v79)

                                while true do
                                    local v84

                                    v83, v84 = v81(v82, v83)

                                    if v83 == nil then
                                        break
                                    end
                                    if v79[v83] == u72 then
                                        table.remove(v79, v83)
                                    end
                                end

                                u72 = v79[math.random(1, #v79)]

                                task.wait(0.1)

                                if not u69.Enabled or u73 == false then
                                    return
                                end
                            end

                            local _speed = v75.speed
                            local _strength = v75.strength
                            local _shield = v75.shield

                            print('Speed: ' .. tostring(_speed))
                            print('Strength: ' .. tostring(_strength))
                            print('Shield: ' .. tostring(_shield))
                            print('Current Upgrador: ' .. tostring(u72))

                            if v75[string.lower(u72)] ~= 3 or (not _strength or (not _shield or (not _speed or _strength ~= 3 and (_speed ~= 3 and _shield ~= 3)))) then
                            end
                            if _strength == 3 and (_speed == 2 and _shield == 2) or (_strength == 2 and (_speed == 3 and _shield == 2) or _strength == 2 and (_speed == 2 and _shield == 3)) then
                                u12('AdetundeExploit', 'Fully upgraded everything possible!', 7)

                                u73 = false
                            else
                                local v88, v89, v90 = pairs(u71)
                                local v91 = {}

                                while true do
                                    local v92

                                    v90, v92 = v88(v89, v90)

                                    if v90 == nil then
                                        break
                                    end

                                    table.insert(v91, v90)
                                end

                                local v93, v94, v95 = pairs(v91)

                                while true do
                                    local v96

                                    v95, v96 = v93(v94, v95)

                                    if v95 == nil then
                                        break
                                    end
                                    if v91[v95] == u72 then
                                        table.remove(v91, v95)
                                    end
                                end

                                u72 = v91[math.random(1, #v91)]
                            end
                        end)
                    end
                end,
            }

            u69 = u2.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton(v97)

            local v98, v99, v100 = pairs(u71)
            local v101 = u69
            local v102 = {}

            while true do
                local v103

                v100, v103 = v98(v99, v100)

                if v100 == nil then
                    break
                end

                table.insert(v102, v100)
            end

            u70 = v101.CreateDropdown({
                Name = 'Preferred Upgrade',
                List = v102,
                Function = function() end,
                Default = 'Shield',
            })
        end)

        local u104 = 0

        run('ReportDetector', function()
            local function u111(p105, p106, p107)
                local v110, v110 = pcall(function()
                    local v108 = u2.CreateNotification(p105, p106, p107 or 6.5, 'assets/WarningNotification.png')

                    v108.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
                    v108.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
                end)

                return v110
            end
            local function u118(p112, p113, p114, p115)
                local v117, v117 = pcall(function()
                    return u2.CreateNotification(p112 or 'Voidware', p113 or 'Successfully called function', p114 or 7, 'assets/InfoNotification.png', p115)
                end)

                return v117
            end

            local u119 = {}
            local u120 = {
                Value = 'Self',
            }
            local u121 = {
                Value = '',
            }
            local u122 = {
                Value = '',
            }
            local u123 = {Enabled = true}
            local _LocalPlayer3 = game:GetService('Players').LocalPlayer

            local function u140(p125)
                local v133 = {
                    {
                        Name = 'Yes',
                        Function = function()
                            local v126 = game:GetService('HttpService'):JSONEncode(p125)

                            writefile('LoggedReports.txt', v126);
                            (function(p127, p128, p129, p130)
                                local v132, v132 = pcall(function()
                                    return u2.CreateNotification(p127 or 'Voidware', p128 or 'Successfully called function', p129 or 7, 'assets/InfoNotification.png', p130)
                                end)

                                return v132
                            end)('ReportDetector-LogSaver', "Successfully logged the Reports Data to LoggedReports.txt in your executor's workspace folder!", 7)
                        end,
                    },
                    {
                        Name = 'No',
                        Function = function() end,
                    },
                }

                (function(p134, p135, p136, p137)
                    local v139, v139 = pcall(function()
                        return u2.CreateInteractableNotification(p134 or 'Voidware', p135 or 'Successfully called function', p136 or 7, 'assets/InfoNotification.png', p137)
                    end)

                    return v139
                end)('ReportDetector-LogSaver', 'Would you like to save this log to your files?', 100000000, v133)
            end
            local function u141()
                u104 = 10

                task.spawn(function()
                    repeat
                        u104 = u104 - 1

                        task.wait(1)
                    until u104 < 1

                    u104 = 0
                end)
            end
            local function u143(p142)
                if p142 then
                    warn('StatusCode: ' .. tostring(p142))
                end

                u111('ReportDetector', 'Error making request! Please wait 10 seconds', 3)
                u141()
            end
            local function u144()
                if u120.Value == 'Self' then
                    return _LocalPlayer3.Name
                end
                if u120.Value == 'Server' then
                    if u122.Value ~= '' then
                        return u122.Value
                    end

                    u111('ReportDetector-ServerMode', 'Please choose a player on the list!', 3)

                    return 'error'
                end
                if u120.Value == 'Global' then
                    if u121.Value ~= '' then
                        return u121.Value
                    end

                    u111('ReportDetector-GlobalMode', 'Please specify a username in the textbox!', 3)

                    return 'error'
                end
            end

            local v161 = {
                Name = 'ReportDetector',
                Function = function(p145)
                    if p145 then
                        u119.ToggleButton(false)
                        task.spawn(function()
                            if u104 <= 0 then
                                local v146 = u144()

                                if v146 == 'error' then
                                    u141()
                                else
                                    u118('ReportDetector-Credits', 'API - Systemxvoid, Module implementation - Erchobg', 1.5)
                                    u118('ReportDetector-' .. tostring(u120.Value), 'Request sent for ' .. tostring(v146) .. '! Please wait', 4.9)
                                    u141()

                                    local v147 = {
                                        Url = 'https://api.manhackwiz.xyz/matchreports?match=' .. v146,
                                        Method = 'GET',
                                    }
                                    local v148 = request(v147)

                                    if v148.StatusCode ~= 200 or v148.StatusMessage ~= 'OK' then
                                        u143(v148.StatusCode)
                                    else
                                        local v149 = game:GetService('HttpService'):JSONDecode(v148.Body)

                                        if v149.success ~= true then
                                            u143()
                                        elseif v149.result and type(v149.result) == 'table' then
                                            local _result = v149.result

                                            if #_result ~= 0 then
                                                if u123.Enabled then
                                                    u111('ReportDetector-' .. tostring(u120.Value), tostring(#_result) .. ' were found for ' .. tostring(v146) .. '!', 7)
                                                else
                                                    u111('ReportDetector-' .. tostring(u120.Value), tostring(#_result) .. ' were found for ' .. tostring(v146) .. '!', 7)

                                                    local v151, v152, v153 = pairs(_result)
                                                    local v154 = {}

                                                    while true do
                                                        local v155

                                                        v153, v155 = v151(v152, v153)

                                                        if v153 == nil then
                                                            break
                                                        end
                                                        if _result[v153].reporter then
                                                            local _id = _result[v153].reporter.id
                                                            local _username = _result[v153].reporter.username
                                                            local _message = _result[v153].message
                                                            local _id2 = _result[v153].id

                                                            if _id and (_username and (_message and _id2)) then
                                                                u111('ReportDetector-Report ' .. tostring(v153) .. ' Reporter data', '@' .. tostring(_username) .. '(UserID:' .. tostring(_id) .. ')', 7)
                                                                u111('ReportDetector-Report ' .. tostring(v153) .. ' Server data', 'ServerID:' .. tostring(_id2) .. ' Message: ' .. tostring(_message), 7)

                                                                local v160 = {
                                                                    ReporterData = 'Username: ' .. tostring(_username) .. ' UserID: ' .. tostring(_id),
                                                                    ServerData = 'ServerID: ' .. tostring(_id2) .. ' Message: ' .. tostring(_message),
                                                                }

                                                                print(v154)
                                                                print(v160)

                                                                v154[tostring(v153)] = v160
                                                            else
                                                                u143()
                                                            end
                                                        else
                                                            u143()
                                                        end
                                                    end

                                                    u140(v154)
                                                end
                                            else
                                                u118('ReportDetector-' .. tostring(u120.Value), 'No reports found for ' .. tostring(v146) .. '!', 3)
                                            end
                                        else
                                            u143()
                                        end
                                    end
                                end
                            else
                                u111('ReportDetector', 'You are on cooldown please wait ' .. tostring(u104) .. ' seconds.', 3)
                            end
                        end)
                    end
                end,
            }

            u119 = u2.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton(v161)

            local u162 = {}
            local _Players2 = game:GetService('Players')

            _Players2.PlayerAdded:Connect(function(p164)
                table.insert(u162, p164.Name)
            end)
            _Players2.PlayerRemoving:Connect(function(p165)
                local v166, v167, v168 = pairs(u162)

                while true do
                    local v169

                    v168, v169 = v166(v167, v168)

                    if v168 == nil then
                        break
                    end
                    if playerlist[v168] == p165.Name then
                        table.remove(u162, v168)

                        break
                    end
                end
            end)

            local v170, v171, v172 = pairs(_Players2:GetChildren())
            local u173 = u121
            local u174 = u122
            local u175 = u119
            local u176 = u162

            while true do
                local v177

                v172, v177 = v170(v171, v172)

                if v172 == nil then
                    break
                end

                table.insert(u176, _Players2:GetChildren()[v172].Name)
            end

            u120 = u175.CreateDropdown({
                Name = 'Mode',
                List = {
                    'Self',
                    'Server',
                    'Global',
                },
                Function = function(p178)
                    if p178 == 'Server' then
                        local v179 = {
                            Name = 'Players',
                            List = u176,
                            Function = function() end,
                        }

                        u174 = u175.CreateDropdown(v179)
                    elseif p178 == 'Global' then
                        u173 = u175.CreateTextBox({
                            Name = 'Username',
                            TempText = 'Type here a username',
                            Function = function() end,
                        })
                    end
                end,
            })
            u123 = u175.CreateToggle({
                Name = 'Simplified',
                Function = function() end,
                Default = true,
                HoverText = 'Show simplified data',
            })
        end)
    end,
    [6872265039] = function()
        run(function()
            local u180 = {}
            local v210 = {
                Name = 'GetRewards',
                Function = function(p181)
                    if p181 then
                        u12('GetRewards', 'You might need to execute this command many times for it to work!', 7)
                        u180.ToggleButton(false)

                        local u182 = {}
                        local v183 = {
                            id = 'EVENT_summer_2024_DAILY_16_MISSION_3',
                            metaId = '3',
                            name = 'Break 2 beds',
                            currencyReward = 'summer_2024_currency',
                            rewardAmount = 2000,
                            generator = 'summer_2024',
                            stages = {
                                {
                                    progress = 2,
                                    type = 'BedBreak',
                                },
                            },
                        }
                        local v184 = {}
                        local v185 = {}
                        local v186 = {
                            globalTeamCurrency = {
                                eventKey = 'summer_2024',
                                amount = 20,
                            },
                            paid = false,
                        }

                        __set_list(v185, 1, {v186})

                        v184.rewards = v185
                        v184.name = 'Shell Contributions'
                        v184.icon = 'rbxassetid://18123383870'
                        v183.reward = v184

                        local v187 = {
                            id = 'EVENT_summer_2024_LASTCHANCE_16_MISSION_1',
                            metaId = '1',
                            name = 'Break 2 beds',
                            currencyReward = 'summer_2024_currency',
                            rewardAmount = 5000,
                            generator = 'summer_2024',
                            stages = {
                                {
                                    progress = 2,
                                    type = 'BedBreak',
                                },
                            },
                        }

                        __set_list(u182, 1, {
                            v183,
                            v187,
                            {
                                rewardId = 'summer2024_shared_1',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_currency_1',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_2',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_emote_2',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_3',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_emote_3',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_4',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_currency_2',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_6',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_emote_4',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_7',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_12',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_8',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_9',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_currency_3',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_10',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                rewardId = 'summer2024_shared_11',
                                globalTeamEventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_limited_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_defender_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_movement_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_economoy_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_destroyer_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_tank_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_ranged_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_support_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'kit_rental_fighter_7',
                                eventKey = 'summer_2024',
                            },
                            {
                                shopItemId = 'lucky_crate',
                                eventKey = 'summer_2024',
                            },
                        });
                        (function()
                            local _ReplicatedStorage = game:GetService('ReplicatedStorage')
                            local _EventClaimMission = _ReplicatedStorage:WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('Event/ClaimMission')
                            local _TryToClaimGlobalTeamReward = _ReplicatedStorage:WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('TryToClaimGlobalTeamReward')
                            local _EventPurchaseShopItem = _ReplicatedStorage:WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('Event/PurchaseShopItem')
                            local _GlobalTeamsSetTeam = _ReplicatedStorage:WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('GlobalTeamsSetTeam')
                            local u193 = {}
                            local v194 = {
                                globalTeamKey = 'summer_2024_turtle',
                                player = game:GetService('Players').LocalPlayer,
                                globalTeamEventKey = 'summer_2024',
                            }

                            __set_list(u193, 1, {v194})

                            local v195, v196 = pcall(function()
                                _GlobalTeamsSetTeam:FireServer(unpack(u193))
                            end)

                            if not v195 then
                                warn('Failed to set global team: ' .. v196)
                            end

                            local v197, v198, v199 = ipairs(u182)

                            while true do
                                local v200

                                v199, v200 = v197(v198, v199)

                                if v199 == nil then
                                    break
                                end
                                if v200.id and v200.metaId then
                                    local u201 = {
                                        {
                                            id = v200.id,
                                            metaId = v200.metaId,
                                            name = v200.name,
                                            currencyReward = v200.currencyReward,
                                            rewardAmount = v200.rewardAmount,
                                            generator = v200.generator,
                                            stages = v200.stages,
                                        },
                                        v200.generator,
                                    }
                                    local v202, v203 = pcall(function()
                                        _EventClaimMission:InvokeServer(unpack(u201))
                                    end)

                                    if not v202 then
                                        warn('Failed to claim mission: ' .. v203)
                                    end
                                elseif v200.rewardId and v200.globalTeamEventKey then
                                    local u204 = {
                                        {
                                            rewardId = v200.rewardId,
                                            globalTeamEventKey = v200.globalTeamEventKey,
                                        },
                                    }
                                    local v205, v206 = pcall(function()
                                        _TryToClaimGlobalTeamReward:InvokeServer(unpack(u204))
                                    end)

                                    if not v205 then
                                        warn('Failed to claim global team reward: ' .. v206)
                                    end
                                elseif v200.shopItemId and v200.eventKey then
                                    local u207 = {
                                        v200.shopItemId,
                                        v200.eventKey,
                                    }
                                    local v208, v209 = pcall(function()
                                        _EventPurchaseShopItem:InvokeServer(unpack(u207))
                                    end)

                                    if not v208 then
                                        warn('Failed to purchase shop item: ' .. v209)
                                    end
                                end
                            end
                        end)()
                    end
                end,
            }

            u180 = u2.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton(v210)
        end)

        local u211 = 0

        run('ReportDetector', function()
            local function u218(p212, p213, p214)
                local v217, v217 = pcall(function()
                    local v215 = u2.CreateNotification(p212, p213, p214 or 6.5, 'assets/WarningNotification.png')

                    v215.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
                    v215.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
                end)

                return v217
            end
            local function u225(p219, p220, p221, p222)
                local v224, v224 = pcall(function()
                    return u2.CreateNotification(p219 or 'Voidware', p220 or 'Successfully called function', p221 or 7, 'assets/InfoNotification.png', p222)
                end)

                return v224
            end

            local u226 = {}
            local u227 = {
                Value = 'Self',
            }
            local u228 = {
                Value = '',
            }
            local u229 = {
                Value = '',
            }
            local u230 = {Enabled = true}
            local _LocalPlayer4 = game:GetService('Players').LocalPlayer

            local function u247(p232)
                local v240 = {
                    {
                        Name = 'Yes',
                        Function = function()
                            local v233 = game:GetService('HttpService'):JSONEncode(p232)

                            writefile('LoggedReports.txt', v233);
                            (function(p234, p235, p236, p237)
                                local v239, v239 = pcall(function()
                                    return u2.CreateNotification(p234 or 'Voidware', p235 or 'Successfully called function', p236 or 7, 'assets/InfoNotification.png', p237)
                                end)

                                return v239
                            end)('ReportDetector-LogSaver', "Successfully logged the Reports Data to LoggedReports.txt in your executor's workspace folder!", 7)
                        end,
                    },
                    {
                        Name = 'No',
                        Function = function() end,
                    },
                }

                (function(p241, p242, p243, p244)
                    local v246, v246 = pcall(function()
                        return u2.CreateInteractableNotification(p241 or 'Voidware', p242 or 'Successfully called function', p243 or 7, 'assets/InfoNotification.png', p244)
                    end)

                    return v246
                end)('ReportDetector-LogSaver', 'Would you like to save this log to your files?', 100000000, v240)
            end
            local function u248()
                u211 = 10

                task.spawn(function()
                    repeat
                        u211 = u211 - 1

                        task.wait(1)
                    until u211 < 1

                    u211 = 0
                end)
            end
            local function u250(p249)
                if p249 then
                    warn('StatusCode: ' .. tostring(p249))
                end

                u218('ReportDetector', 'Error making request! Please wait 10 seconds', 3)
                u248()
            end
            local function u251()
                if u227.Value == 'Self' then
                    return _LocalPlayer4.Name
                end
                if u227.Value == 'Server' then
                    if u229.Value ~= '' then
                        return u229.Value
                    end

                    u218('ReportDetector-ServerMode', 'Please choose a player on the list!', 3)

                    return 'error'
                end
                if u227.Value == 'Global' then
                    if u228.Value ~= '' then
                        return u228.Value
                    end

                    u218('ReportDetector-GlobalMode', 'Please specify a username in the textbox!', 3)

                    return 'error'
                end
            end

            local v268 = {
                Name = 'ReportDetector',
                Function = function(p252)
                    if p252 then
                        u226.ToggleButton(false)
                        task.spawn(function()
                            if u211 <= 0 then
                                local v253 = u251()

                                if v253 == 'error' then
                                    u248()
                                else
                                    u225('ReportDetector-Credits', 'API - Systemxvoid, Module implementation - Erchobg', 1.5)
                                    u225('ReportDetector-' .. tostring(u227.Value), 'Request sent for ' .. tostring(v253) .. '! Please wait', 4.9)
                                    u248()

                                    local v254 = {
                                        Url = 'https://api.manhackwiz.xyz/matchreports?match=' .. v253,
                                        Method = 'GET',
                                    }
                                    local v255 = request(v254)

                                    if v255.StatusCode ~= 200 or v255.StatusMessage ~= 'OK' then
                                        u250(v255.StatusCode)
                                    else
                                        local v256 = game:GetService('HttpService'):JSONDecode(v255.Body)

                                        if v256.success ~= true then
                                            u250()
                                        elseif v256.result and type(v256.result) == 'table' then
                                            local _result2 = v256.result

                                            if #_result2 ~= 0 then
                                                if u230.Enabled then
                                                    u218('ReportDetector-' .. tostring(u227.Value), tostring(#_result2) .. ' were found for ' .. tostring(v253) .. '!', 7)
                                                else
                                                    u218('ReportDetector-' .. tostring(u227.Value), tostring(#_result2) .. ' were found for ' .. tostring(v253) .. '!', 7)

                                                    local v258, v259, v260 = pairs(_result2)
                                                    local v261 = {}

                                                    while true do
                                                        local v262

                                                        v260, v262 = v258(v259, v260)

                                                        if v260 == nil then
                                                            break
                                                        end
                                                        if _result2[v260].reporter then
                                                            local _id3 = _result2[v260].reporter.id
                                                            local _username2 = _result2[v260].reporter.username
                                                            local _message2 = _result2[v260].message
                                                            local _id4 = _result2[v260].id

                                                            if _id3 and (_username2 and (_message2 and _id4)) then
                                                                u218('ReportDetector-Report ' .. tostring(v260) .. ' Reporter data', '@' .. tostring(_username2) .. '(UserID:' .. tostring(_id3) .. ')', 7)
                                                                u218('ReportDetector-Report ' .. tostring(v260) .. ' Server data', 'ServerID:' .. tostring(_id4) .. ' Message: ' .. tostring(_message2), 7)

                                                                local v267 = {
                                                                    ReporterData = 'Username: ' .. tostring(_username2) .. ' UserID: ' .. tostring(_id3),
                                                                    ServerData = 'ServerID: ' .. tostring(_id4) .. ' Message: ' .. tostring(_message2),
                                                                }

                                                                print(v261)
                                                                print(v267)

                                                                v261[tostring(v260)] = v267
                                                            else
                                                                u250()
                                                            end
                                                        else
                                                            u250()
                                                        end
                                                    end

                                                    u247(v261)
                                                end
                                            else
                                                u225('ReportDetector-' .. tostring(u227.Value), 'No reports found for ' .. tostring(v253) .. '!', 3)
                                            end
                                        else
                                            u250()
                                        end
                                    end
                                end
                            else
                                u218('ReportDetector', 'You are on cooldown please wait ' .. tostring(u211) .. ' seconds.', 3)
                            end
                        end)
                    end
                end,
            }

            u226 = u2.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton(v268)

            local u269 = {}
            local _Players3 = game:GetService('Players')

            _Players3.PlayerAdded:Connect(function(p271)
                table.insert(u269, p271.Name)
            end)
            _Players3.PlayerRemoving:Connect(function(p272)
                local v273, v274, v275 = pairs(u269)

                while true do
                    local v276

                    v275, v276 = v273(v274, v275)

                    if v275 == nil then
                        break
                    end
                    if playerlist[v275] == p272.Name then
                        table.remove(u269, v275)

                        break
                    end
                end
            end)

            local v277, v278, v279 = pairs(_Players3:GetChildren())
            local u280 = u228
            local u281 = u229
            local u282 = u226
            local u283 = u269

            while true do
                local v284

                v279, v284 = v277(v278, v279)

                if v279 == nil then
                    break
                end

                table.insert(u283, _Players3:GetChildren()[v279].Name)
            end

            u227 = u282.CreateDropdown({
                Name = 'Mode',
                List = {
                    'Self',
                    'Server',
                    'Global',
                },
                Function = function(p285)
                    if p285 == 'Server' then
                        local v286 = {
                            Name = 'Players',
                            List = u283,
                            Function = function() end,
                        }

                        u281 = u282.CreateDropdown(v286)
                    elseif p285 == 'Global' then
                        u280 = u282.CreateTextBox({
                            Name = 'Username',
                            TempText = 'Type here a username',
                            Function = function() end,
                        })
                    end
                end,
            })
            u230 = u282.CreateToggle({
                Name = 'Simplified',
                Function = function() end,
                Default = true,
                HoverText = 'Show simplified data',
            })
        end)
    end,
}

function v1.LoadModules(p288)
    if p288 then
        if type(p288) ~= 'number' then
            p288 = tonumber(p288)
        end
        if u287[p288] then
            u287[p288]()

            shared.vapeConnections = u13
        else
            warn('Unknown gameid! GameId: ' .. tostring(p288))
        end
    else
        warn('GameId not specified')
    end
end

return v1
