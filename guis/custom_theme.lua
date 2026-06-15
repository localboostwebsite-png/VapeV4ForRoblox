--[[
	Custom UI theme for BedWars build.
	Called after GuiLibrary finishes loading.
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
	Panel = Color3.fromRGB(13, 11, 20),
	PanelElevated = Color3.fromRGB(20, 16, 30),
	Overlay = Color3.fromRGB(8, 6, 14),
	Text = Color3.fromRGB(238, 232, 248),
	TextDim = Color3.fromRGB(128, 118, 150),
	Stroke = Color3.fromRGB(55, 38, 82),
	Notification = Color3.fromRGB(255, 70, 120),
	CornerRadius = UDim.new(0, 8),
	FriendColor = Color3.fromRGB(255, 70, 130)
}

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
	stroke.Transparency = 0.35
	return stroke
end

local function applyGradient(label, rotation)
	local gradient = label:FindFirstChildOfClass('UIGradient') or Instance.new('UIGradient', label)
	gradient.Rotation = rotation or 35
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(Theme.HuePrimary, Theme.SatPrimary, Theme.ValPrimary + 0.15)),
		ColorSequenceKeypoint.new(0.5, Color3.fromHSV(Theme.HueSecondary, Theme.SatSecondary, Theme.ValSecondary + 0.1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(Theme.HuePrimary, Theme.SatPrimary * 0.85, Theme.ValPrimary))
	})
	return gradient
end

local function replaceMainLogo(mainWindow)
	local logo1 = mainWindow:FindFirstChild('Logo1', true)
	if logo1 then
		logo1.Visible = false
	end
	local logo2 = mainWindow:FindFirstChild('Logo2', true)
	if logo2 then
		logo2.Visible = false
	end

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
		applyGradient(brand, 25)
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
	end

	local version = mainWindow:FindFirstChild('SettingsTitle') and mainWindow:FindFirstChild('SettingsTitle').Parent and mainWindow:FindFirstChild('SettingsTitle')
	if not version then
		for _, child in mainWindow:GetChildren() do
			if child:IsA('TextLabel') and child.Text:find('Vape') then
				child.Text = Theme.VersionTag..'  '
				child.TextColor3 = Theme.TextDim
				child.Font = Enum.Font.Gotham
				break
			end
		end
	else
		for _, child in mainWindow:GetChildren() do
			if child:IsA('TextLabel') and child.Text:find('Vape') then
				child.Text = Theme.VersionTag..'  '
				child.TextColor3 = Theme.TextDim
				child.Font = Enum.Font.Gotham
			end
		end
	end
end

local function stylePanel(frame)
	if not frame:IsA('GuiObject') then return end
	if frame.Name == 'MainWindow' or frame.Name == 'SearchBar' or frame.Name:find('Window') then
		frame.BackgroundColor3 = Theme.Panel
		ensureCorner(frame)
		ensureStroke(frame)
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

local function applyCustomTheme(GuiLibrary, options)
	options = options or {}
	local brand = options.Brand or Theme.Brand
	local subtitle = options.Subtitle or Theme.Subtitle
	Theme.Brand = brand
	Theme.Subtitle = subtitle

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
		ensureStroke(mainWindow, Color3.fromHSV(Theme.HuePrimary, Theme.SatPrimary, Theme.ValPrimary), 1.5)
		replaceMainLogo(mainWindow)
	end

	local searchBar = clickGui and clickGui:FindFirstChild('ClickGui') and clickGui.ClickGui:FindFirstChild('SearchBar')
	if searchBar then
		searchBar.BackgroundColor3 = Theme.Panel
		ensureCorner(searchBar)
		ensureStroke(searchBar)
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
			ensureStroke(desc, Color3.fromHSV(Theme.HuePrimary, Theme.SatPrimary, Theme.ValPrimary))
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

	return Theme
end

return {
	Theme = Theme,
	apply = applyCustomTheme
}
