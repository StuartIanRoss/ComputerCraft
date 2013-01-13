-- Original version by Stuart Ross - 10/1/2013

function loadRepoSettings()
end

function fetchFile(url, outputPath)
  if shell.run('/bin/fetch', url, outputPath) then
  elseif shell.run('fetch', url, outputPath) then
  else
    print('Failed to find fetch, could not download file.')
    return false
  end
  
  return true
end

function buildUrl(repoPath, root, user, repo, branch)
  root = root or 'https://raw.github.com'
  user = user or 'StuartIanRoss'
  repo = repo or 'ComputerCraft'
  branch = branch or 'master'
  return root .. '/' .. user .. '/' .. repo .. '/' .. branch .. '/' .. repoPath
end

function printUsage()
  print('Usage:')
  print('gitfetch <repo path> <output path> : will fetch at <repo path> in the current repo and branch')
  print(' and save it in <target path>')
end

function main(args)
  if #args ~= 2 then
    printUsage()
    return
  end
	
  local repoPath = args[1]

  local url = buildUrl(repoPath)
  return fetchFile( url, args[2] )
end

local args = {...}
return main(args)
