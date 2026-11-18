# CB1 known limitations and open acceptance work

> **Archived build:** This known-issues list describes the frozen cTab-dependent beta package, not the current `dev` source.

This list separates implemented behaviour from work that still needs evidence. It is not a declaration that every untested scenario is broken.

| Area | Current position / tester action |
|---|---|
| Real multiplayer | Core checks passed locally; separate-client transport, simultaneous edits/claims, group grants, JIP/reconnect, crew reassignment and side isolation require the beta session. Record exact participants/roles and timestamps. |
| Camera | Windows x64 / Arma 3 2.22+ and bundled unsigned native extension. Normal BattlEye/extension policy may block it. Record the loading error and mark Camera BLOCKED; continue independent core cases. No external photo service is used. |
| Dependencies | Original cTab and CBA required; alternative cTab forks are not certified. ACE is optional. Freeze the agreed versions for a session. TFAR/ACRE and the community preset need their own compatibility evidence. |
| Feed freshness | Live/stale/lost indicates observation age, not simulated RF propagation or a guaranteed TFAR/ACRE data path. Original cTab aircraft TAD supplies its own tracking. No-timestamp authorised tracks are marked unverified. |
| Support / air coordination | Requests and tasks are shared coordination records. They do not dispatch/spawn AI medics, fly the aircraft or release its weapons automatically. Native drone control still needs compatible equipment and an available role. |
| Lifetime | Records/photos are mission-session state. Server restarts are not campaign persistence. Journal export writes the authorised local view to RPT; it is not a complete movement replay. |
| Capacity | 512 Operations entities, 64 points/graphic, configured 100–2000 journal events, 20 active room screens, 20 local workspaces; ordinary records are retained in a bounded history. Long-session behaviour near limits remains an acceptance test. |
| UI | Six layouts passed geometry checks at normal/larger text sizes. Real resolutions, UI scales, long rosters, open dropdowns and third-party fonts/mods still need visual testing. |
| CB1 mission | Eight slots; noncombat/protected fixtures; only HQ has designated commander permission. It is a repeatable systems-test scenario, not a finished combat mission. Group leaders retain normal default leader C2 capabilities. |
| Security/roles | Display rank/profile fields do not confer command permissions. Use role tests on a dedicated server. The beta does not claim protection from a server administrator or unrestricted client code executing arbitrary Arma commands. |

No crash or SQF/asset error was observed in the final 681-check local core run. That result does not promise crash-free multiplayer. Log newly found defects with an issue ID and move confirmed blockers into the session handover.

## Severity and handling

- **P0:** wrong-side/private information disclosure, repeated crash/freeze, or mission-wide corruption. Stop the affected test, preserve minimal evidence, notify the organiser privately and hold expansion.
- **P1:** lost shared data, unusable device, persistent ordinary communication failure or a core workflow blocked without a reasonable workaround. Hold expansion until fixed and retested.
- **P2:** a feature or readable layout is impaired, with the rest of the session usable. Record a reproduction and test independent cases.
- **P3:** cosmetic/wording issue with no blocked action. Record device, scale and screenshot.

Record optional Camera policy restrictions as BLOCKED rather than inventing a passed photo-sharing result. A workaround must be written down and retested; it does not erase the defect.
# Archived beta 2 known issues

This page describes the frozen cTab-dependent beta 2 build, not the current cTab-free `dev` source.
