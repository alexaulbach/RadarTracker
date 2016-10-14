# RadarTracker
This is a Factorio mod. It adds a new types of radars:
- Mobile tracker: Scans every half seconds any running device and tries to look forward.

You need to research the different radar-tracker-technologies and place the radars.
 
#Changes to the original train-tracker:
This is originally a mod called "train-tracker". See below for "Background".

Changes:
- Technology can be researched now after electric-energy-distribution-1
- config.lua enables to control the parameters of the entity
- default config now scans only every **2 seconds** (vs. 1 second)- performance reasons and I think it should not work absolutely perfect and leave out sometimes a scan.
- it scans now a larger area around the train (10 vs. 5 tiles). This avoids "widow lines" in scanning.

Most of the fixes where to balance this mod more into really big maps.

## Not yet working additions
I want to implement a way to track also other vehicles than trains and see their surrounding, if standing around. Therefore you can place the vehicular-tracker. But this is alpha-alpha yet. Not working, so do not use. :)

#Background
This mod is is formerly known as **Rail-Tracker** by MrDoomah.
https://forums.factorio.com/viewtopic.php?f=92&t=18368
It was updated to v0.13 by Optera (in the same thread).

To be honest, the biggest reason why I did this was, that I had overseen, that Optera did a 0.13 fix, so I fixed it too for myself (cause I needed it for playing on my really big map). I think I wouldn't have it, if I read the whole thread. But when I was on it I fixed here a bit and there a bit and I had some more ideas (The second reason was learning more Lua programming and Factorio mods of course).
And suddenly it was as it was. Then I though: Would be a pity not to publish it. Forgive me, it's my first mod. :)

##Version history
0.1.3 2016-09-30 
- Introduced tracker types. Types are: trains (locos or wagons), stops (all train stops), cars (cars, tanks, satellite-uplink...); currently still only trains works.
- Rewrote initialization. on a very large map (8 GiB) with >300 trains initialisation takes only 20 seconds vs. hours from before.
- Avoid double reinitialization.
- Re-increased scan rate cause I want to reduce average number of scans per train. Also looks much better.

0.1.2 2016-09-04
- Initial version

##Git Hub
https://github.com/alexaulbach/RadarTracker

##Ideas
Currently every entity of a train (wagons and locos) will scan forward in the driving direction. Even if the train is not moving. That is for every part of a train one scan.

Instead the train should use only the locomotives to scan, while driving (only one scan).
When stopped only front and back loco is scanned every 10 (?) seconds.
When stopped on a train-stop only the back needs to be scanned.

For this I need to have different lists:

global.trains -> needed only one times after startup.
For each train it generates an event on_train_changed_state. Which brings it into a new list:

Depending on state the current front loco is added to

RunningTrains
StandingTrains

Depending on that the trains are scanned by different radars in different intervalls with different methods.

### more Ideas
- Static tracker: This scans every 30 seconds all vehicles, that are not moving, including trains.
- Immovable property: This radar scans once in a minute like real radar:
 It rotates with small degrees per second and scans chunks up to a distance of 2500 tiles,
 that have some buildings of your property on it. This takes a lot of energy, depending on the distance!
- Cars: Scan large area in front of car if moving, scan only every 10 secs and small area if standing.
- Train-stops: Scan only every 30 (?) secs.
- Tracker can scan only vehicles in range (I think to 2500 tiles radius, which is quite big). This needs to introduce to bind trains to trackers.
- The more trains a tracker needs to scan then, the slower it will refresh.
- Research each tracker-type on it's own (bring back research for train-tracker after rail-tech).
- A little bit better estimation of the path the train will drive to scan the ground before the entity it reaches and re-scan of missed out chunks in an most effective way.
- Same for other vehicles. Trains can scan forward, but other vehicles have no Lua-interface for speed etc. 
- Better integration into FatController: The initial scan for the trains and train-management is made much more clever there.
- Simple list of vehicles other than trains, a bit of The Fat Controller for cars/tanks/other vehicle, but perhaps this should be done in another mod then.
- Some kind of remote control for cars/tanks/other vehicles than train, also like FatController, but perhaps this should be done in another mod then.
- Upgrade function to convert the train-tracker radar to to radar-tracker (good learning subproject).
- "Train Radar"  - some special type of locomotive/wagon. The train can be programmed to drive in circles to scan the area beside your rails in regular intervals, but needs excessive amounts of energy.
- Add similar functionality to scan-robots. You can send them out and they will automatically reveal map.
- Add a new radar-functionality, which scans 360˚ in a minute, but only those chunks, that have entities built on ground. Range depends only on power it can get.
