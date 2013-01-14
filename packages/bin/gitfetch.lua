-- Original version by Stuart Ross - 10/1/2013

local gitfetch = {}

function gitfetch:loadRepoSettings()
  local handle = fs.open('/etc/_gitfetch','r')
  if handle then
    local line = handle.readLine()
    if line then self.currentRepo = textutils.unserialize( line ) end
    handle.close()
    return
  end
  
  self.currentRepo = {root='https://raw.github.com',user='StuartIanRoss',repo='ComputerCraft',branch='master'}
  
  handle = fs.open('/etc/_gitfetch','w')
  if handle then
    handle.writeLine(textutils.serialize(self.currentRepo))
    handle.close()
  end
end

function gitfetch:fetchFile(url, outputPath)
  if shell.run('/bin/fetch', url, outputPath) then
  elseif shell.run('fetch', url, outputPath) then
  else
    print('Failed to find fetch, could not download file.')
    return false
  end
  
  return true
end

function gitfetch:buildUrl(repoPath)
  local root = self.currentRepo.root or 'https://raw.github.com'
  local user = self.currentRepo.user or 'StuartIanRoss'
  local repo = self.currentRepo.repo or 'ComputerCraft'
  local branch = self.currentRepo.branch or 'master'
  return root .. '/' .. user .. '/' .. repo .. '/' .. branch .. '/' .. repoPath
end

function gitfetch:printUsage()
  print('Usage:')
  print('gitfetch <repo path> <output path> : will fetch at <repo path> in the current repo and branch')
  print(' and save it in <target path>')
end

function gitfetch:main(args)
  if #args ~= 2 then
    self:printUsage()
    return
  end
  
  self:loadRepoSettings()
	
  local repoPath = args[1]

  local url = self:buildUrl(repoPath)
  return self:fetchFile( url, args[2] )
end

local args = {...}
return gitfetch:main(args)
