# Camera, drone controls and report photographs

Camera is a separate SynapseOS app. Frame the scene by looking at it before opening the device, open Camera, enter a caption and press **Snap picture**. The live camera stays at the operator's eyes; it is not a free camera. Select a captured picture and choose **Attach to report** once its upload completes. Send the report from ATLAS. Select the report in Tactical's operations feed and choose **View report photo** to request its image.

Photographs require Windows x64 clients, Arma 3 2.22 or newer, PiP enabled, and the bundled `atlas_media_x64.dll` beside `mod.cpp`. The server relays image chunks in SQF and does not load the Windows extension, allowing a Linux dedicated server. Actual dedicated-server interoperability remains an acceptance test.

## Image data

Capture first requests the named Arma render-to-texture camera. If that build does not expose the target, the app uses Arma's own 3D-scene screenshot command with the eye-level camera, then imports only the generated `Screenshots/ATLAS/P_*.png` from the game's profile locations. The extension does not capture the Windows desktop, accept arbitrary file paths, open sockets or upload to an external service. It compresses a still to a 512×256 JPEG, at most 64 KiB. Arma 2.22's extension texture source renders received images from a bounded in-memory cache. No absolute filesystem texture paths are passed to recipients.

Capture upload is limited to 48 chunks of 2048 base64 characters, one new upload per operator every three seconds, a 30-second upload deadline, and 128 server images. The server validates sender identity through ATLAS's existing dispatcher, enforces owner/side association, and accepts at most one owned, completed image per report. Each download checks access to the actual report, its photo reference, side and channel/group audience. Access is checked again while transmitting. Images are not broadcast automatically to the whole mission.

The gallery and report attachments are mission-session data. Screenshot-fallback originals remain in the photographer's `Screenshots/ATLAS` folder under Arma's normal screenshot quota. HDR/profile settings can limit the engine screenshot command. The native cache holds at most 64 photos and eight inbound transfers. Unattached old server images expire when new images are uploaded. Recipients who have already received an image cannot have that knowledge remotely erased. The UI hides received gallery entries when their report/channel is no longer available.

The bundled DLL is unsigned. Servers using BattlEye must arrange normal extension approval/distribution before multiplayer deployment; do not disable BattlEye to deploy it. Capture failure is reported in the Camera app rather than substituting an empty or live image as a photograph.

The beta build cancels pending captures when leaving Camera or revoking the session, uses the shutter-time position and heading, validates declared transfer lengths, permits rate-limited retries of an incomplete upload and releases expired upload slots on retry. Revoked private-channel downloads are removed from the local gallery/cache; a late transfer cannot recreate a photograph without a currently accessible report reference. PBO signing and native-extension approval are separate mechanisms.

## Build and verification

Run `tools/bootstrap-native.ps1` to download a pinned official Zig 0.15.2 compiler and verify its published SHA-256. Run `tools/build-native.ps1`, then `native/test-media.ps1`. The compiler cache is excluded from source/release archives. The native source is `native/atlas_media.cpp` and exports the documented Arma extension interfaces. Codec tests cover valid JPEG reconstruction, invalid identifiers, transfer bounds, incomplete files and texture buffer guards.

Camera uses the [Bohemia extension texture and R2T interfaces](https://community.bistudio.com/wiki/Extensions). Native image input is restricted to named engine targets, generated ATLAS snapshot files in Arma profile screenshot folders, and validated JPEG chunks received through SQF.

## Drone operation

ISR lists same-side active UAVs and operators with the ATLAS helmet camera. **Pilot** requests the native UAV driver role. **Turret / weapons** requests its native gunner role, with the vehicle's fitted sensors/weapons. **UAV terminal** opens the standard terminal. Carry a compatible terminal; friendly access and occupied-role restrictions remain engine controlled. ATLAS does not force `remoteControl`, transfer vehicle locality or replace the engine's weapon controls. Release control using the native UAV controls.

Aircraft Main/Secondary controls use the existing dependency's TAD renderer. Personal ATLAS equipment remains accessible through Tertiary. See SYNAPSEOS.md for device and keybinding details.
