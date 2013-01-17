-- Pew Package Tool
-- Originally by Stuart Ross, 12/01/2013

function require(api)
 shell.run('/lib/' .. api)
end

require('libfetch')

local args = {...}

local ppt = {}

function ppt:printUsage()
	print('USAGE:')
	print(' ppt get <package name> - Forces download and install of <package name>')
	print(' ppt upgrade - Upgrades all packages that are currently out of date')
	print(' ppt upgrade <package name> - Upgrades <package name> if required')
	print(' ppt update - Downloads the latest package list')
	print(' ppt list - Prints out all available packages')
end

-- Gets the file at remotePath from the default fetch service, and stores it in localPath
function ppt:getFile(remotePath,localPath)
  return libfetch.fetchViaGit( remotePath, localPath )
end

-- Gets and stores the list of packages available from the server
function ppt:updatePackageList(force)
  force = force or false
  if force or not fs.exists('/etc/_pptpackages') then
    if self:getFile('_pptpackages', '/etc/_pptpackages') then
      print('Updated package list from server')
    else
      print('Could not update package list from server.')
    end
  end
end

-- Loads and parses the list of packages available
function ppt:loadPackageList(force)
  self:updatePackageList(false)
  local handle = fs.open('/etc/_pptpackages','r')
  local packageList = nil
  
  repeat
    local packageLine = handle.readLine()
    if packageLine then
      local packageInfo = textutils.unserialize(packageLine)
      
      if packageInfo.name and packageInfo.repoPath and packageInfo.localPath then
        if not self.packageList then
          self.packageList = {}
        end
        self.packageList[packageInfo.name] = packageInfo
      end
    end
  until not packageLine
  
  handle.close()
end

-- Prints a list of packages that can be installed
function ppt:printPackages()
  if not self.packageList then
    print('No packages found!')
    return
  end
  
  local finalString = ""
  for k, v in pairs(self.packageList) do
    if(v.desc) then
      finalString = finalString .. k .. ' - ' .. v.desc .. '\n'
    else
      finalString = finalString .. k .. '\n'
    end
  end
  textutils.pagedPrint(finalString,10)
  print(#self.packageList .. ' total packages')
end

-- Loads the file storing versions of installed packages
function ppt:loadPackageVersions()
  local handle = fs.open('/etc/_pptversions','r')
  if handle then
    local line = handle.readLine()
    if line then self.packageVersions = textutils.unserialize( line ) end
    handle.close()
  end
end

-- Update the installed version of a package
function ppt:recordPackageVersion(packageName, newVersion)
  self.packageVersions = self.packageVersions or {}
  self.packageVersions[packageName] = newVersion
end

-- Output the file storing versions of installed packages
function ppt:savePackageVersions()
  if not self.packageVersions then
    print('Not saving versions. No packages installed')
    return
  end
  local handle = fs.open('/etc/_pptversions','w')
  if handle then
    handle.writeLine( textutils.serialize( self.packageVersions ) )
    handle.close()
  else
    print('Failed to save package versions')
  end
end

-- Update all installed packages if required
function ppt:updateAllPackages()
  if not self.packageVersions then
    print('No packages installed.')
    return
  end
  for k,v in pairs(self.packageList) do
    -- Check that this package is installed
    if self.packageVersions[k] then
      self:installPackage(k, false, true)
    end
  end
end

-- Install or update a package
function ppt:installPackage(packageName, forceUpdate, dontUpdateDeps)
  dontUpdateDeps = dontUpdateDeps or false
  forceUpdate = forceUpdate or false
  if not forceUpdate and not self.packageVersions then
    self:loadPackageVersions()
  end
  if not self.packageList then
    print('No packages found!')
    return
  end
  
  local packageInfo = self.packageList[packageName]
  if not packageInfo then
    print('Package ' .. packageName .. ' not found in list.')
    return
  end
  
  if self.packageVersions and self.packageVersions[packageName] then
    print(packageName .. ': Installed version is ' .. self.packageVersions[packageName])
  end
  print(packageName .. ': Repo version is ' .. packageInfo.ver)
  if not forceUpdate and self.packageVersions and self.packageVersions[packageName] then
    if self.packageVersions[packageName] == packageInfo.ver then
      print('Package ' .. packageName .. ' is already at the latest version.')
      return
    elseif self.packageVersions[packageName] > packageInfo.ver then
      print('Package ' .. packageName .. ' is at a newer version than the repo.')
      return
    end
  end
  
  if not dontUpdateDeps and packageInfo.deps then
    print('Installing dependencies for ' .. packageName)
    for i, dep in ipairs(packageInfo.deps) do
      self:installPackage(dep, false)
    end
  end
  
  local success = true
  if type(packageInfo.repoPath) == "table" or type(packageInfo.localPath) == "table" then
    if type(packageInfo.repoPath) ~= "table" then
      print('Local path for package ' .. packageName .. ' is a table, but repo path is not.')
      return
    end
    if type(packageInfo.localPath) ~= "table" then
      print('Repo path for package ' .. packageName .. ' is a table, but local path is not.')
      return
    end
    if #packageInfo.repoPath ~= #packageInfo.localPath then
      print('The repo path and local path tables for ' .. packageName .. ' are different lengths.')
      return
    end
    
    for i, v in ipairs(packageInfo.repoPath) do
    	if not self:getFile(v,packageInfo.localPath[i]) then
	      print('Failed to download file ' .. i .. ' of package ' .. packageName)
	      return
    	end
	
	    if not fs.exists(packageInfo.localPath[i]) then
	      print('Failed to install file ' .. i .. ' of package ' .. packageName)
  	    return
    	end
    end
  else
  	if not self:getFile(packageInfo.repoPath,packageInfo.localPath) then
	    print('Failed to download package ' .. packageName)
	    return
  	end
	
	  if not fs.exists(packageInfo.localPath) then
	    print('Failed to install package ' .. packageName)
  	  return
  	end
	end
	
	if success then
	  print('Successfully installed package ' .. packageName)
  	if packageInfo.ver then
  	  self:recordPackageVersion(packageName, packageInfo.ver)
  	end
	end
	if packageInfo.alias then
	  shell.setAlias(packageInfo.alias, packageInfo.localPath)
	  print('Set ' .. packageInfo.alias .. ' as alias for ' .. packageInfo.name)
	end
end

function ppt:run(args)
  if #args == 0 then
	  self:printUsage()
  elseif args[1] == "update" then
    self:updatePackageList(true)
  else
    self:loadPackageList()
    if args[1] == "list" then
      self:printPackages()
    elseif args[1] == "upgrade" then
      self:updatePackageList(true)
      self:loadPackageVersions()
      if not args[2] then
        self:updateAllPackages()
      else
        self:installPackage(args[2], false)
      end
      self:savePackageVersions()
	  elseif args[1] == "get" and args[2] then
		  self:installPackage(args[2],true)
		  self:savePackageVersions()
	  else
		  self:printUsage()
	  end
  end
end

ppt:run(args)