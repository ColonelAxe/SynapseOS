# ATLAS 0.12.0-beta.2 / Closed beta

> **Archived build instructions:** Beta 2 requires original cTab. They do not apply to the current cTab-free `dev` source. Do not follow these dependency steps for the standalone build; first complete the acceptance gate in [PRODUCT-WORKUP.md](PRODUCT-WORKUP.md).

Beta 2 adds the Operations app. Follow [the Operations guide](OPERATIONS.md) for overlay publishing, route navigation, contact updates, support/air tasks, TOC screens, mission policy, saved workspaces and journal export. These additions need separate-client multiplayer acceptance testing, particularly reconnect/JIP, concurrent request claims, access revocation, photo attachments and cross-side isolation.

Start with [the CB1 release checklist](CLOSED-BETA-START-HERE.md), [session sheet](BETA-SESSION.md) and [known limitations](BETA-KNOWN-ISSUES.md). This build is intended for a small, organised beta group. The 681-check core run and 20 isolated dedicated-backend checks are documented in BETA2-VALIDATION.md; a multi-person session remains essential. Use the same frozen kit on every client and the server.

## Install

1. Extract the release's `@ATLAS` folder. Enable it with CBA_A3 and the original Riouken/Gundy cTab. Do not load an older ATLAS/SICS build at the same time. ACE is optional.
2. Server administrators copy `@ATLAS/keys/ATLAS_Beta_012.bikey` to the server's normal `keys` directory. Keep the `.bisign` beside `sics_core.pbo`. The release includes SHA256SUMS.txt. Dependency mods need their own matching public keys as usual.
3. Camera photographs additionally require Arma 3 2.22+ on Windows x64 and the bundled `atlas_media_x64.dll` in the mod root. The PBO is signed; the DLL is a separate, unsigned development extension. Validate it under your normal BattlEye policy. If it is blocked, record that result and continue the core beta without Camera; do not disable security protections to work around it.
4. For CB1 copy the kit's `MPMissions/ATLAS_ClosedBeta.VR.pbo` into the server's `MPMissions` directory. The editable source is `examples/ATLAS_Beta.VR` (also in the kit's `MissionSource`). Select **ATLAS Closed Beta CB1 / VR**. Eight slots cover five BLUFOR operators and three opposing-side observers. Only HQ receives designated commander/channel-creation privileges; ALPHA includes a nonleader for role testing. The mission debug console is disabled.
5. Both ATLAS devices and portable GPS are supplied in the backpack, including after respawn. BLUFOR operators receive a UAV terminal and helmet-camera item. The station has a TOC laptop and briefing screen, moving crewed BFT fixture, empty ground vehicle, empty helicopter and armed UAV. AI fixtures are noncombatant/protected; observers spawn away from the station.

## Controls

| Action | Default |
|---|---|
| Moving GPS / Main | U |
| Full device / Secondary | Ctrl+U |
| Personal device / Tertiary | Alt+U |
| Zoom in / out | Ctrl+Shift+Page Up / Page Down |
| Interface position | Ctrl+Shift+Home |

Bindings are under CBA → SynapseOS. ACE Self Interaction → SynapseOS devices offers carried devices and supported mounted consoles. Aircraft Main/Secondary use original cTab TAD. Hardware menu, zoom and power buttons work on the frame; hover for each action. Home's tray opens Notifications and audio/display preferences.

Settings → Preferences controls spoken cues, banners, compact/standard/large text and supplemental vehicle trails/labels. Restore defaults affects these local preferences only. **Write beta diagnostics to RPT** records build/runtime information without message contents or player UID.

## First session / 45–60 minutes

| Test | Expected result |
|---|---|
| Two friendly clients: broadcast and directed messages | Intended peers receive the update once; incoming cues and unread counts work. Home must not consume unread messages. |
| Create Command and Ground-to-Air chats; grant/revoke one operator | Only current members receive history and messages. A revoked channel and its cached report photo must become unavailable. |
| Message, report and order notifications | Notification centre retains up to 50 updates. Open selects the conversation or record; Mark all read and Clear history behave correctly. |
| Ordinary traffic with no photograph | Messages, reports, orders and acknowledgements continue to work. |
| Map markers, lines, grids, contact reports | Correct positions, colours, NATO symbols, designation and contact count on both friendly clients. |
| Moving vehicle and dismounted equipped group | Authorised BFT updates; Centre selected finds the unit after panning away. Unequipped units are not newly revealed by ATLAS. |
| UAV video, Pilot and Turret/weapons | Correct role granted; an occupied role cannot be stolen. Releasing control returns cleanly. Test firing only in an appropriate controlled area. |
| Helmet camera and Camera photographs | Live video stops when leaving the app. Capture, upload, attach, receive and reopen a photograph on a second client. Closing Camera during capture leaves no stuck camera or busy state. |
| Late join, reconnect and respawn | Only currently authorised mission history appears; devices are reissued by this test mission. No duplicate notifications or handlers. |
| Opposing-side observer and side switch | No friendly private messages, channel grants, photos or retained drafts cross the boundary. Changing sides closes the old session. |
| Tablet, phone, portable, ground seat, aircraft and TOC | Appropriate frame, usable controls and no text, dialog or wallpaper outside the glass. Rear passengers need carried equipment. |
| 1080p, 1440p, ultrawide and UI scales | Inspect all apps, large text, long callsigns, full rosters, long reports and open dropdowns. Scrollable text must remain readable. |
| Busy mission | Record average/minimum FPS, approximate unit/marker counts and traffic. Toggle trails/labels to compare. Check server and client RPTs. |

The included mission is a repeatable starting point, not a production scenario. Native extension sharing has been exercised locally; cross-client transfer, JIP and radio combinations must be checked by the beta group. Photos and communications are mission-session data, not persistent records across server restarts. No external image service is used.

## Report a defect

Use BETA-ISSUE-TEMPLATE.md. Include build, device, resolution/UI scale, mod versions, reproducible steps and the relevant timestamped client/server RPT excerpts. A screenshot is particularly useful for visual issues. ATLAS does not upload diagnostics automatically.

Stop a session for a reproducible crash, wrong-side data disclosure or broken ordinary communications. Record minor visual defects and continue independent tests. Re-test fixes with the same reproduction steps before adding more participants.

## Maintainer rebuild

Run `hemtt build --no-bin`, `tools/build-native.ps1` when changing C++, `native/test-media.ps1`, and `tools/check-preview.mjs`. Build `tests/runtime` separately after the main build; do not run both HEMTT builds concurrently. The local runtime harness runs beta, core, media, drone and normal/large-text UI checks. Run `tools/sign-beta.ps1` after the final build, then `tools/package.ps1`. Back up `.keys` privately; never distribute `.biprivatekey`. The source archive deliberately excludes private signing keys, compiler cache, logs and generated runtime output.
# Archived beta guide

This checklist was written for the frozen beta 2 build, which requires CBA_A3 and original cTab. It does not apply to the current cTab-free `dev` source. Do not treat the archived package as an independent build; follow the no-cTab acceptance gate in `PRODUCT-WORKUP.md` first.
