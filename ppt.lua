-- Pew Package Tool
-- Originally by Stuart Ross, 12/01/2013

-- Requires gitfetch

local args = {...}

function printUsage()
	print('USAGE:')
	print(' ppt get <package name> - Downloads and installs <package name>')
end

function loadPackageList()
end

function installPackage(packageName)
	shell.run('/gitfetch',packageName)
end

if #args == 0 then
	printUsage()
else
	if #args[1] == "get" and #args[2] then
		installPackage(args[2])
	else
		printUsage()
	end
end