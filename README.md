# RadarTracker
This is a Factorio mod. It adds a new types of "trackers":
- Immovebles tracker: This scans train-stops every 30 seconds. No need to place radars everywhere.
- Movement tracker: Scans every vehicle. If it is driving every 1/2 seconds and tries to look forward, if not only every 10 seconds.
- Rotation tracker: Scans a very wide range (2000 tiles) in a circle, like real radars. Only chunks with owend entities on it. Takes some time for a rotation. THIS IS NOT READY YET; the entity has no function.

You need to research the different radar-tracker-technologies and place the radars.
 
### Features:
- Fast initialization: Initial scan of a 20,000 tiles-map in under 10 seconds. 
- Runs Fast: For 300 trains (600 entities) only 3 updates per second slower.
- Debug-mode. Useful...
- Configuration file
- Tracks only first and last unit of a train instead of the whole train

#Background: train-tracker
This is originally a mod called "train-tracker". See below for "Background".

This mod is is formerly known as **Rail-Tracker** by MrDoomah.
https://forums.factorio.com/viewtopic.php?f=92&t=18368
It was updated to v0.13 by Optera (in the same thread).

To be honest, the biggest reason why I did this was, that I had overseen, that Optera did a 0.13 fix, so I fixed it too for myself (cause I needed it for playing on my really big map). I think I wouldn't have it, if I read the whole thread. But when I was on it I fixed here a bit and there a bit and I had some more ideas (The second reason was learning more Lua programming and Factorio mods of course).
And suddenly it was as it was. Then I though: Would be a pity not to publish it. Forgive me, it's my first mod. :)

##Version history
0.3.0 2016-10-31
- stabilized, immoveables and movement tracker now works completely.
- debug-mode

0.1.3 2016-09-30 
- Introduced tracker types. Types are: trains (locos or wagons), stops (all train stops), cars (cars, tanks, satellite-uplink...); currently still only trains works.
- Rewrote initialization. on a very large map (8 GiB) with >300 trains initialisation takes only 20 seconds vs. hours from before.
- Avoid double reinitialization.
- Re-increased scan rate cause I want to reduce average number of scans per train. Also looks much better.

0.1.2 2016-09-04
- Initial version

##Git Hub
https://github.com/alexaulbach/RadarTracker

##Ideas/TODOs
- New entity/item images.
- Move one directory level lower.
- Script for automated packaging (Zip)
- Track only front entity if train is running.
- Don't track back entity if no reverse loco.
- Look if new chunk found and only then chart that chunk.
- Tracker can scan only vehicles in range (I think to 2500 tiles radius, which is quite big). This needs to introduce to bind trains to trackers.
- The more trains a tracker needs to scan then, the slower it will refresh.
- Rotational-Tracker: Add a new radar-functionality, which scans 360˚ in a minute, but only those chunks, that have entities built on ground. Range depends only on power it can get.
- Once-Tracker: Scans when entity is built/removed
- Random-Tracker: Randomly scan minerals by revealing a similar "virtual" surface. Good to search for far away minerals without revealing current map.
- Upgrade function to convert (several) the train-tracker radars to to radar-tracker (good learning subproject).
- Scanner-robots. You can send them out and they will automatically reveal map.
- "Train Radar"  - some special type of locomotive/wagon. The train can be programmed to drive in circles to scan the area beside your rails in regular intervals, but needs excessive amounts of energy.
