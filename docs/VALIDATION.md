# Validation record

## cTab-free source migration — 18 November 2026

HEMTT built the current `dev` addon: 1 PBO, addon config rapified and 102 SQF files compiled. A byte-string scan of the built production PBO found no cTab names or item-class aliases. This establishes a clean source/PBO dependency surface, not a successful Arma runtime test. The no-cTab game launch did not start: the launcher remained on its existing 67-mod profile and direct execution exited before opening a game window. No launcher preset was changed. Continue with a clean Arma + CBA launch and functional smoke run before treating the build as beta-ready.

Earlier sections below document legacy beta builds; they are not evidence for the current build.

## v0.11.0-beta.1 / closed-beta checkup — 15 November 2026

The completed developmental beta run ended at 16:49:03 in `arma3_x64_2026-11-15_16-46-31.rpt`: 358 checks passed, none failed (199 core, 26 beta/lifecycle, 8 media, 4 drone, 121 UI/layout). No SQF expression or missing-texture errors were logged. It covered notification history, unread behavior on Home, opening updates, revoked/expired links, preference validation, capture cancellation, malformed photo length rejection and clearing session caches. After that run, the audit added a guard against re-saving a revoked draft on display unload, actual side-change tests and a second UI sweep at large text. Those strengthened native checks require a follow-up run; do not treat the developmental baseline as proof of them.

The latest main build compiled 78 SQF functions. Browser regression passed every ATLAS tab plus Home, Settings, Camera and Notifications across four device variants and 1600/900/600/390-pixel widths, including large-text preferences, centre selection/open/clear, taskbar fit and hardware actions. The reviewed screenshots in `atlas-beta-notifications.png` and `atlas-beta-preferences.png` are design previews.

Dedicated Windows server startup with CBA and original cTab successfully loaded `ATLAS_Beta.VR` and logged `ATLAS_BETA_MISSION server ready / five side-isolation slots` at 16:56:15 in `arma3server_x64_2026-11-15_16-56-07.rpt`. The corrected mission produced no SQF expression errors. An earlier engine startup warning referenced `a3_characters_f`, and the dependency stack logged `bis_fnc_storeparamsvalues_data` as a final-function override. Mission initialization completed despite those warnings. This was a startup check without connected players; cross-client delivery, JIP and signature-enforced client joining remain beta acceptance work. Windows presented a firewall permission prompt; no permission was changed and the temporary server was closed.

The current PBO passed Bohemia DSCheckSignatures and an independent HEMTT signature/hash verification using `ATLAS_Beta_011.bikey` (v3 signature). Runtime/source archives were checked for required contents and absence of private signing keys, compiler cache and test logs. PBO signing does not approve the native DLL for BattlEye.

Use BETA-TESTING.md and CHECKUP.md for the install path, five-slot mission, fixed findings and remaining acceptance boundaries. This is a closed-beta candidate, not a public-server certification.

## v0.10.0 UI audit, desktop and media — 15 November 2026

The final local Arma 3 2.22 run completed at 16:27:57 in `arma3_x64_2026-11-15_16-25-53.rpt`: 320 checks passed, none failed (199 core regression, 8 Camera/media, 4 drone controls, 109 UI/layout checks). No SQF expression errors or missing-texture errors were logged. HEMTT compiled 73 SQF functions successfully; existing style/performance lint suggestions remain.

The UI sweep covered Tablet, Phone, Portable, Vehicle, Aviation and TOC Workstation; Home, Settings, Camera, every ATLAS tab, handset panes, order composer, attached-photo reports, inspector and contact/channel/marker forms. Geometry checks exclude intentional layers such as icon plates, badges, panels and hardware hit areas. They check control intersections and bounds; they do not prove every possible text length or UI scale renders perfectly. Manual inspection at the local 1024×800 window caught and corrected literal newline rendering in scrolling C2 details and the taskbar clock/date. Tablet menu and zoom buttons were also clicked in-game successfully. The final scripted run passed frame Home/Start, map and power actions and clean details newlines.

Changes include a proportionally square ATLAS header icon, shared app-header geometry, phone header inside the glass, a footer clear of the bezel, scrollable long record/team details, attachment visibility fixes, preserved explanatory tooltips, and a Windows-style taskbar with pinned apps and separate clock/date controls. Physical hardware buttons use the outer frame coordinates. The original cTab aircraft TAD passed overlay/interactive/personal-device transitions.

Camera tests captured an actual VR scene through the bundled DLL (using the Arma screenshot fallback), uploaded the JPEG, attached it to a report, dropped the local native cache and downloaded/reconstructed it from the mission server. The extension texture rendered successfully. Native UAV tests acquired DRIVER and GUNNER roles on an armed drone and confirmed its weapon classes; no weapon was fired. Helmet and UAV live cameras and cleanup passed. The broader regression caught and fixed photo validation rejecting empty photo lists; ordinary messages, orders, acknowledgements, contact reports and reports all passed again.

Browser checks passed all six ATLAS tabs plus Home/Settings/Camera across four device variants at 1600, 900, 600 and 390 pixels, including taskbar fit, frame-button actions and zero uncaught browser exceptions. `docs/atlas-desktop-taskbar.png` is a design-preview capture, not an in-game screenshot.

This remains one local player with AI and policy fixtures. Dedicated multiplayer/JIP, competing UAV operators, physical key rebinding/walking acceptance, alternate native UI scales/aspect ratios, TFAR/ACRE sessions and normal BattlEye approval of the unsigned development extension remain release acceptance work. The geometry audit harness is test-only and is included in the source archive, not the playable mod.

## v0.8.1 inventory devices and ACE selection — 14 November 2026

Final local Arma run with original cTab, CBA and installed ACE completed at 18:54:27 in `arma3_x64_2026-11-14_18-52-40.rpt`: 165 assertions passed, none failed, with no SQF expression errors or final-function override warnings. HEMTT compiled 51 SQF files. Tests passed distinct tablet/phone inventory classes, matching layout eligibility, cTab BFT gear recognition, access, carrying both, explicit selection, preserved message draft, remembered preference, fallback after losing the selected item and refusing unavailable devices.

ACE checks inspected its registered inherited soldier actions and executed the actual tablet action condition/callback: action exists, hidden without tablet, visible when carried, and opens the tablet. The full prior regression also passed with ACE loaded, including mounted vehicle/aircraft access, fresh on-foot handset default and OS session restoration. This checks registered action behavior; it is not a manual visual inspection of ACE's radial menu, an arsenal screenshot check, or multiplayer/respawn acceptance.

cTab's equipment function is final at runtime. Compatibility is configured before compilation through its `CfgFunctions` path, calling the original dependency's checker with the two additional ATLAS class mappings. No dependency files are edited. Inventory models and icons are inherited from cTab; these are separate arsenal classes, not new 3D models.

## v0.8.0 ATLAS / SynapseOS — 14 November 2026

The final local Arma regression completed at 17:35:11 in `arma3_x64_2026-11-14_17-33-43.rpt`: 146 assertions passed, none failed, with no SQF expression errors. HEMTT compiled 48 functions. Browser checks passed without exceptions, including the launcher, separate app registration, saved composer, channel deletion and responsive device layouts.

Native checks covered the GPS/full-device state cycle, launcher branding and ATLAS launch, selected-unit/map/message restoration, suspending and restoring contact drafts, third-party app controls and cleanup, Home preserving ATLAS drafts, and power-off. A report-resume regression exposed Arma retaining a parent display while a child form was attached; minimize/power now explicitly close child forms before the root. The final run passed that regression. Existing reports, NATO catalogues, notifications, channels, messages, orders, inspector and centring checks also passed.

Native device checks passed physical aspect ratios/assets for tablet, landscape phone and portable, on-foot default phone, ground driver and helicopter pilot consoles without carried equipment, rear-cargo access denial, and closing the mounted device on vehicle exit. Manual UI inspection confirmed the realistic ATLAS frames, SynapseOS launcher and minimize button opening the noninteractive GPS. Synthetic keyboard input did not establish physical Ctrl+U operation or sustained walking; physical key rebinding and movement acceptance remain on the checklist. State-cycle assertions invoked the native functions directly.

This was one local player with AI and permission fixtures. Dedicated multiplayer/JIP, respawn/reconnect, TFAR/ACRE sessions, live UAV feeds and third-party vehicle classes remain unverified. Artwork is original generated hardware with a temporary ATLAS app icon, pending final logo artwork.

## v0.6.0 controlled chat channels — 12 November 2026

The final expanded native run completed at 21:31:51 with no failed checks or SQF expression/sound-loading errors. It additionally passed channel-sidebar selection, denying nonmanager deletion, deleting the channel registry entry and server/client history, and removing the channel from the client's list. All seven event kinds (message, report, contact, order, acknowledgement, channel and information) returned a visual notification and queued the matching voice class; the packed WAV resources existed in-game. The test exercises Arma playback requests, not an independent measurement of speaker output. Browser tests passed two-step deletion confirmation and history removal, plus incoming voice-cue selection. Spoken clips are bundled PCM WAV files and queued locally to prevent overlap.

HEMTT compiled 36 SQF functions. Local native channel checks passed at 21:21:53: create button/editor, server create round trip, owner management, group grants, nonmember denial, message round trip, history filtering, per-channel unread/read clearing, membership editor, group revocation, individual grants, ordinary-member management denial, manager role, cross-side denial, nonmanager update denial, noncommander creation denial and forged nonmember send rejection. Existing report/modal, notification, live tracking, inspector and centring checks passed. Manual UI inspection confirmed the three membership lists and type dropdown render correctly; changing the type to Ground to Air, selecting ALPHA and saving updated the server-backed channel context.

Browser tests passed creation of a Ground-to-Air channel, group access/nonmember denial, sending in that channel, removing a grant, assigning a manager and keeping private history out of ordinary chats. Browser rosters are fictional design data. Native tests used one local player plus policy fixtures and AI groups; they do not establish multiplayer transport, respawn/reconnect or dedicated-server correctness. See IN-GAME-TESTS.md for the required multi-client acceptance pass.

## v0.5.2 structured reports and modal layering — 12 November 2026

Reproduced the opaque report background obscuring its fields. The report editor now uses child display 87001 with shade/panel in controlsBackground and foreground input controls. Control positions are committed before text layout, and labels fit the form. The unknown-symbol default matches the exact affiliation symbol instead of a respawn marker with a similar name.

The final native regression completed at 21:01:35 with no failed checks or SQF expression errors. Passed structured designation and strength storage, zero-strength rejection keeping the form open, automatic armour symbol selection, native type/colour/grid and designation/count label, notifications, unit inspector and centring. The final form was then opened manually through Reports > Mark contact on map. Fields and dropdowns were visible above the dimmed backdrop. Selecting UNKNOWN and Infantry updated the yellow NATO preview; clicking Send returned to the tablet, displayed server acceptance and created `CONTACT / UNKNOWN / Infantry x1` at the clicked grid. These are local single-player tests, not multiplayer acceptance.

## v0.5.1 unit inspector — 12 November 2026

Native local Arma run completed at 17:31:27 with no failed checks or SQF expression errors. Passed inspector panel creation, clicked vehicle selection, all summary fields, actual team membership and ranks, live rank changes, engine COMBAT state, restoring the prior panel when leaving Inspect mode, and subsequent selected-unit centring. Existing reporting, notification, vehicle tracking and map-tool checks passed again. Visual inspection confirmed switching from a vehicle to a friendly infantry symbol updates the unit name, person's name, grid, status, combat state and ranked roster. Combat reflects engine behaviour rather than inferred player intent.

Browser checks passed clicked-unit selection and the illustrative inspector roster. Final packaging compiles 29 SQF functions; compact toolbar labels and tooltips fit the extra tool. Multiplayer acceptance remains outstanding as documented below.

## v0.5 contact reports, notifications and movement — 12 November 2026

HEMTT built the native PBO and compiled all 28 SQF files. Browser checks passed contact creation, incoming-alert deduplication and own-message suppression, selected-unit centring after panning, and the existing chat/map workflows.

Local Arma 3 VR smoke run completed at 17:23:18. Passed the installed NATO catalogue for all five affiliations (46 symbols per family in this installation), contact editor, contact report round trip, native symbol/type/colour/position, incoming notification template, unread badge, duplicate suppression, own-event suppression and read clearing. Ground, rotary-wing and fixed-wing tracking passed; the ground vehicle moved during sampling. After panning away, selected-vehicle centring returned within 2.3 metres of the moving vehicle. Existing chat, orders, acknowledgement, reporting, callsign, map toolbar, markers and lines passed again.

The final regression completed at 17:24:41 with no failed checks or SQF expression errors. It additionally selected the friendly vehicle by clicking its projected map symbol, panned away, and re-centred within 2.4 metres of its current moving position.

The incoming event was injected locally in single player to exercise the receiving UI. This does not verify delivery between two clients. Multiplayer audience isolation, JIP, actual remote notifications and modded symbol packs remain acceptance tests. Unknown and civilian use Arma's neutral symbol frames with explicit affiliation colours; the catalogue is not a full standalone APP-6 library.

## v0.4 native chat and map tools — 12 November 2026

Local Arma 3 VR run completed at 16:55:52 with no SQF expression errors. Passed: all tabs and map controls, message round trip, native chat scroll group and message-card controls, order composer, order transmission and acknowledgement, reporting, callsign changes, tablet frame/aspect, marker editor/create/edit/delete, map-toolbar controls, immediate toolbar-to-marker-menu opening, grid selection without a marker dialog, line round trip through the validated server dispatcher, and native POLYLINE marker creation. The sidebar map toolbar was visually inspected in Arma. Two-client side sharing, sender ownership and reconnect replay remain multiplayer acceptance items.

Browser checks also passed for immediate marker-menu opening from the toolbar, armed click placement, marker editing/deletion, two-point line drawing, grid-only selection, existing chat/send workflows and responsive layouts. Browser state is local simulation; it does not establish multiplayer delivery.

## v0.2.1 native tablet / markers — 12 November 2026

Live single-player Arma 3 VR test with CBA and original cTab confirmed the rounded frame, 16:10 physical aspect ratio, all application tabs and map controls, order-composer visibility, message/order/report round trips, acknowledgement and callsign change. Marker checks passed for editor symbol population, creation, native `markerType` registration, editing type/colour, and deletion. The test log completed at 16:01:09 local time with no SQF expression errors. The visual pass identified undersized text; font heights were subsequently changed to scale with the tablet viewport.

Marker sharing remains unverified in multiplayer. Local preview tests cover marker creation, colour editing and deletion. Markers have not been tested with every third-party marker pack.

## v0.2 UI redesign

HEMTT builds the native reference-led tablet interface, including the new layout and selected-element details functions. Browser checks cover the redesigned Tactical, C2 and Messages layouts, existing workflows, and page overflow at 1280 / 900 / 600 / 390 px. The C2 and Messages screenshot artifacts are captured from the actual preview DOM and canvas. A fresh in-game check of the v0.2 layout has not been performed; the successful runtime results below are from v0.1.

## Executed

- HEMTT 1.22.0: `hemtt check` — config rapified and 13 SQF files compiled, no code warnings in the last check.
- HEMTT: `hemtt build --no-bin` — script-only addon PBO produced. Config is rapified; no models or textures require binarisation.
- Node.js 24: `node --check preview/app.js`.
- Headless Microsoft Edge / CDP: `node tools/check-preview.mjs` — roster, map rendering, callsign edit, message submission, order submission, acknowledgement, report submission, TOC configuration, ISR selection, layer controls, zoom, roster search, and no page overflow at 1280 / 900 / 600 / 390 px widths. No uncaught browser exceptions.
- Screenshot at 1600 × 1000 inspected; roster uses a contained scroll region so station controls remain visible.

## Not executed

Dedicated-server or hosted multiplayer sessions, real UAV sensor video and TFAR/ACRE radio sessions have not been tested. The remaining acceptance plan is `IN-GAME-TESTS.md`.

Passing HEMTT establishes buildability and static validity. It does not prove engine class inheritance, visual alignment at every UI scale, third-party runtime contracts or multiplayer correctness.

## Live Arma verification — 11 November 2026

Local Arma 3 x64, CBA 3.19.0 and installed original cTab 2.2.2.1, running a single-player Eden preview on Livonia. A separate test-only addon equipped `ItemcTab`, created two friendly groups and executed the smoke checks. This harness is not part of the production addon.

The first native display was blank. The corrected build moves the full-screen background into `controlsBackground`, supplies static title/status/exit/map controls, captures the display through `onLoad`, disables UI serialization in the construction function and explicitly shows newly created controls. Single-player receive handling now accepts the local execution context while retaining the server-owner check in multiplayer.

RPT results at 11:42:07–11:42:19 (local time):

```text
SICS_TEST display: PASS
SICS_TEST tab_MESSAGES: PASS
SICS_TEST tab_C2: PASS
SICS_TEST tab_REPORTS: PASS
SICS_TEST tab_ISR: PASS
SICS_TEST tab_TOC: PASS
SICS_TEST message_roundtrip: PASS
SICS_TEST order_roundtrip: PASS
SICS_TEST order_ack: PASS
SICS_TEST report_roundtrip: PASS
SICS_TEST callsign: PASS
SICS_TEST COMPLETE
```

The live view was inspected, and clicking Overview restored the larger map and combined operations feed. `sics-in-game.png` records that actual engine view. No SQF expression errors appeared in the test log. ISR and TOC tab checks establish that their controls exist, not that UAV video or terminal range enforcement has been exercised.
