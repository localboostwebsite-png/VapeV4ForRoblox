--[[
	Custom UI theme for BedWars build — animated rainbow accents.
]]

local Theme = {
	Brand = 'NOVA',
	Subtitle = 'BEDWARS',
	VersionTag = 'Nova UI',
	HuePrimary = 0.93,
	SatPrimary = 0.82,
	ValPrimary = 0.58,
	HueSecondary = 0.73,
	SatSecondary = 0.88,
	ValSecondary = 0.62,
	Panel = Color3.fromRGB(10, 8, 18),
	PanelElevated = Color3.fromRGB(16, 12, 26),
	Overlay = Color3.fromRGB(6, 4, 12),
	Text = Color3.fromRGB(238, 232, 248),
	TextDim = Color3.fromRGB(128, 118, 150),
	Stroke = Color3.fromRGB(55, 38, 82),
	Notification = Color3.fromRGB(255, 70, 120),
	CornerRadius = UDim.new(0, 8),
	FriendColor = Color3.fromRGB(255, 70, 130),
	RainbowSpeed = 0.22
}

local rainbowConnection
local rainbowTargets = {}

local function ensureCorner(parent, radius)
	local corner = parent:FindFirstChildOfClass('UICorner')
	if not corner then
		corner = Instance.new('UICorner')
		corner.Parent = parent
	end
	corner.CornerRadius = radius or Theme.CornerRadius
	return corner
end

local function ensureStroke(parent, color, thickness)
	local stroke = parent:FindFirstChild('NovaStroke')
	if not stroke then
		stroke = Instance.new('UIStroke')
		stroke.Name = 'NovaStroke'
		stroke.Parent = parent
	end
	stroke.Color = color or Theme.Stroke
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Transparency = 0.2
	return stroke
end

local function applyGradient(label, rotation, hueOffset)
	local gradient = label:FindFirstChildOfClass('UIGradient') or Instance.new('UIGradient', label)
	gradient.Rotation = rotation or 35
	local h1 = ((hueOffset or 0) + Theme.HuePrimary) % 1
	local h2 = ((hueOffset or 0) + 0.18 + Theme.HueSecondary) % 1
	local h3 = ((hueOffset or 0) + 0.36 + Theme.HuePrimary) % 1
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(h1, 1, 1)),
		ColorSequenceKeypoint.new(0.5, Color3.fromHSV(h2, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(h3, 1, 1))
	})
	table.insert(rainbowTargets, {Type = 'Gradient', Object = gradient})
	return gradient
end

local function trackStroke(stroke)
	table.insert(rainbowTargets, {Type = 'Stroke', Object = stroke})
	return stroke
end

local function replaceMainLogo(mainWindow)
	local logo1 = mainWindow:FindFirstChild('Logo1', true)
	if logo1 then logo1.Visible = false end
	local logo2 = mainWindow:FindFirstChild('Logo2', true)
	if logo2 then logo2.Visible = false end

	local brand = mainWindow:FindFirstChild('NovaBrand')
	if not brand then
		brand = Instance.new('TextLabel')
		brand.Name = 'NovaBrand'
		brand.BackgroundTransparency = 1
		brand.Size = UDim2.new(0, 130, 0, 22)
		brand.Position = UDim2.new(0, 12, 0, 11)
		brand.Font = Enum.Font.GothamBlack
		brand.TextSize = 18
		brand.TextXAlignment = Enum.TextXAlignment.Left
		brand.Text = Theme.Brand
		brand.Parent = mainWindow
		applyGradient(brand, 25, 0)
	end

	local sub = mainWindow:FindFirstChild('NovaSubtitle')
	if not sub then
		sub = Instance.new('TextLabel')
		sub.Name = 'NovaSubtitle'
		sub.BackgroundTransparency = 1
		sub.Size = UDim2.new(0, 80, 0, 14)
		sub.Position = UDim2.new(0, 12, 0, 28)
		sub.Font = Enum.Font.GothamMedium
		sub.TextSize = 11
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.TextColor3 = Theme.TextDim
		sub.Text = Theme.Subtitle
		sub.Parent = mainWindow
		table.insert(rainbowTargets, {Type = 'Text', Object = sub, Base = Theme.TextDim, Amp = 0.35})
	end

	for _, child in mainWindow:GetChildren() do
		if child:IsA('TextLabel') and child.Text:find('Vape') then
			child.Text = Theme.VersionTag..'  '
			child.TextColor3 = Theme.TextDim
			child.Font = Enum.Font.Gotham
		end
	end
end

local function stylePanel(frame)
	if not frame:IsA('GuiObject') then return end
	if frame.Name == 'MainWindow' or frame.Name == 'SearchBar' or frame.Name:find('Window') then
		frame.BackgroundColor3 = Theme.Panel
		ensureCorner(frame)
		trackStroke(ensureStroke(frame))
	end
	if frame.Name == 'SearchBar' then
		local search = frame:FindFirstChildWhichIsA('TextBox', true)
		if search then
			search.Font = Enum.Font.GothamMedium
			search.PlaceholderColor3 = Theme.TextDim
			search.TextColor3 = Theme.Text
		end
	end
end

local function startRainbowLoop()
	if rainbowConnection then
		rainbowConnection:Disconnect()
	end
	local runService = game:GetService('RunService')
	rainbowConnection = runService.RenderStepped:Connect(function()
		local t = tick() * Theme.RainbowSpeed
		local baseHue = t % 1
		for _, entry in rainbowTargets do
			pcall(function()
				if entry.Type == 'Gradient' and entry.Object then
					entry.Object.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(baseHue, 1, 1)),
						ColorSequenceKeypoint.new(0.5, Color3.fromHSV((baseHue + 0.2) % 1, 1, 1)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV((baseHue + 0.45) % 1, 1, 1))
					})
				elseif entry.Type == 'Stroke' and entry.Object then
					entry.Object.Color = Color3.fromHSV((baseHue + 0.1) % 1, 1, 1)
				elseif entry.Type == 'Text' and entry.Object then
					entry.Object.TextColor3 = Color3.fromHSV((baseHue + 0.5) % 1, 0.85, 1)
				end
			end)
		end
	end)
end

local function applyCustomTheme(GuiLibrary, options)
	options = options or {}
	local brand = options.Brand or Theme.Brand
	local subtitle = options.Subtitle or Theme.Subtitle
	Theme.Brand = brand
	Theme.Subtitle = subtitle
	table.clear(rainbowTargets)

	if not GuiLibrary or not GuiLibrary.MainGui then return Theme end

	local clickGui = GuiLibrary.MainGui:FindFirstChild('ScaledGui', true)
	if clickGui then
		local click = clickGui:FindFirstChild('ClickGui')
		if click then
			click.BackgroundColor3 = Theme.Overlay
			click.BackgroundTransparency = 0.35
		end
	end

	local mainWindow = clickGui and clickGui:FindFirstChild('ClickGui') and clickGui.ClickGui:FindFirstChild('MainWindow')
	if mainWindow then
		mainWindow.BackgroundColor3 = Theme.PanelElevated
		ensureCorner(mainWindow, UDim.new(0, 10))
		trackStroke(ensureStroke(mainWindow, Color3.fromHSV(0, 1, 1), 1.5))
		replaceMainLogo(mainWindow)
	end

	local searchBar = clickGui and clickGui:FindFirstChild('ClickGui') and clickGui.ClickGui:FindFirstChild('SearchBar')
	if searchBar then
		searchBar.BackgroundColor3 = Theme.Panel
		ensureCorner(searchBar)
		trackStroke(ensureStroke(searchBar))
	end

	for _, desc in GuiLibrary.MainGui:GetDescendants() do
		if desc:IsA('Frame') and (desc.Name == 'MainWindow' or desc.Name == 'SearchBar') then
			stylePanel(desc)
		end
		if desc:IsA('TextButton') and desc.Text == 'Vape' then
			desc.Text = brand
			desc.Font = Enum.Font.GothamBold
			desc.BackgroundColor3 = Theme.PanelElevated
			desc.TextColor3 = Theme.Text
			ensureCorner(desc, UDim.new(0, 6))
			trackStroke(ensureStroke(desc, Color3.fromHSV(0, 1, 1)))
		end
	end

	local oldNotification = GuiLibrary.CreateNotification
	if oldNotification and not GuiLibrary._NovaNotificationHooked then
		GuiLibrary._NovaNotificationHooked = true
		GuiLibrary.CreateNotification = function(title, text, delay, icon)
			local frame = oldNotification(title, text, delay, icon)
			pcall(function()
				if frame and frame.Frame and frame.Frame.Frame then
					frame.Frame.Frame.ImageColor3 = Theme.Notification
				end
			end)
			return frame
		end
	end

	startRainbowLoop()
	return Theme
end

return {
	Theme = Theme,
	apply = applyCustomTheme
}
