
function require(lib)
	shell.run(lib)
end

require('/usr/greyeric/remote/Stack')
require('/usr/greyeric/remote/Actions')

performAction(0x01)
performAction(0x02)
performAction(0x03)
performAction(0x00)
