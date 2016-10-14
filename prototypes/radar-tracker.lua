
-- load all tracker prototypes

for tracker_name, _c in pairs(_config) do
	
	require("prototypes.trackers." .. tracker_name)
	init_tracker(tracker_name, _c)
	
end
