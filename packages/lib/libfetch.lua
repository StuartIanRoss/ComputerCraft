-- libfetch
--
-- A collection of functions for getting files from the web
-- Created by Stuart Ross 14/1/2013
-- Generic fetch by William Pond
-- Git fetch by Stuart Ross

_LibFetch = {}

_LibFetch.new = function()

  local self = {}
  
  -- Generic
  self.fetchFile = function(url, outputPath)
    if shell.run('/bin/fetch', url, outputPath) then
    elseif shell.run('fetch', url, outputPath) then
    else
      print('Failed to find fetch, could not download file.')
      return false
    end
  
    return true
  end
  -- End generic

  -- Git
  self._loadRepoSettings = function()
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

  self._buildGitUrl = function(repoPath)
    local root = self.currentRepo.root or 'https://raw.github.com'
    local user = self.currentRepo.user or 'StuartIanRoss'
    local repo = self.currentRepo.repo or 'ComputerCraft'
    local branch = self.currentRepo.branch or 'master'
    return root .. '/' .. user .. '/' .. repo .. '/' .. branch .. '/' .. repoPath
  end

  self.fetchViaGit = function(repoPath,localPath)
    self._loadRepoSettings()
    local url = self._buildGitUrl(repoPath)
    return self.fetchFile( url, localPath )
  end
  -- End Git
  
  return self
end

libfetch = _LibFetch.new()