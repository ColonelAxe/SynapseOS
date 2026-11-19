# ATLAS TOC screens: ACE feed selection

1. In Eden place TOC / Synced Displays (SynapseOS / Command Element Setup).
2. F5-sync one or more retexturable screens/laptops to it. A source is optional.
3. Set your side and correct screen texture selection. Use separate modules for independent screens, or one module to switch several screens together.
4. Enable Picture in Picture in Arma video settings.
5. In mission, ACE-interact with the screen within 5 metres: ATLAS TOC Video Feed. Select UAV / ... or HELMET / ... . The list is rebuilt when opening the menu, including newly spawned units.
6. For helmet feeds, give the friendly unit ATLAS_HelmetCam in inventory or assigned equipment. AI and players are supported. UAVs must be friendly, alive and crewed.
7. Stop feed / restore display stops the camera for the entire synced group and restores the original screen texture (or briefing view).

Without ACE, scroll actions offer next source and stop. ACE remains optional.
Sources and mission sensor permissions are checked by the server. Selection is shared for all screens in a module; late joiners receive the latest choice. Cameras release when the source is lost, the viewer changes side, the display is destroyed or the viewer moves beyond 100m. Up to eight screen render targets are active per client; other ATLAS PiP views may further constrain engine PiP capacity. UAV view is an exterior camera; helmet view follows eye position and direction.

This is an independent implementation using the official ACE interaction framework: https://ace3.acemod.org/wiki/framework/interactionmenu-framework . The mod providing the unrelated TOC Video Feed label has not been identified.

Validation: HEMTT compile/config build and signature verification. Actual ACE menu rendering, PiP, JIP and multiplayer switching require owner testing.
