-- connects to a echo websocket server running a localhost:8080
-- sends a strong every second and prints the echoed messages
-- to stdout

-- local ev = require'ev'

-- ws_client:on_open(function()
--     print('connected')
--   end)


-- ws_client:on_message(function(ws, msg)
--     print('received',msg)
--   end)

-- local i = 0

local copas=require'copas'
local ws_client

local sslparams = {
	mode = "client",
	protocol = "tlsv1_2",
	verify = "none",
	options = "all",
}

copas.addthread(function ( )
	copas.sleep(0.1)
	local ws_uri="wss://www.bitmex.com/realtime?subscribe=trade:XBTUSD,orderBookL2_25:XBTUSD"
	-- local ws_uri='wss://echo.websocket.org'
	ws_client = require('websocket.client').copas()
	local r,msg=ws_client:connect(ws_uri,'wss',sslparams)
	-- local r,msg=ws_client:connect(ws_uri, "wss", sslparams)
	print('connected',r,msg)
	if not r then
		return
	end
	connected = true
	while true do
		l=ws_client:receive()
		print('received',l)
		copas.sleep(0.1)
	end
end)

copas.addthread(function ( )
	copas.sleep(0.1)
	cnt = 1
	while true do
	 cnt=cnt+1
	 if cnt>200 then
	 	cnt = 0
	 	if connected then
	 		print('send')
	 		ws_client:send('ping')
	 	end
	 end
	 copas.sleep(0.1)
	end
end)

-- cnt = 1
-- while true do
--  copas.step(1)
--  cnt=cnt+1
--  if cnt>100 then
--  	cnt = 0
--  	if ws_client then
--  		print('send')
--  		ws_client:send('test')
--  	end
--  end

-- end
copas.loop()