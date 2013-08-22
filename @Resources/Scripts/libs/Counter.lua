local function __Counter()
	local self = {}

	local value = 0

	function self.reset() value = 0 end
	function self.get() return value end
	function self.inc() value = value + 1 return value end
	function self.dec() value = value - 1 return value end

	return self
end

Counter = __Counter()
Process = __Counter()