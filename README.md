# RadarTracker
This is a Factorio mod. It adds a new types of "trackers".

## Description
This mod is for bigger factories, that already covers a wide area and a bigger train-network.
But it is also useful for exploration by car/tank.

Radar-tracker tries to let you keep track of your factory: It triggers _charting_ (actualization of the map)
only for the "most important" things, like
- train-stops (immoveables)
- trains, cars and tanks (movement)

### About Charting (technical)
Charting is the action, when a radar scans a chunk. Only whole chunks (32x32 tiles) can be charted.

Once a chunk is charted, it keeps up-to-date for **10 seconds** (this is default game-mechanics).
Within that time the piece of map for this chunk is updated for every tick.
You can see that cleary when you look on the map and a chunk suddenly is highlighted and then gets darker and darker
until it is the same color as the other uncharted chunks.
In other words: 10 seconds after the last chart of a chunk the map of this chunk falls back into the "fog of war": The map is not re-charted
and what you see on map might be outdated.

This means: The default radar charts an area of 100x100 tiles every tick (100x100 means the chunks,
that are "touched" by this area will be charted).
 
**This is an CPU-expensive operation if you place many radars!**

So for very big factories it is a good idea to reduce the number of radars. But with growing factory you just
need the overview!

### Goals
This mod tries to achieve this goals:
- Remove stupid game-play to place more and more radars to keep track.
- Keep track of your *most important* stuff without always need to place another radar.
- Reduce need for CPU-expensive full-scan radar and replace with a "good-enough" charting.
- Add a new game-play that it makes sense to switch the new trackers off if they take too much energy.

## Docs

### Entities
You can research the entities in the following order:

#### Immovebles tracker
Charts train-stops every 30 seconds. No need to place radars everywhere.

This means: A train-stop is charted once every 30 seconds, then it keeps 10 seconds completly charted
and 20 seconds in fog-of-war until it is re-charted. This is with default trains a good compromise.

#### Movement tracker
Charts every vehicle (trains, cars, tank...).

If vehicle is driving: Every 1/2 seconds and tries to look forward. (This is with the default vehicles good enough, but there might be problems with very fast vehicles)

If it is waiting: Every 17.5 seconds (10 sconds visible, 7.5 in fog).

#### Rotation tracker

**THE ROTATION-TRACKER IS NOT READY YET (and might change name); you can research and build it, but the entity has currently no function!**
When ready it should scan a very wide range (2000 tiles?) in "circle-segments", like real radars. Only chunks with owned entities on it.
Takes some time for a rotation (a minute or two).

#### Research
You need to research the different radar-tracker-technologies before you can built and place the radars.
TODO: List needed items for research

#### Crafting
TODO: List of needed items to built

#### Energy Usage
TODO: (auto-generated) list of needed power

## Remote Calls
Use /c remote.call('RT', 'help') to see all commands.
TODO: Generate list

# Features:
- This is my first Factorio mod, I appreciate positive and negative critics.
- Fast initialization: Initial scan of a 20,000 tiles-map in under 10 seconds (vs. half an hour). 
- Tracks only first and last unit of a train instead of the whole train. (Imporovement is planned, see ideas)
- CPU-save: For 300 trains (600 entities) only 3-6 updates per second slower. (Well, still too slow)
- Debug-mode. Useful and interesting...
- Configuration file for energy-usages etc.

#Background
To be honest, the biggest reason why I did this was, that I needed something to see my trains on my 20km² map.
I had overseen, that Optera did a 0.13 fix, so I fixed it too for myself (cause I needed it for playing on my really big map).
I think I wouldn't have made it, if I had read the whole thread. But when I was on it I fixed here a bit and there a bit
and I had some more ideas (The second reason was learning more Lua programming and Factorio mods of course).
And suddenly it was as it was. Then I though: Would be a pity not to publish it. Forgive me, it's my first mod. :)

## Originating from Train-Tracker
This mod is is originated from **Train-Tracker** by MrDoomah.
https://forums.factorio.com/viewtopic.php?f=92&t=18368
It was updated to v0.13 by Optera (in the same thread) and me.

Meanwhile the only remainings are the graphics, prototypes and some lines of code about the prediction of train-direction.

#Version history
0.3.0 2016-10-31
- Stabilized, immoveables and movement tracker now works reliable.
- Debug-mode. I think the idea of the "debugger" is cool. It helped me a lot to find the bugs, to see, when an entity changed state.
- New (ugly!) graphics to distinct better between the two types.

0.2.0 2016-10-10
- Silently reworking completely. No release.

0.1.3 2016-09-30 
- Introduced tracker types. Types are: trains (locos or wagons), stops (all train stops), cars (cars, tanks, satellite-uplink...); currently still only trains works.
- Rewrote initialization. on a very large map (8 GiB) with >300 trains initialisation takes only 20 seconds vs. hours from before.
- Avoid double reinitialization.
- Re-increased scan rate cause I want to reduce average number of scans per train. Also looks much better.

0.1.2 2016-09-04
- Initial version

# Links
## Git Hub
https://github.com/alexaulbach/RadarTracker

## Factorio Forum
TODO

#Ideas/TODOs
- Add better description in research etc. into locale.
- Take tracker-code out of control.lua and decrease complexity (nesting).
- Tracker should not calculate entity-status (managers job).
- Debugger should calculate output-string itself for speed reasons.
- Remote function for adding/deleting entities to/from list. Own file.
- Track only front entity if train is running.
- Don't track back entity if no reverse loco.
- Look if _new chunk_ would be found and only then chart that chunk.
- Tracker can scan only vehicles in range (I think to 2500 tiles radius, which is quite big). Big change: This needs to introduce to bind entities to trackers.
- The more trains a tracker needs to scan then, the slower it will refresh. Or the more energy it takes?
- Rotational-Tracker: Add a new radar-functionality, which scans 360˚ in a minute, but only those chunks, that have entities built on ground. Range depends only on power it can get.
- Once-Tracker: Scans when entity is built/removed
- Random-Tracker: Randomly scan minerals by revealing a similar "virtual" surface. Good to search for far away minerals without revealing current map.
- A tool or so to add other immoveable entities to the immoveable-tracker.
- With more trackers: spread their scan-times so, that they do not chart all at once.
- Upgrade functio   n to convert (several) the train-tracker radars to to radar-tracker (good learning subproject).
- Scanner-robots. You can send them out and they will automatically reveal map.
- "Train Radar"  - some special type of locomotive/wagon. The train can be programmed to drive in circles to scan the area beside your rails in regular intervals, but needs excessive amounts of energy.
