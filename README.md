shooter3D
=========
NOTES:

CHANGES:
-4/9/14 Wolfgang: 
  Howdy,
  Set up git repository, and committed all changes up to this point. Put any notes about the current version, 
  and a quick line about major changes here, as well as anything that needs done (below).

  -moves toward angle of rotation now. crosshairs also fixed to correct distance.

-4/21/14 Wolfgang
	posted all my OSC work to the Master. No textures, and lazers don’t work.
	Multiplayer on one computer:
	-open multiple instances of “PlayerAvatarFramework” and change the port, and 		prefix global variables for each
	-open one instance of PlayerAvatarBroadcaster
	-use shift->C to connect and shift->I to initialize an avatar
	-controls are near the bottom under the “Key-Pressed function.

TD:
-assure all object variables are adjusted to Terrain before they are accessed 
(within Map)
-limit Y movement on crosshairs
-closer crosshairs
-more and different objects
-fix Textures 
-explore limiting/obscuring visibility
