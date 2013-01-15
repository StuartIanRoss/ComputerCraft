-- Original version William Pond - 10/1/2013
-- Modified by Stuart Ross

function require(api)
  shell.run(api)
end

require('/lib/libfetch')

function printUsage()
  print('Usage:')
  print('fetch <raw url> <output path> : will fetch file at <raw url> and save it as <output path>')
end

function main(args)
  if #args ~= 2 then
    printUsage()
    return
  end

  return libfetch.fetchFile( args[1], args[2] )
end

local args = {...}
return main(args)