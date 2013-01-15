-- Original version by Stuart Ross - 10/1/2013

function require(api)
  shell.run(api)
end

require('/lib/libfetch')

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

  return libfetch.fetchViaGit( args[1], args[2] )
end

local args = {...}
return main(args)
