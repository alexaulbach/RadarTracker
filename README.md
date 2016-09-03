# RadarTracker

This is a Factorio mod. It adds a new radar called "train-tracker".
The train-tracker maps 

You need to research radar-tracker technology.
Place a train-tracker anywhere and the trains scans the area around them.

This mod is is formerly known as Rail-Tracker by MrDoomah.
https://forums.factorio.com/viewtopic.php?f=92&t=18368
It was updated to v0.13 by Optera (in the same thread).

My main reason to make a own mod out of it was to learn more Lua programming and Factoeio mods of course.


Changes to the original train-tracker:

- Technology can be researched now after electric-energy-distribution-1
- config.lua enables to control the parameters of the entity
- default config now scans only every **2 seconds** (vs. 1 second)- performance reasons and I think it should not work absolutely perfect.
- it scans now a larger area around the train (10 vs. 5 tiles)

Additionally I wanted to implement a way to track also other vehicles than trains. Therefore you can place the vehicular tracker.
**But this feature isn't working yet!!** (hey, we have v0.1!)

Version history

0.1.0 2016-09-04 Initial version


Ideas

- make an upgrade function to convert train-tracker to to radar-tracker
- a simple list of vehicles, a bit of The Fat Controller for cars/tanks
- some kind of remote control or autorouting of cars/tanks (route back to supply)
