-- Nova Dex Explorer — lightweight instance tree + property inspector
return function()
	local cloneref = cloneref or function(obj) return obj end
	local CoreGui = cloneref(game:GetService("CoreGui"))
	local UserInputService = cloneref(game:GetService("UserInputService"))
	local gethui = gethui or function() return CoreGui end
	local getproperties = getproperties or function(inst)
		local list = {"Name", "ClassName", "Parent"}
		for _, prop in ipairs({"Archivable", "Position", "Size", "CFrame", "Transparency", "Color", "Material", "Value", "Text", "Enabled", "Visible"}) do
			local ok = pcall(function() return inst[prop] end)
			if ok then table.insert(list, prop) end
		end
		return list
	end

	local Explorer = {}
	Explorer.__index = Explorer
	Explorer.Visible = false
	Explorer.Selected = game
	Explorer.Expanded = {[game] = true}
	Explorer.connections = {}

	local COLORS = {
		bg = Color3.fromRGB(18, 18, 26),
		panel = Color3.fromRGB(28, 28, 38),
		border = Color3.fromRGB(55, 55, 75),
		text = Color3.fromRGB(230, 230, 240),
		muted = Color3.fromRGB(140, 140, 160),
		accent = Color3.fromRGB(180, 60, 100),
		selected = Color3.fromRGB(70, 35, 55),
		rowHover = Color3.fromRGB(38, 38, 52),
	}

	local function formatValue(value)
		local t = typeof(value)
		if t == "Instance" then
			return value:GetFullName()
		elseif t == "Vector3" or t == "Vector2" or t == "UDim2" or t == "Color3" then
			return tostring(value)
		elseif t == "CFrame" then
			return string.format("CFrame(%s)", tostring(value.Position))
		elseif t == "EnumItem" then
			return tostring(value)
		elseif t == "string" then
			if #value > 120 then
				return value:sub(1, 117) .. "..."
			end
			return value
		elseif t == "table" then
			return "table"
		end
		return tostring(value)
	end

	local function disconnectAll(self)
		for _, conn in ipairs(self.connections) do
			pcall(function() conn:Disconnect() end)
		end
		table.clear(self.connections)
	end

	function Explorer:destroy()
		disconnectAll(self)
		if self.gui then
			self.gui:Destroy()
			self.gui = nil
		end
		self.Visible = false
	end

	function Explorer:hide()
		if self.gui then
			self.gui.Enabled = false
		end
		self.Visible = false
	end

	function Explorer:show()
		if not self.gui then
			self:build()
		end
		self.gui.Enabled = true
		self.Visible = true
		self:refreshTree()
		self:refreshProperties()
	end

	function Explorer:toggle(on)
		if on then self:show() else self:hide() end
	end

	function Explorer:build()
		local gui = Instance.new("ScreenGui")
		gui.Name = "NovaDexExplorer"
		gui.ResetOnSpawn = false
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui.DisplayOrder = 999999
		gui.IgnoreGuiInset = true
		gui.Parent = gethui()

		local main = Instance.new("Frame")
		main.Name = "Main"
		main.AnchorPoint = Vector2.new(0.5, 0.5)
		main.Position = UDim2.fromScale(0.5, 0.5)
		main.Size = UDim2.fromOffset(860, 520)
		main.BackgroundColor3 = COLORS.bg
		main.BorderSizePixel = 0
		main.Parent = gui

		local mainCorner = Instance.new("UICorner")
		mainCorner.CornerRadius = UDim.new(0, 8)
		mainCorner.Parent = main

		local mainStroke = Instance.new("UIStroke")
		mainStroke.Color = COLORS.border
		mainStroke.Thickness = 1
		mainStroke.Parent = main

		local titleBar = Instance.new("Frame")
		titleBar.Name = "TitleBar"
		titleBar.Size = UDim2.new(1, 0, 0, 34)
		titleBar.BackgroundColor3 = COLORS.panel
		titleBar.BorderSizePixel = 0
		titleBar.Parent = main

		local titleCorner = Instance.new("UICorner")
		titleCorner.CornerRadius = UDim.new(0, 8)
		titleCorner.Parent = titleBar

		local titleFix = Instance.new("Frame")
		titleFix.Size = UDim2.new(1, 0, 0, 10)
		titleFix.Position = UDim2.new(0, 0, 1, -10)
		titleFix.BackgroundColor3 = COLORS.panel
		titleFix.BorderSizePixel = 0
		titleFix.Parent = titleBar

		local title = Instance.new("TextLabel")
		title.BackgroundTransparency = 1
		title.Position = UDim2.fromOffset(12, 0)
		title.Size = UDim2.new(1, -120, 1, 0)
		title.Font = Enum.Font.GothamBold
		title.Text = "DEX EXPLORER"
		title.TextColor3 = COLORS.text
		title.TextSize = 14
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = titleBar

		local closeBtn = Instance.new("TextButton")
		closeBtn.Size = UDim2.fromOffset(28, 28)
		closeBtn.Position = UDim2.new(1, -36, 0, 3)
		closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		closeBtn.Text = "X"
		closeBtn.TextColor3 = COLORS.text
		closeBtn.Font = Enum.Font.GothamBold
		closeBtn.TextSize = 14
		closeBtn.Parent = titleBar
		Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

		local refreshBtn = Instance.new("TextButton")
		refreshBtn.Size = UDim2.fromOffset(60, 28)
		refreshBtn.Position = UDim2.new(1, -104, 0, 3)
		refreshBtn.BackgroundColor3 = COLORS.border
		refreshBtn.Text = "Refresh"
		refreshBtn.TextColor3 = COLORS.text
		refreshBtn.Font = Enum.Font.Gotham
		refreshBtn.TextSize = 12
		refreshBtn.Parent = titleBar
		Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

		local body = Instance.new("Frame")
		body.Name = "Body"
		body.Position = UDim2.fromOffset(8, 42)
		body.Size = UDim2.new(1, -16, 1, -50)
		body.BackgroundTransparency = 1
		body.Parent = main

		local explorerPanel = Instance.new("Frame")
		explorerPanel.Name = "Explorer"
		explorerPanel.Size = UDim2.new(0.52, -4, 1, 0)
		explorerPanel.BackgroundColor3 = COLORS.panel
		explorerPanel.BorderSizePixel = 0
		explorerPanel.Parent = body
		Instance.new("UICorner", explorerPanel).CornerRadius = UDim.new(0, 6)

		local propsPanel = Instance.new("Frame")
		propsPanel.Name = "Properties"
		propsPanel.Position = UDim2.new(0.52, 4, 0, 0)
		propsPanel.Size = UDim2.new(0.48, -4, 1, 0)
		propsPanel.BackgroundColor3 = COLORS.panel
		propsPanel.BorderSizePixel = 0
		propsPanel.Parent = body
		Instance.new("UICorner", propsPanel).CornerRadius = UDim.new(0, 6)

		local function makeSearch(parent, placeholder)
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(1, -12, 0, 26)
			box.Position = UDim2.fromOffset(6, 6)
			box.BackgroundColor3 = COLORS.bg
			box.TextColor3 = COLORS.text
			box.PlaceholderText = placeholder
			box.PlaceholderColor3 = COLORS.muted
			box.Font = Enum.Font.Gotham
			box.TextSize = 13
			box.ClearTextOnFocus = false
			box.Text = ""
			box.Parent = parent
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
			local pad = Instance.new("UIPadding")
			pad.PaddingLeft = UDim.new(0, 8)
			pad.Parent = box
			return box
		end

		local explorerSearch = makeSearch(explorerPanel, "Search instances...")
		local propsSearch = makeSearch(propsPanel, "Search properties...")

		local function makeScroll(parent, y)
			local scroll = Instance.new("ScrollingFrame")
			scroll.Position = UDim2.new(0, 6, 0, y)
			scroll.Size = UDim2.new(1, -12, 1, -(y + 6))
			scroll.BackgroundTransparency = 1
			scroll.BorderSizePixel = 0
			scroll.ScrollBarThickness = 4
			scroll.CanvasSize = UDim2.new()
			scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			scroll.Parent = parent
			local layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 1)
			layout.Parent = scroll
			return scroll
		end

		self.treeScroll = makeScroll(explorerPanel, 38)
		self.propsScroll = makeScroll(propsPanel, 38)

		local pathLabel = Instance.new("TextLabel")
		pathLabel.Name = "Path"
		pathLabel.BackgroundTransparency = 1
		pathLabel.Position = UDim2.new(0, 6, 1, -22)
		pathLabel.Size = UDim2.new(1, -12, 0, 18)
		pathLabel.Font = Enum.Font.Code
		pathLabel.TextColor3 = COLORS.muted
		pathLabel.TextSize = 11
		pathLabel.TextXAlignment = Enum.TextXAlignment.Left
		pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
		pathLabel.Text = ""
		pathLabel.Parent = propsPanel

		self.gui = gui
		self.main = main
		self.pathLabel = pathLabel
		self.explorerSearch = explorerSearch
		self.propsSearch = propsSearch

		table.insert(self.connections, closeBtn.MouseButton1Click:Connect(function()
			self:hide()
			if self.onClose then self.onClose() end
		end))

		table.insert(self.connections, refreshBtn.MouseButton1Click:Connect(function()
			self:refreshTree()
			self:refreshProperties()
		end))

		table.insert(self.connections, explorerSearch:GetPropertyChangedSignal("Text"):Connect(function()
			self:refreshTree()
		end))

		table.insert(self.connections, propsSearch:GetPropertyChangedSignal("Text"):Connect(function()
			self:refreshProperties()
		end))

		-- draggable title bar
		local dragging, dragStart, startPos
		table.insert(self.connections, titleBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
			end
		end))
		table.insert(self.connections, UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end))
		table.insert(self.connections, UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end))

		if shared.GuiLibrary and shared.GuiLibrary.SelfDestructEvent then
			table.insert(self.connections, shared.GuiLibrary.SelfDestructEvent.Event:Connect(function()
				self:destroy()
			end))
		end

		gui.Enabled = false
	end

	function Explorer:instanceMatches(inst, filter)
		if filter == "" then return true end
		filter = filter:lower()
		local ok, full = pcall(function() return inst:GetFullName():lower() end)
		if ok and full:find(filter, 1, true) then return true end
		return inst.Name:lower():find(filter, 1, true) ~= nil
	end

	function Explorer:collectTree()
		local filter = self.explorerSearch and self.explorerSearch.Text or ""
		local rows = {}
		local function walk(inst, depth)
			local matches = self:instanceMatches(inst, filter)
			local childList = {}
			local ok, children = pcall(function() return inst:GetChildren() end)
			if ok then
				table.sort(children, function(a, b) return a.Name:lower() < b.Name:lower() end)
				childList = children
			end
			if filter ~= "" and not matches then
				for _, child in ipairs(childList) do
					walk(child, depth + 1)
				end
				return
			end
			table.insert(rows, {inst = inst, depth = depth, childCount = #childList})
			if self.Expanded[inst] then
				for _, child in ipairs(childList) do
					walk(child, depth + 1)
				end
			end
		end
		walk(game, 0)
		return rows
	end

	function Explorer:refreshTree()
		if not self.treeScroll then return end
		for _, child in ipairs(self.treeScroll:GetChildren()) do
			if child:IsA("GuiObject") then child:Destroy() end
		end
		local rows = self:collectTree()
		for i, row in ipairs(rows) do
			local inst = row.inst
			local frame = Instance.new("TextButton")
			frame.Name = "Row"
			frame.LayoutOrder = i
			frame.Size = UDim2.new(1, 0, 0, 22)
			frame.BackgroundColor3 = (self.Selected == inst) and COLORS.selected or COLORS.panel
			frame.AutoButtonColor = false
			frame.BorderSizePixel = 0
			frame.Text = ""
			frame.Parent = self.treeScroll

			local expanded = self.Expanded[inst] == true
			local arrow = Instance.new("TextLabel")
			arrow.BackgroundTransparency = 1
			arrow.Position = UDim2.fromOffset(4 + row.depth * 14, 0)
			arrow.Size = UDim2.fromOffset(14, 22)
			arrow.Font = Enum.Font.GothamBold
			arrow.TextSize = 12
			arrow.TextColor3 = COLORS.muted
			arrow.Text = row.childCount > 0 and (expanded and "v" or ">") or " "
			arrow.Parent = frame

			local classLabel = Instance.new("TextLabel")
			classLabel.BackgroundTransparency = 1
			classLabel.Position = UDim2.new(1, -110, 0, 0)
			classLabel.Size = UDim2.fromOffset(104, 22)
			classLabel.Font = Enum.Font.Code
			classLabel.TextSize = 11
			classLabel.TextColor3 = COLORS.muted
			classLabel.TextXAlignment = Enum.TextXAlignment.Right
			classLabel.Text = inst.ClassName
			classLabel.Parent = frame

			local nameLabel = Instance.new("TextLabel")
			nameLabel.BackgroundTransparency = 1
			nameLabel.Position = UDim2.fromOffset(20 + row.depth * 14, 0)
			nameLabel.Size = UDim2.new(1, -140 - row.depth * 14, 1, 0)
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 12
			nameLabel.TextColor3 = COLORS.text
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
			nameLabel.Text = inst.Name
			nameLabel.Parent = frame

			frame.MouseEnter:Connect(function()
				if self.Selected ~= inst then
					frame.BackgroundColor3 = COLORS.rowHover
				end
			end)
			frame.MouseLeave:Connect(function()
				frame.BackgroundColor3 = (self.Selected == inst) and COLORS.selected or COLORS.panel
			end)
			frame.MouseButton1Click:Connect(function()
				self.Selected = inst
				self:refreshTree()
				self:refreshProperties()
			end)
			arrow.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
				if row.childCount == 0 then return end
				self.Expanded[inst] = not expanded
				self:refreshTree()
			end)
		end
	end

	function Explorer:refreshProperties()
		if not self.propsScroll then return end
		for _, child in ipairs(self.propsScroll:GetChildren()) do
			if child:IsA("GuiObject") then child:Destroy() end
		end
		local inst = self.Selected
		if not inst then return end
		pcall(function()
			self.pathLabel.Text = inst:GetFullName()
		end)
		local filter = self.propsSearch and self.propsSearch.Text:lower() or ""
		local order = 0
		for _, propName in ipairs(getproperties(inst)) do
			if filter == "" or propName:lower():find(filter, 1, true) then
				local ok, value = pcall(function() return inst[propName] end)
				if ok then
					order += 1
					local row = Instance.new("Frame")
					row.LayoutOrder = order
					row.Size = UDim2.new(1, 0, 0, 24)
					row.BackgroundColor3 = COLORS.bg
					row.BorderSizePixel = 0
					row.Parent = self.propsScroll
					Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

					local key = Instance.new("TextLabel")
					key.BackgroundTransparency = 1
					key.Position = UDim2.fromOffset(6, 0)
					key.Size = UDim2.new(0.42, -6, 1, 0)
					key.Font = Enum.Font.GothamBold
					key.TextSize = 11
					key.TextColor3 = COLORS.accent
					key.TextXAlignment = Enum.TextXAlignment.Left
					key.Text = propName
					key.Parent = row

					local val = Instance.new("TextLabel")
					val.BackgroundTransparency = 1
					val.Position = UDim2.new(0.42, 0, 0, 0)
					val.Size = UDim2.new(0.58, -6, 1, 0)
					val.Font = Enum.Font.Code
					val.TextSize = 11
					val.TextColor3 = COLORS.text
					val.TextXAlignment = Enum.TextXAlignment.Left
					val.TextTruncate = Enum.TextTruncate.AtEnd
					val.Text = formatValue(value)
					val.Parent = row

					row.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 and setclipboard then
							setclipboard(tostring(propName) .. " = " .. val.Text)
						end
					end)
				end
			end
		end
	end

	local singleton = setmetatable({}, Explorer)
	return {
		Show = function() singleton:show() end,
		Hide = function() singleton:hide() end,
		Toggle = function(on) singleton:toggle(on) end,
		Destroy = function() singleton:destroy() end,
		SetOnClose = function(fn) singleton.onClose = fn end,
	}
end
