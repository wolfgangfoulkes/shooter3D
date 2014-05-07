shooter3D
=========
NOTES:

CONTROLS FOR KEYBOARD:
	-w,s - change move speed
	-spacebar - stop moving
	-click mouse - explosion
	-dragging mouse while clicking - move camera
	-q - axe
	-e -laser

CHANGES:
-4/16/2014 Nathan :
	-figured out that i was working on a different fork than you were,
	-i created a branch on the correct fork and uploaded all my code
	
-4/15/2014 Nathan: Huge Update...
	-updated textures for terrain
	-added some filler textures for droids
	-added filler textures for 'axes'
	-added textures for lasers (i think it looks cool
	-changed sphere background to move with player, doesn't slow things down much and it will look really cool with fog textures
	-created an early version of melee attacks, needs a little steaking
	-created a laser rendering system
	-droids turned into stationary rotating objects (cool for fire or other effects, adds something to hide behind
	-particle system is ready for testing when multiplayer exists, now it just explodes where player is 
	-I have also found anouther arduino to use - we have four now
	*i think its top priority to get 
	sidestepping implemented into the game, if you can do that i would be stoked
	*still need two more MACs
	*lots of these changes should be ported out into classes and streamlined in other ways
	*the program runs really slowly at moment, i will make it faster
	
-4/13/14 Nathan:

	-Minor tweaks in processing
	-larger map size
	-shorter draw distance
	-commented out sky
-4/12/14 first update Nathan:
	PROCESSING:
	-created an alternate version using shapes3D library
		- has randomized sky and ground textures
		- ground is no longer flat, instead it is randomized using constrained noise
		- working crosshair is now implimented
		- object generation and rendering has been streamlined
		- added several arrays of textures for buildings/ground and sky
		- two different building shapes are generated at random with map generation
		- ground and sky textures periodically change
		- added some stuff using millis() to avoid perceived frame rate drops
		- the map now loops around, it behaves in a spherical way
		- started on remapping OSC data in meaningful way
		
		-This version is missing some features that we would have to rewrite using the new library 
			(i think we should, it wont take much time and will vastly improve the final product)
			-player can no longer sidestep
			-have to recode all the camera "looking" stuff
			-various other things, about 1/3 would have to be re-coded
			

-4/10/14 Nathan:
	-added the chuck and arduino code, 
	-i will also try to remember to bring you an arduino and nunchuck tomorrow
	-i also simply dumped my unstable expirimental version in a different folder, but its in a chaotic state at the moment,
		sat i will sort through it and combine it with the main version.
	

-4/9/14 Wolfgang: 
  Howdy,
  Set up git repository, and committed all changes up to this point. Put any notes about the current version, 
  and a quick line about major changes here, as well as anything that needs done (below).

  -moves toward angle of rotation now. crosshairs also fixed to correct distance.

TD:
-change Object3D to instantiate objects by-vertex, perhaps assigning shape somewhat randomly. 
//could you try this one? I'm on respawn and lazers right now. Also, would you mind putting our list of who-does-what here? thanks a bunch, Wolfgang.
- i'll look into it, but not untill sat

This is what i have for the TD that i turned in for the assignment.

Wolfgang -
-find laptop
-find arduino
-respawning - communication(3)
- destruction mechanisms(3)
-laser system working(3)
- crosshair(3-4)
-flashlight object things(3)
-Music/sound design (4)
-Trouble Shooting(4)
-Aesthetics(4)
-look into lighting libraries

Nathan-  
-find laptop
-respawn message and death messages in chuck-
-axe rendering(3-4) -ugly early version works-
-look into fog(3) - perhaps as background
-scream to respawn (testing) (4)
-droids - as random shape?
- destruction mechanisms(3) -what aspects really?
-Music/sound design (4)
-build 4X enclosures (4)
-Trouble Shooting(4)
-Aesthetics(4)
-look into lighting libraries
