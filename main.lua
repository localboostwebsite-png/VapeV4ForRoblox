repeat task.wait() until game:IsLoaded()
if shared.vape then
	pcall(function() shared.vape:Uninject() end)
end

local VAPE_REPO = 'localboostwebsite-png/VapeV4ForRoblox'

local BEDWARS_GAME = {6872274481, 8444591321, 8560631822}
local BEDWARS_LOBBY = {6872265039}
local function isBedwarsPlace()
	return table.find(BEDWARS_GAME, game.PlaceId) or table.find(BEDWARS_LOBBY, game.PlaceId)
end

local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

if not isBedwarsPlace() then
	lplr:Kick('This build only supports Roblox BedWars.')
	return
end

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local function downloadFile(path, func)
	if isfile(path) then
		local ok, existing = pcall(readfile, path)
		if ok and existing and existing:find('Bedwars is no longer supported by Vape V4, thank you for 5 years of support', 1, true) then
			pcall(function() delfile(path) end)
		end
	end
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/'..VAPE_REPO..'/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local ploadMap = {
	['GuiLibrary.lua'] = 'newvape/guis/GuiLibrary.lua',
	['Libraries/voidwarefunctions.lua'] = 'newvape/libraries/voidwarefunctions.lua',
	['Libraries/ProtectedModules.lua'] = 'newvape/libraries/ProtectedModules.lua',
	['Libraries/Protected_6872274481.lua'] = 'newvape/libraries/Protected_6872274481.lua',
	['Universal.lua'] = 'newvape/games/universal_voidware.lua',
	['VWUniversal.lua'] = 'newvape/games/VWUniversal.lua',
	['CustomModules/6872274481.lua'] = 'newvape/games/6872274481.lua',
	['CustomModules/6872265039.lua'] = 'newvape/games/6872265039.lua',
	['CustomModules/VW6872274481.lua'] = 'newvape/games/VWUniversal.lua',
	['CustomModules/VW6872265039.lua'] = 'newvape/games/VWUniversal.lua',
	['guis/custom_theme.lua'] = 'newvape/guis/custom_theme.lua',
	['Libraries/dex_explorer.lua'] = 'newvape/libraries/dex_explorer.lua',
	['games/dex_module.lua'] = 'newvape/games/dex_module.lua',
}

local function pload(fileName, isImportant, required)
	fileName = tostring(fileName)
	local path = ploadMap[fileName] or ('newvape/'..fileName)
	if fileName:find('VWUniversal') and not isfile(path) then
		if required then return {} end
		return
	end
	if not isfile(path) then
		pcall(function()
			downloadFile(path)
		end)
	end
	if not isfile(path) then
		if isImportant then
			error('Missing file: '..path)
		end
		return
	end
	local fn, err = loadstring(readfile(path), fileName)
	if type(fn) ~= 'function' then
		if isImportant then
			error(tostring(err or fn))
		end
		return
	end
	if required then
		return fn()
	end
	fn()
end

shared.pload = pload
getgenv().pload = pload

shared.VapeIndependent = true
local vape = loadstring(downloadFile('newvape/guis/new.lua'), 'gui')()
shared.vape = vape

loadstring(downloadFile('newvape/games/bedwars_bootstrap.lua'), 'bedwars_bootstrap')()

if vape.Init then
	vape.Init()
end

pcall(function()
	if vape.gui and vape.gui.ScaledGui and vape.gui.ScaledGui.ClickGui then
		vape.gui.ScaledGui.ClickGui.Visible = false
	end
end)

if not shared.vapereload and vape.Categories and vape.Categories.Main and vape.Categories.Main.Options['GUI bind indicator'] then
	if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
		vape:CreateNotification('NOVA Loaded', 'Press RIGHT SHIFT to open the menu', 8)
	end
end
