# ATLAS Closed Beta 1 (CB1)

> **Archived package instructions:** CB1 requires original cTab. It is not the current cTab-free `dev` build.

Release candidate: **CB1**, 16 November 2026. Core mod: **0.12.0-beta.2**. Mission: **CB1 / eight slots**. This is a controlled community test, not a public stable release.

## Players

1. Extract `ATLAS-Closed-Beta-CB1.zip`. Add its `@ATLAS` folder as a local mod in the Arma launcher.
2. Enable **CBA_A3**, **original cTab** and **ATLAS**. Disable every older SICS/ATLAS build and cTab fork. For session one, use the organiser's agreed dependency versions; ACE is optional but everyone should use the same preset. Add your community modpack/radio system in a separate compatibility session.
3. Restart Arma after changing builds. Do not update dependencies halfway through a session.
4. Join the organiser's dedicated server and choose a role in **ATLAS Closed Beta CB1 / VR**. Tablet, phone and portable GPS are supplied in the backpack and reissued on respawn. BLUFOR also receives a UAV terminal and helmet-camera item.
5. **U** toggles moving GPS; **Ctrl+U** opens the full device; **Alt+U** opens carried equipment. Choose ATLAS for tactical tools or Operations for plans/support/air tasks. Bindings are under Configure Addons → SynapseOS. See [the full guide](BETA-TESTING.md) and [Operations](OPERATIONS.md).
6. Write build/runtime diagnostics through Settings → Preferences before reporting a problem. Record the device, test-case ID and approximate time. Use [the issue template](BETA-ISSUE-TEMPLATE.md).

## Organiser / server administrator

- Install the same `@ATLAS` and agreed dependencies on server and clients. Keep `sics_core.pbo.ATLAS_Beta_012.bisign` beside the PBO and install `ATLAS_Beta_012.bikey` in the server's normal `keys` directory, together with the dependencies' public keys. Keep signature verification enabled.
- Copy `MPMissions/ATLAS_ClosedBeta.VR.pbo` from the kit into the server's `MPMissions` directory. Use the supplied `server-cb1.cfg.example` as a configuration reference, replace its test password and adapt it to your normal hosting setup. No server or session has been booked automatically.
- Do not load the source archive's runtime test harness on this server: it creates fixtures and automatically changes state. The CB1 mission does not run that harness. Debug console is disabled in this mission.
- Compare `RELEASE-CB1.json` and `SHA256SUMS.txt` between installations. The manifest identifies the frozen core, extension and mission. Share a new revision and updated hashes if any runtime or mission file changes; never silently replace an active session's build.
- Assign a session lead and a note taker. Use [the session sheet](BETA-SESSION.md) and [the known limitations](BETA-KNOWN-ISSUES.md). The announcement in `BETA-DISCORD.md` is a draft to post manually.

## Roles

| Slot | Side / group | Purpose |
|---|---|---|
| HQ commander | BLUFOR / HQ | Creates private channels, issues orders and coordinates the briefing screen. Only this slot receives the designated commander flag. |
| ALPHA leader | BLUFOR / ALPHA | Ground leader, recipient order progress, group channel membership and support requests. |
| ALPHA member | BLUFOR / ALPHA | Same-group access, nonleader restrictions, reports and moving GPS. |
| BRAVO leader | BLUFOR / BRAVO | Different-group access denial/grant/revocation and concurrent edits. |
| Aviation operator | BLUFOR / EAGLE | Helicopter/TAD, assigned air tasks and drone role checks. |
| OPFOR observer | OPFOR | Side-isolation and own-side reports. |
| INDEPENDENT observer | INDEPENDENT | Side-isolation and affiliation checks. |
| CIVILIAN observer | CIVILIAN | Side-isolation and affiliation checks. |

Start with four testers: HQ, ALPHA leader, ALPHA member and EAGLE. With five, add BRAVO. With six to eight, fill observer slots. For a four-person session, rotate one tester through observer slots and reconnect/JIP checks after the friendly workflows; record each slot change. Generic group leaders may issue normal C2 orders/create plans under the default mission policy; being a leader does not grant permission to create private chat channels.

Occupy the ALPHA leader slot when testing the member's nonleader restrictions. Arma may promote the remaining member when the leader leaves; that is a group-role change to record, not proof that nonleader restrictions failed.

The station includes a TOC laptop, shared briefing screen, moving crewed BFT vehicle, empty ground vehicle, helicopter and armed UAV. AI fixtures are noncombatant and protected; this mission is for systems testing. Support requests coordinate players; they do not spawn an evacuation service.

## Start / finish conditions

Before inviting everyone, confirm that the mission boots, both first clients can open a supplied device and one friendly message/report arrives. Log the loaded build and dependency versions. If Camera is blocked by the normal extension/BattlEye policy, record it as blocked and run core tests; do not change security protections to force it to load.

At the end, collect the session sheet, relevant client/server RPT excerpts and issue reports. Mark untested cases **NOT RUN**, not passed. Stop/hold expansion for crashes, side-information leaks, persistent ordinary communication failures, lost shared data or an unusable device interface. Triage first, fix blockers, then repeat their exact reproductions before adding testers.

Keep CB1 unchanged throughout a session. Fixes should ship as a new kit revision with new hashes and a short changelog; put additional feature ideas in the backlog until the first sessions finish. Retain the original kit and session logs for reproduction.

The tested core passed 681 local native checks and 20 isolated dedicated-backend checks. The CB1 mission is prepared separately; real-client multiplayer, JIP and community-modpack acceptance are the purpose of this beta. See [validation](BETA2-VALIDATION.md) for the scope of the core checks.
# Archived CB1 package instructions

These instructions describe the frozen CB1 package, which requires CBA_A3 and original cTab. They do not apply to the current cTab-free `dev` source.
