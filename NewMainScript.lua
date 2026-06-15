local VAPE_REPO = 'localboostwebsite-png/VapeV4ForRoblox'
local BUILD_ID = 'nova-bedwars-8'
shared.VapeNovaBuild = BUILD_ID

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end
local listfiles = listfiles or function() return {} end
local isfolder = isfolder or function(path)
	return isfile(path) or pcall(function() makefolder(path) end)
end

local function isLegacyKickScript(content)
	if type(content) ~= 'string' then return false end
	return content:find(':Kick', 1, true) ~= nil and content:find('5 years of support', 1, true) ~= nil
end

local function nukeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if isfile(file) then
			pcall(function() delfile(file) end)
		elseif isfolder(file) then
			nukeFolder(file)
		end
	end
end

local function purgeKickFiles()
	for _, root in {'newvape', 'vape'} do
		if isfolder(root) then
			for _, file in listfiles(root) do
				if isfile(file) and file:find('%.lua') then
					local ok, content = pcall(readfile, file)
					if ok and isLegacyKickScript(content) then
						pcall(function() delfile(file) end)
					end
				end
			end
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

local cachedBuild = isfile('newvape/profiles/build.txt') and readfile('newvape/profiles/build.txt') or ''
if cachedBuild ~= BUILD_ID then
	nukeFolder('newvape/games')
	nukeFolder('newvape/guis')
	nukeFolder('newvape/libraries')
	purgeKickFiles()
	writefile('newvape/profiles/build.txt', BUILD_ID)
end
purgeKickFiles()

local branch = 'main'
if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/'..VAPE_REPO)
	end)
	if subbed then
		local commit = subbed:find('currentOid')
		commit = commit and subbed:sub(commit + 13, commit + 52) or nil
		if commit and #commit == 40 then
			branch = commit
		end
	end
	writefile('newvape/profiles/commit.txt', branch)
end

local function fetchFromGithub(relativePath, localPath)
	local url = 'https://raw.githubusercontent.com/'..VAPE_REPO..'/'..branch..'/'..relativePath
	local suc, res = pcall(function()
		return game:HttpGet(url, true)
	end)
	if not suc or not res or res == '404: Not Found' then
		error('Failed to download '..relativePath..' from '..VAPE_REPO..': '..tostring(res))
	end
	if relativePath ~= 'main.lua' and isLegacyKickScript(res) then
		error('Blocked old Vape kick script in '..relativePath)
	end
	if res:sub(1, 3) == '\239\187\191' then
		res = res:sub(4)
	end
	res = res:gsub('\239\187\191', '')
	if relativePath:find('%.lua') then
		res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
	end
	writefile(localPath, res)
	return res
end

-- Always fetch entry main.lua fresh so stale cache cannot load old Vape
local mainSource = fetchFromGithub('main.lua', 'newvape/main.lua')
return loadstring(mainSource, 'main')()
