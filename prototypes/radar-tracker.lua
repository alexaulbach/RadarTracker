
-- load all prototypes

tracker_name = ""
_c = {}
for tracker_name, _c in pairs(_config) do
	
	log("XXXX " .. tracker_name)
	for name,val in pairs(_c) do
		log("XXXXX" .. name .. " " .. val)
	end
	
	require("prototypes.trackers." .. tracker_name)
	
end
