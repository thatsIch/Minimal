function Initialize()
	-- body
end

function Update()
	file = io.open("http://www.spiegel.de/schlagzeilen/tops/index.rss")

	print(file)

	io.close(file)
end