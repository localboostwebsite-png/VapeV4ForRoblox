-- Utility window module: Dex-style instance explorer for reverse engineering
run(function()
	local GuiLibrary = shared.GuiLibrary
	local vapeGithubRequest = shared.vapeGithubRequest
	local dexApi

	local function loadDex()
		if dexApi then return dexApi end
		local src
		if isfile("newvape/libraries/dex_explorer.lua") then
			src = readfile("newvape/libraries/dex_explorer.lua")
		else
			src = vapeGithubRequest("Libraries/dex_explorer.lua")
		end
		local factory = loadstring(src, "dex_explorer")()
		dexApi = factory()
		dexApi.SetOnClose(function()
			local btn = GuiLibrary.ObjectsThatCanBeSaved["Dex ExplorerOptionsButton"]
			if btn and btn.Api and btn.Api.ToggleButton then
				btn.Api.ToggleButton(false)
			end
		end)
		return dexApi
	end

	GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "Dex Explorer",
		Function = function(callback)
			if callback then
				local ok, err = pcall(function()
					loadDex().Show()
				end)
				if not ok then
					warn("[Dex Explorer] Failed to open:", err)
				end
			else
				if dexApi then
					dexApi.Hide()
				end
			end
		end,
		HoverText = "Browse game instances and inspect properties (like Dex). Use with Remote Spy for RE."
	})
end)
