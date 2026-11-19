# ATLAS TOC displays in Eden

## TOC Setup

1. Place a laptop or PC and set its Eden **Variable Name** to `Master`.
2. Place up to four retexturable displays and name them, for example `Screen1`, `screen2`, and `Screen3`.
3. Place **TOC Setup** under **SynapseOS / Command Element Setup**. Enter the master variable, select the side, and enter each screen variable in its own slot. Leave unused slots blank. Use the common **Screen texture selection** for the chosen display models (normally `0`). Use a separate module and distinct objects for another room.
4. Choose a startup view for each assigned screen. The defaults are **ATLAS briefing map** for Screen 1, **ISR video** for Screen 2, and **Standby** for Screens 3 and 4. ISR waits for an operator to choose a source. Setup issues identify the field in the server RPT and in single-player preview chat.
5. Preview the mission. Within five metres of the laptop, open **ATLAS / TOC Displays** with the scroll action or use **TOC Displays** in the workstation's ATLAS TOC tab. Use **Map**, **Standby**, or choose an ISR source and press **Set** in the corresponding row. Enable Picture in Picture on viewers for ISR.
6. To populate the map, open SynapseOS from the master. In **Operations → Plans**, select a published side-shared overlay or objective and press **Brief screen**. The lowest-numbered available Map slot receives the briefing. Map, ISR, and Standby preserve the screen's last published briefing so it can reappear when the screen returns to Map.

### In-game acceptance

- Start with two assigned screens and two blank slots. Verify one Map row and one ISR row. Choose a friendly camera in Screen 2 and confirm that Screen 1 stays on the map.
- Add a third screen in Standby and enter a nonexistent object name in Screen 4. Verify the three valid rows still work and the RPT identifies Screen 4. Repeat with a duplicate name.
- From the master workstation, brief a published overlay on Screen 1. Switch Screen 1 through Standby and back to Map, and verify that it restores the briefing while Screen 2 stays on its feed.
- With two same-side clients and an opposing-side client, check that screen changes replicate, a late joiner sees the current modes, and only nearby same-side players can control the master. Destroy or remove a selected source and verify the screen releases the camera and shows an awaiting-source status in the console.

## TOC / Synced Displays

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

## Live monitor map control

Map mode works without a published Operations plan and displays current permitted friendly tracks. From the master console select Map for a screen; or stand within five metres of a configured monitor and use SynapseOS / Control monitor map. Drag to pan and use the wheel or Zoom +/- buttons. My position recentres the view. Live sync is on by default and sends viewport changes twice per second; turn it off to preview locally, then use Share view. The last shared view is retained when closing the controller, switching display modes, and for late joiners. Each monitor has its own viewport. A newly published briefing resets it to the briefing focus.

Maps use 2048x2048 UI textures with a SynapseOS header, cyan border and grid/clock footer. Actual sharpness depends on the screen model's UVs, viewing distance and game texture settings. Live friendly tracking remains subject to equipment and mission tracking policy. Map control is limited to same-side users near the monitor or its master. Source switching remains controlled from the master.

Acceptance: test drag/wheel and Zoom buttons, two independent monitors, a second viewer and late joining; test control denial from an opposing side or outside interaction range. Confirm map tracking updates while the controller is closed and that ISR/Standby restores the saved map when returning to Map.

## Vehicle U overlay / aircraft TAD

The mounted U moving-map overlay now uses a square MFD-style bezel. It follows interpolated visual ownship position every render frame instead of recentering twice per second; telemetry refreshes five times per second. Dismounted U retains the phone frame. Aircraft show three labelled adaptive range rings (metres/kilometres), heading ticks and an ownship heading vector. Existing CBA zoom and interface-position bindings remain available. The overlay is noninteractive so cockpit controls remain available; bezel keys are visual styling. North-up orientation is preserved.

Validation for this update: all 30 backend cases passed, including five new tests for shared map state, independent screens, invalid-coordinate rejection, range denial and control at a monitor. Client drag/zoom, 2K UI textures, overlay rendering, frame rate and late joining require owner testing.
