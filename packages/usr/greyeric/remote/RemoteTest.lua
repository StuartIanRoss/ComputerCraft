
function require(lib)
	shell.run(lib)
end

require('/usr/greyeric/remote/Stack')
require('/usr/greyeric/remote/Actions')

plan = { 0x01, 0x04, 0xFF, 0xFF, 0xFF, 0x00 }
pos = 0

while plan[pos] ~= nil do
	performAction(plan[pos])
	pos = pos + 1
end
