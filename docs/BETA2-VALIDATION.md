# ATLAS 0.12.0-beta.2 — validation, 16 November 2026

## Completed

- HEMTT 1.23.0 production build: config rapification, 101 SQF functions, one core PBO. No build errors; existing optimisation/style suggestions remain.
- Windows x64 Arma 3 2.22.154191 dedicated engine, original cTab and CBA: **20 backend assertions passed, zero SQF expression errors, completion marker present**. The isolated test used local fixture units; it did not exercise actual client transport or JIP.
- Dedicated checks: published overlay, route geometry, invalid geometry rejection, contact creation/update without duplicate report, stale edit rejection, resolve-on-delete, MEDEVAC creation/completion, LZ creation, aircraft assignment/crew audience/completion, order deadline/backward-transition rejection/completion, overlay policy, screen registration/shared selection and journal events.
- Interactive Arma 3 + original cTab + CBA + ACE: **681 assertions passed, zero failures**, with every suite and the combined run completed. Final log: `arma3_x64_2026-11-16_20-14-57.rpt`. No SQF expression/position errors, control-creation errors or missing-texture warnings occurred in that final run.
- Native breakdown: Operations 43; beta preferences/notifications/access cleanup 29; core smoke/messaging/channels/ISR/device/session checks 199; media 8; drone controls 4; UI audits 398. The UI audits require a live display and check geometry across tablet, phone, portable, vehicle, aviation and workstation layouts at text scales 1 and 1.15. Geometry checks do not prove that every possible user text fits or replace visual judgement.
- Moving-GPS route guidance, workspace save/apply, updated contacts without duplicate reports, stale edit rejection, support progression, air assignment, order progression/deadlines, feed ageing and the rendered room-screen UI texture/map passed in the native run.
- Fixed during native testing: missing route texture and contact confidence overwriting strength/type marker text. The test harness now restores commander/presentation state, keeps explicit fixture-group references, removes temporary groups, prevents fixture combat and opens each device context independently. Earlier failed exploratory runs remain superseded by the clean final run.
- Browser regression: existing ATLAS/SynapseOS workflows passed; new Operations tabs, overlay form, route form/geometry, follow selection and 1600/900/600px layouts passed without uncaught exceptions. The preview uses fictional local data and does not validate SQF or multiplayer.
- Production PBO signed with ATLAS_Beta_012 and verified by DSCheckSignatures. Private key stays outside both archives.

## Incomplete — do not treat these as passed

The earlier interactive run was blocked by a Windows Security prompt; the user resolved it and the native regression was resumed and completed. No Windows security setting was changed by the agent. These results supersede the earlier partial beta 2 validation. Previous beta 1 results still apply only to that older build.

Separate real-client multiplayer testing remains required: server-enforced sender ownership, simultaneous claims/edits, audience changes, role revocation, reconnect/JIP, aircraft crew reassignment, no-device TOC viewers and report photo transfer. The dedicated fixture suite validates backend execution and transitions; it is not proof of those network scenarios.

## Reproduce

1. Build the root with `hemtt build --no-bin` and wait for completion.
2. Build `tests/runtime` separately with `hemtt build --no-bin`; do not run both builds concurrently.
3. Run `tools/launch-test.ps1 -ModFolder '@ATLAS-b2-test' -Restart -ACE` for the owned local client test. Both device items and test fixtures are supplied automatically. Resolve OS permission dialogs yourself if they appear.
4. Inspect the latest `test-profile/*.rpt`: require every suite's COMPLETE marker, no FAIL entries and no ATLAS SQF/asset errors. Native UI audits cover Operations tabs and editors on tablet, phone, portable, vehicle, aviation and workstation layouts at normal and larger text scales.
5. Run `node tools/check-preview.mjs` for the offline preview regression.
6. After any production rebuild, re-sign with `tools/sign-beta.ps1` before `tools/package.ps1`.

The test-only addon also runs `server-check.sqf` automatically when loaded on a dedicated server. Keep it off live/public servers: it creates and modifies fixture records and units. It is included only in the source archive, never in the playable mod's addons.
