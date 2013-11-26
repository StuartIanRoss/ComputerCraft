
_s = {}

function stackEmpty()
	return #_s == 0
end

function stackPush(i)
	_s[#_s] = i
end

function stackPop()
	
	if stackEmpty() then
		return nil
	end
	
	i = _s[#_s-1]
	_s[_s-1] = nil
	
	return i
	
end
