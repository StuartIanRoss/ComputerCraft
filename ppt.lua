-- Pew Package Tool
-- Originally by Stuart Ross, 12/01/2013

-- Requires gitfetch

local args = {...}

function printUsage()
	print('USAGE:')
	print(' ppt get <package name> - Forces download and install of <package name>')
	print(' ppt upgrade - Upgrades all packages that are currently out of date')
	print(' ppt upgrade <package name> - Upgrades <package name> if required')
	print(' ppt update - Downloads the latest package list')
	print(' ppt list - Prints out all available packages')
end

-- Gets the file at remotePath from the default fetch service, and stores it in localPath
function getFile(remotePath,localPath)
  if shell.run('/bin/gitfetch',remotePath,localPath) then
  elseif shell.run('gitfetch', remotePath,localPath) then
  else
    print('Failed to find gitfetch. Could not download file.')
    return false
  end
  
  return true
end

function updatePackageList(force)
  force = force or false
  if force or not fs.exists('/etc/_pptpackages') then
    if getFile('_pptpackages', '/etc/_pptpackages') then
      print('Updated package list from server')
    else
      print('Could not update package list from server.')
    end
  end
end

function loadPackageList(force)
  updatePackageList(false)
  local handle = fs.open('/etc/_pptpackages','r')
  local packageList = nil
  
  repeat
    local packageLine = handle.readLine()
    if packageLine then
      local packageInfo = textutils.unserialize(allContents)
      
      if packageInfo.name and packageInfo.repoPath and packageInfo.localPath then
        if not packageList then
          packageList = {}
        end
        packageList[packageInfo.name] = packageInfo
      end
    end
  until not packageLine
  
  handle.close()
  
  return packageList
end

function printPackages(packageList)
  if not packageList then
    print('No packages found!')
    return
  end
  
  for k, v in pairs(packageList) do
    if(v.desc) then
      print(k .. ' - ' .. v.desc)
    else
      print(k)
    end
  end
  print(#packageList .. ' total packages')
end

function loadPackageVersions()
  local packageVersions = nil
  
  local handle = fs.open('/etc/_pptversions','r')
  if handle then
    packageVersions = textutils.unserialize( handle.readLine() )
    handle.close()
  end
  
  return packageVersions
end

function recordPackageVersion(packageName, newVersion)
  local packageVersions = loadPackageVersions()
  
  packageVersions = packageVersions or {}
  
  packageVersions[packageName] = newVersion
  
  local handle = fs.open('/etc/_pptversions','w')
  if handle then
    handle.writeLine( textutils.serialize( packageVersions ) )
  else
    print('Failed to open versions file to update version')
  end
end

function updateAllPackages(packageList, packageVersions)
  packageVersions = packageVersions or loadPackageVersions()
  if not packageVersions then
    print('No packages installed.')
    return
  end
  for k,v in pairs(packageList) do
    -- Check that this package is installed
    if packageVersions[k] then
      installPackage(packageList, k, false, packageVersions)
    end
  end
end

function installPackage(packageList, packageName, forceUpdate, packageVersions)
  forceUpdate = forceUpdate or false
  if not forceUpdate and not packageVersions then
    packageVersions = loadPackageVersion()
  end
  if not packageList then
    print('No packages found!')
    return
  end
  
  local packageInfo = packageList[packageName]
  if not packageInfo then
    print('Package ' .. packageInfo .. ' not found in list.')
    return
  end
  
  if not forceUpdate and packageVersions and packageVersions[packageName] and packageVersions[packageName] < packageInfo.ver then
    print('Package ' .. packageName .. ' is already at the latest version.')
    return
  end
  
  if packageInfo.deps then
    print('Installing dependencies for ' .. packageName)
    for i, dep in ipairs(packageInfo.deps) do
      installPackage(packageList, dep, false, packageVersions)
    end
  end
  
	if not getFile(packageInfo.repoPath,packageInfo.localPath) then
	  print('Failed to download package ' .. packageName)
	  return
	end
	
	if not fs.exists(packageInfo.localPath) then
	  print('Failed to install package ' .. packageName)
	  return
	else
	  print('Successfully installed package ' .. packageName)
  	if packageInfo.ver then
  	  recordPackageVersion(packageName, packageInfo.ver)
  	end
	end
	if packageInfo.alias then
	  shell.setAlias(packageInfo.alias, packageInfo.localPath)
	  print('Set ' .. packageInfo.alias .. ' as alias for ' .. packageInfo.name)
	end
end

function run(args)
  if #args == 0 then
	  printUsage()
  elseif args[1] == "update" then
    updatePackageList(true)
  else
    local packageList = loadPackageList()
    if args[1] == "list" then
      printPackages(packageList)
    elseif args[1] == "upgrade" then
      local packageVersions = loadPackageVersions()
      if not args[2] then
        updateAllPackages(packageList, packageVersions)
      else
        installPackage(packageList, args[2], false, packageVersions)
      end
	  elseif args[1] == "get" and args[2] then
		  installPackage(packageList, args[2],true)
	  else
		  printUsage()
	  end
  end
end

run(args)