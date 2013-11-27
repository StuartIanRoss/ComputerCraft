
_s = {}

function stackCount()
	count = 0
	for k,v in pairs(_s) do
		count = count + 1
	end
	return count
end

function stackEmpty()
	return stackCount() == 0
end

function stackPush(i)
	_s[stackCount()] = i
end

function stackPop()
	
	if stackEmpty() then
		return nil
	end
	
	i = _s[stackCount()-1]
	_s[stackCount()-1] = nil
	
	return i
	
end
