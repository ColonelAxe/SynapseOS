# SynapseOS / ATLAS

ATLAS is the tactical application. SynapseOS owns the device shell, Home launcher, application registry, power and minimize/maximize workflow. They share one native display so the physical frame remains consistent.

The product has separate **Field User**, **Mission Setup**, and live **Command Element** workflows. Personal profile and layout choices never confer mission authority. See [the usability model](USABILITY-MODEL.md) for the full division.

## Player workflow

Default controls: U toggles the moving GPS (Main), Ctrl+U toggles the full device (Secondary), and Alt+U toggles carried equipment (Tertiary), preferring Tablet. Ctrl+Shift+Page Up/Down zoom; Ctrl+Shift+Home swaps GPS sides or resets the full-device position. All six bindings are configurable in CBA under SynapseOS. Aircraft Main/Secondary use the SynapseOS aviation layout; Tertiary returns to personal hardware. Minimize preserves app/report/channel drafts; power-off resets to Home. The legacy cycle function remains available for scripts, but its old key registration is replaced.

The Home taskbar follows Windows 10 placement: Start, app-list search, application view and pinned ATLAS/Settings/Camera icons on the left; status indicators and a separate time/date tray on the right. Search and application view open the registered-app list. These are SynapseOS controls; they do not open Windows on the player's computer.

The physical tablet/vehicle frame buttons work: menu returns Home (or toggles Start from Home), minus/plus open and zoom the tactical map, and power closes the device. Phone/portable top buttons open ATLAS and zoom the map; the bottom button returns Home, the left side button opens Messages, and the right side button powers off. Hover reveals each action. Hit areas use the outer hardware coordinates and remain aligned when changing device size or screen position.

The Notifications app is also available from Home's right-hand tray. It retains the latest 50 local updates for the mission, supports opening a conversation or record, marking all read and clearing history, and rejects revoked or expired record links. Home and other apps do not consume ATLAS unread messages. **My Settings** separates the Field User's profile, preferences, and role layouts; preferences cover voice, banners, three text sizes, vehicle trails and supplemental labels, plus restore defaults and RPT diagnostics. Mission policy and authority are configured by mission makers in Eden. Side changes clear the old session's records, grants, drafts, notice queue and local photo cache before re-entry.

The arsenal includes `ATLAS_Phone` (ATLAS Phone), `ATLAS_Tablet` (ATLAS Tablet), `ATLAS_MicroDAGR` and `ATLAS_HelmetCam`. These are SynapseOS-owned arsenal classes based on vanilla Arma `ItemGPS`; no third-party inventory class, model or icon is inherited. Carry phone and tablet to choose either through the shell selector or ACE Self Interaction → SynapseOS devices. Explicit selection opens the device and remembers the on-foot preference for future keybind openings. Missing preferred hardware falls back to an available device.

An enabled vehicle/aircraft seat defaults to the large mounted console using SynapseOS-owned class and seat rules. Rear passengers require their own device. ACE remains optional: client-side actions use its [interaction framework](https://ace3.acemod.org/wiki/framework/interactionmenu-framework), check carried hardware and ACE interaction eligibility, and register for soldier classes with inheritance. Actions include phone, tablet, MicroDAGR and supported mounted consoles. They open SynapseOS; select ATLAS from its launcher as usual.

SynapseOS uses its own equipment and vehicle eligibility rules for BFT. CBA supplies configurable keybind registration; no cTab class, function, asset or runtime global is required.

## Application contract

`[id, title, iconPath, launchCode, availabilityCode, badgeCode] call Synapse_fnc_registerApp` registers a local trusted application. The launch callback receives `[display, deviceMode]`. Availability returns a boolean; badge returns a number. The Windows-style desktop has a thin status bar, left-side shortcuts, Start menu and taskbar. Home displays eight apps per page. Supply a transparent central glyph: the shell supplies the cyan rounded square frame and label, including for new apps. Use dynamic control IDs ≥2000, preserve system controls 4/7/8, and keep app data separately from controls. The shell deletes app controls when returning Home. ATLAS, Settings and Camera are bundled apps.

Registration is not a mechanism for sending script text over the network. Each app remains responsible for server-side validation of its own remote data. ATLAS's existing channel, side, gear and command checks remain in force.

## Session state

ATLAS stores current tab/chat, selected unit/grid, map centre/zoom, composer text and priority/recipient, and suspended contact/channel form values in mission-local client memory. A side/identity check prevents restoring another side's session. This is not disk-backed persistence across mission restarts. Vehicle changes resolve a new device layout without expanding server permissions.

## Compatibility and source

The original `SICS_fnc_*`, PBO prefix and remote dispatcher names remain compatibility identifiers. New `ATLAS_fnc_*` aliases and `ATLAS_commander` are available. Keep the supplied remote-exec allowlist names even though the visible product is ATLAS.

The device key uses CBA's registered key combinations, including user rebinding, as documented in the [CBA getKeybind implementation](https://raw.githubusercontent.com/CBATeam/CBA_A3/master/addons/keybinding/fnc_getKeybind.sqf). It is handled on both the game display and native form displays, with held-key/transition guards to avoid double toggles.

Hardware artwork is original ATLAS-branded generated artwork. The custom wallpaper is user supplied, cropped for each device and restricted to the glass bounds. Code-native app icons follow the user's rounded cyan-border reference. Preview Camera photographs show fictional terrain, not the actual game; native photographs use the bundled extension described in MEDIA.md. Preview screenshots do not establish multiplayer or third-party vehicle compatibility.
