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
    
    if not fs.exists(outputPath) then
      -- makeDir works recursively, so this creates the target file as a dir, and all
      -- parent dirs. We then just delete the dir that will become the file.
      fs.makeDir(outputPath)
      fs.delete(outputPath)
    end

    f = fs.open(outputPath, "w")
    if f then
	  local contents = self.fetchContents(url)
	  if contents == nil then
	    return false
	  end
      f.write(contents)
      f.close()
    else
      print("Failed to open target file")
      return false
    end

    src.close()
  
    return true
  end
  -- End generic
  
  self.fetchContents = function(url)
	local src = http.get(url)

    if src == nil then
      print("Failed to fetch" .. url)
      return nil
    end
    
    local contents = src.readAll()
    src.close()
    
    return contents
    
  end
  
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