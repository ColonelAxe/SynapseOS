# Arma acceptance checklist — partially executed

v0.4 local tests passed for native chat cards/scrolling controls, toolbar visibility, immediate marker-menu opening, grid selection without a dialog and native polyline round trip. In multiplayer, additionally test channel filtering, broadcast inclusion, marker/line visibility on both friendly clients and exclusion from opposing clients, and creator/commander deletion permissions.

Local single-player checks passed for display construction, five detail tabs, messaging, orders, acknowledgement, reporting and callsign changes. See `VALIDATION.md` for evidence. The broader checklist below remains the release acceptance plan.

v0.2.1 local checks also passed for the tablet frame/aspect ratio, marker editor population, native marker creation, editing and deletion. Still test two-client side isolation, reconnect synchronisation, marker ownership permissions and mission restart behaviour.

## Environment

Arma 3 2.18+, CBA_A3 and SynapseOS only for the baseline run. Do not load cTab. Run a hosted session, then a dedicated server with two friendly groups and a second-side player. Repeat with TFAR only, ACRE2 only, and neither. Check RPTs after each test. Do not load both radio mods for a normal acceptance run.

## SynapseOS and device lifecycle

- In vanilla and ACE arsenals, take ATLAS Phone (`ATLAS_Phone`) and ATLAS Tablet (`ATLAS_Tablet`) individually, then together. Phone alone must offer only Phone; Tablet alone only Tablet; both allow switching. Verify assigned and stored inventory items, transfer, dropping, and capacity.
- With ACE loaded, Self Interaction → SynapseOS devices must show only carried devices or supported mounted consoles. Open each action, verify matching layout and remembered on-foot preference, then repeat after respawn and changing soldier class. Check conscious/restrained eligibility. Repeat without ACE: addon must still load and the device key/selector must work.
- Test all six CBA bindings: Main (U), Secondary (Ctrl+U), Tertiary (Alt+U), zoom in/out (Ctrl+Shift+Page Up/Down), and interface position (Ctrl+Shift+Home). Verify walking, driving and flying with the Main GPS visible.
- Rebind each key and its modifiers in CBA; verify press/release in the root display and contact/channel forms.
- Click the physical frame buttons on each device. Test Home/Start, both map zoom directions, power, and phone ATLAS/Messages shortcuts. Check alignment at different resolutions and UI scales.
- Open Home from each app; check the Windows-style taskbar, separate clock/date lines, pinned apps and Start list. Wallpaper and header must stay inside the glass.
- On foot, verify the landscape handset, optional rugged tablet and compact portable selector. In enabled driver/pilot seats verify the large ground/aviation console; rear cargo needs personal equipment.
- Open ATLAS from its launcher icon. Home, minimize and resume must retain the selected unit, map view, chat and unsent message/contact/channel drafts. Cancel must discard the cancelled form.
- Register a separate trusted test app, launch it and return Home; its controls must be removed and ATLAS must retain its session.
- Power off, lose the device, exit a mounted seat, die, respawn, reconnect and change side. Verify access checks and no stale privileged channel data or duplicate handlers.

## UI and tracking

- Ctrl+U toggles the full device with supported equipment and refuses without access; U toggles the moving GPS independently.
- All six tabs remain usable at 16:9 and 21:9 and small/normal/large UI scales.
- Map pan, zoom, roster centring, NATO BFT symbols and SynapseOS markers work.
- A moving equipped group updates on SynapseOS's sampling pulse; unequipped groups are not spuriously revealed.
- Changing callsign as leader updates global group ID and BFT labels. A nonleader request is refused.
- Close/reopen repeatedly; ensure there are no duplicate CBA handlers or leaking camera objects.

## Communications

- Side-wide message reaches same-side peers and no opposing player.
- Group-targeted message reaches the selected group and original sender, excluding other groups.
- Order from a leader or mission-assigned commander is accepted; nonleader order is refused.
- Target group acknowledges an order; issuer receives the updated group acknowledgement. Unrelated group cannot acknowledge a targeted order.
- Report retains the double-clicked map position, priority, sender and text.
- Invalid identity, out-of-side recipient, malformed position and >1,000-character text are rejected by the server.
- A sender is rate limited to one request per second without breaking ordinary use.
- Join in progress and open SICS: only authorised retained records appear. Reconnect and respawn preserve correct access. Restarting the mission clears history.
- Hosted-server player can both send and receive.
- Changing side closes an existing display and does not reveal previous-side records.

## ISR

- Alive friendly UAVs appear; enemy UAVs are excluded.
- Selecting an authorised UAV or helmet camera shows the SynapseOS camera feed.
- Missing camera points produce fallback text; turning off PiP behaves understandably.
- Native terminal linking needs a compatible assigned terminal, respects UAV access and existing role occupancy.
- Test Pilot and Turret/weapons separately, release control, and verify occupied roles cannot be stolen from another player. Fire only in a controlled test mission.
- Switching pages or closing removes the camera opened by the SynapseOS session.

## Camera and report photographs

- Capture a real scene with the bundled Windows x64 extension and Arma 3 2.22+. Select the photograph, attach it to a report, and verify caption, position and report association.
- With two authorised clients, open the received report photo on the second client. Repeat with a JIP client; verify opposing players and revoked channel members cannot download it.
- Verify ordinary messages, orders, acknowledgements and reports still work without any photo attachment. Reject another operator's photo, invalid IDs, malformed chunks and unauthorised downloads.
- Test missing extension, unavailable PiP, full upload queue and retry. Leaving Camera must remove its camera and handlers.
- Test the extension under the server's normal BattlEye policy before distribution; the development DLL is unsigned.

## TOC

- Register an Eden laptop using the example; verify action for all clients and JIP.
- Authorised side can open within 5 m without carrying a device; wrong side cannot.
- Walking outside 5 m closes the workstation without a personal device and causes server submissions to fail.
- Multiple objects in the room each provide one action, including after repeated registration calls.
- Destroying a terminal removes access for users without their own device, including server-side transmission checks.

## Known scope boundaries

For custom chat multiplayer acceptance, use at least three clients and a dedicated server. Grant one player by UID and another by group, leave a third without access, then confirm only members can list/read/send/receive history and notifications. Remove each grant, test a group change, and reconnect/respawn the individually granted player. Check owner access, manager editing, non-manager edit rejection and non-commander creation rejection. Add a newly connected player, retain an offline grant, and confirm changing sides removes access. Verify membership updates purge the revoked client's cached conversation within two seconds without replay notifications. Test the same on a hosted server. Local policy checks do not prove dedicated-server transport correctness.

Test channel deletion by owner and manager, reject a nonmember's delete request, verify the confirmation names the channel, and confirm server and client histories disappear. All former members should get channel-deletion feedback. For message/report/order/ack/channel/information events, verify both a banner and the matching spoken cue with the tablet open and closed. Send a short burst and confirm voices queue without overlapping. Check the receiver's actual sound volume and output device; RPT playback requests alone do not establish audibility on every machine. History replay and duplicate packets must remain quiet.

For the position-report modal, choose Reports > Mark contact on map and click a position. Verify every field is visible above the dimmed background, dropdowns can expand, and Cancel returns to the tablet. Submit a designation and strength; confirm the report record and native map label retain both. Reject blank designation, zero, fractional, negative and nonnumeric strength. Repeat at the intended game resolution and UI scale. The form uses child display 87001, with its backdrop in controlsBackground.

For v0.5 multiplayer acceptance, send a contact report from a second client and verify its chosen NATO symbol, affiliation colour, element category and observation grid on both tablet and standard Arma map. Test all five affiliations and any installed marker packs. Confirm opposing sides cannot see the report.

With the receiving tablet closed, verify alerts for a new message, report, order and acknowledgement; then open the relevant page to clear its unread count. Reconnect and verify replay creates no new alerts. Check targeted transmissions do not notify unrelated groups.

Click a friendly symbol in Grid selector mode, pan away and press Centre selected. Repeat with a moving ground vehicle, helicopter and plane, and use My position independently. Confirm selection survives roster refresh and that stationary reported enemy contacts do not follow actual enemy movements.

Radio support reports possession only. Messages are side-partitioned independently of cTab encryption keys. No disk-backed persistence, background TOC wall-map rendering, custom 3D tablet/building, automatic AI waypoint tasking, RF propagation or full APP-6 symbol catalogue is implemented. Browser preview features such as layer controls and TOC script export are design-preview tools, not claims about native controls.
