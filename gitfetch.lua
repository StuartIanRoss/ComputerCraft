-- Original version by Stuart Ross - 10/1/2013

function fetchFile(url, filename)
  shell.run('fetch', url, filename)
end

function buildUrl(root, user, repo, filename)
  return root .. '/' .. user .. '/' .. repo .. '/master/' .. filename .. '.lua' 
end

function printUsage()
  print('Usage:')
  print('gitfetch <name of file> : will fetch <name of file>.lua from the default')
  print(' repo and store with that name')
  print('gitfetch <name of file> <target name> : will fetch <name of file>.lua')
  print(' from the default repo and store with the name <target name>')
end

function main(args)
  local urlRoot = 'https://raw.github.com'
  local user = 'StuartIanRoss' -- Default
  local repo = 'ComputerCraft' -- Default
  if #args == 0 or #args > 2 then
    printUsage()
    return
  end
	
  local filename = args[1]

  local url = buildUrl(urlRoot, user, repo, filename)
  if #args == 1 then
    fetchFile( url, filename )
  elseif #args == 2 then
    fetchFile( url, args[2] )
  end
end

local args = {...}
main(args)
