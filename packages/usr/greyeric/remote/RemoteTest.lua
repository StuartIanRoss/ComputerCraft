
function require(lib)
	shell.run(lib)
end

require('/usr/greyeric/remote/Stack')
require('/usr/greyeric/remote/Actions')

performAction(0x01)
performAction(0x04)
performAction(0xFF)
performAction(0xFF)
performAction(0xFF)
performAction(0x00)
