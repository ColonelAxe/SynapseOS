# Beta checkup / 15 November 2026

## Fixed during this pass

| Area | Finding and resolution |
|---|---|
| Unread notifications | Home could count as reading the previously selected ATLAS tab. Reading now requires ATLAS to be the active app and the matching conversation. |
| Notification access | The new centre rechecks revoked channels and expired records before opening a deep link. History is bounded to 50 and is purged with the session. |
| Side changes | Markers were cleared, but other caches could survive. Side changes now revoke the whole old session, including drafts, grants, queues and local photo data. Closing the old UI is prevented from saving its private draft back into the cleared session. |
| Camera cancellation | A capture could continue after leaving the app. A generation guard now cancels it, removes handlers and prevents stale completion from opening or changing a later app session. |
| Photo metadata | Location and heading were sampled after capture. They now use the shutter-time values. |
| Photo transfer | Declared byte/chunk counts were not cross-checked and incomplete uploads had an unhelpful retry path. Lengths are checked and retry is rate-limited with an upload timeout. |
| Revoked photos | Downloaded private-channel images are dropped from the local gallery/cache on revocation. Late inbound images require an accessible report reference. |
| Readability | Added local text presets, scrollable content where needed, roster tooltips and large-text layout checks. Shared app headers, glass bounds, taskbar date/time and hardware hit areas retain the previous cleanup. |
| Beta support | Added runtime diagnostics, public PBO signing key/signature verification, binary hashes, a five-slot VR mission and issue template. Private signing keys and logs are excluded from distribution. |

## Testing boundaries

The native automated harness exercises local game behavior with AI and explicit permission fixtures. A dedicated-server boot verifies mission/addon initialization without a player session. Neither substitutes for two-client delivery, JIP, contention, respawn/reconnect, long-session performance or combinations of radio and vehicle mods. Use BETA-TESTING.md for those sessions.

The Camera DLL remains an unsigned development extension; a signed PBO does not grant BattlEye approval to the DLL. Core testing can continue if normal policy blocks Camera. No firewall or BattlEye settings are changed by the addon.

The beta validation described in this archived checkup used cTab-authorised game objects. The current `dev` implementation has replaced that BFT feed with SynapseOS snapshots; the new source has compiled, but standalone runtime authorization and load performance still require acceptance. Vehicle trails and extra labels can be disabled locally for busy maps.

The current release is a closed-beta candidate, not a claim of complete multiplayer certification. VALIDATION.md records completed runs and any remaining checks.
