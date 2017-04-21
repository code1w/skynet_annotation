local skynet = require "skynet"
local socket = require "socket"

local function server()
	local host
	host = socket.udp(function(str, from)
		print("server recv", str, socket.udp_address(from))
		socket.sendto(host, from, "OK " .. str)
	end , "127.0.0.1", 8765)	-- bind an address
end

local function client()
	local c = socket.udp(function(str, from)
		print("client recv", str, socket.udp_address(from))
	end)
	socket.udp_connect(c, "192.168.1.181", 8765)
	local i = 1
	while true do
		--for i=1,20 do
		socket.write(c, "hello dns id = ".. i)	-- write to the address by udp_connect binding
		--end
		i = i + 1
		if i == 1000001 then
			i = 1
		end
		skynet.sleep(100)
	end
end

skynet.start(function()
	--skynet.fork(server)
	skynet.fork(client)
end)
