# RadarTracker
This is a Factorio mod. It adds a new radar called "train-tracker". If you place that trains will track their path as if they have built in a small internal radar.

You need to research radar-tracker technology and place a train-tracker anywhere and the trains scans the area around them.

#Changes to the original train-tracker:
This is originally a mod called "train-tracker". See below for "Background".

Changes:
- Technology can be researched now after electric-energy-distribution-1
- config.lua enables to control the parameters of the entity
- default config now scans only every **2 seconds** (vs. 1 second)- performance reasons and I think it should not work absolutely perfect and leave out sometimes a scan.
- it scans now a larger area around the train (10 vs. 5 tiles). This avoids "widow lines" in scanning.

Most of the fixes where to balance this mod more into really big maps.

## Not yet working additions
Additionally I wanted to implement a way to track also other vehicles than trains and see their surrounding, if standing around. Therefore you can place the vehicular-tracker. But this is alpha-alpha yet. Not working, so do not use. :)

#Background
This mod is is formerly known as **Rail-Tracker** by MrDoomah.
https://forums.factorio.com/viewtopic.php?f=92&t=18368
It was updated to v0.13 by Optera (in the same thread).

To be honest, the biggest reason why I did this was, that I had overseen, that Optera did a 0.13 fix, so I fixed it too for myself (cause I needed it for playing on my really big map). I think I wouldn't have it, if I read the whole thread. But when I was on it I fixed here a bit and there a bit and I had some more ideas (The second reason was learning more Lua programming and Factorio mods of course).
And suddenly it was as it was. Then I though: Would be a pity not to publish it. Forgive me, it's my first mod. :)


#Version history

0.1.2 2016-09-04 Initial version

#Ideas

- Research each tracker-type on it's own (bring back research for train-tracker after rail-tech).
- A better estimation of the path the train will drive to scan the ground before the entity it reaches and re-scan of missed out chunks in an most effective way.
- Same for other vehicles. Trains can scan forward, but other vehicles have no Lua-interface for speed etc. 
- Better integration into FatController: The initial scan for the trains and train-management is made much more clever there.
- Simple list of vehicles other than trains, a bit of The Fat Controller for cars/tanks/other vehicle, but perhaps this should be done in another mod then.
- Some kind of remote control for cars/tanks/other vehicles than train, also like FatController, but perhaps this should be done in another mod then.
- Upgrade function to convert the train-tracker radar to to radar-tracker (good learning subproject).
- "Train Radar"  - some special type of locomotive/wagon. The train can be programmed to drive in circles to scan the area beside your rails in regular intervals, but needs excessive amounts of energy.
- Add similar functionality to scan-robots. You can send them out and they will automatically reveal map.