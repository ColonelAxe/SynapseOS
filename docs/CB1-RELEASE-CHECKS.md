# CB1 release preparation checks — 16 November 2026

## Frozen core

The closed-beta kit copies the validated **0.12.0-beta.2** runtime unchanged. It does not rebuild or add features to the core.

Core PBO SHA256: `C8C22876EA750DB9D747BEEAF71F592A1DF6FE29975F592FEF1F0D2ACD60C71D`.

The PBO's V3 signature was independently verified against `ATLAS_Beta_012.bikey`. Core baseline: 681 native checks and 20 isolated dedicated-backend checks; see BETA2-VALIDATION.md. Those counts apply to the core, not to human multiplayer acceptance of the new mission.

## CB1 mission

- SQM and description parsed successfully. Eight distinct playable units across seven groups; ALPHA has a leader and a member. IDs/names are unique. Debug console disabled; maximum players eight.
- All three mission SQF files compiled in an isolated HEMTT validation project. No compilation errors; one marker-network-update optimisation suggestion remains.
- Packed mission contains exactly five files: mission.sqm, description.ext, init.sqf, initPlayerLocal.sqf and initPlayerServer.sqf. Stable PBO prefix `mpmissions\ATLAS_ClosedBeta.VR`; no local development directory embedded as its prefix.
- A local Windows x64 dedicated server booted the packed candidate using original cTab, CBA and the frozen production mod, without the automated test addon. The corrected run logged `ATLAS_BETA_MISSION CB1 ready / eight slots / HQ-only channel creation / noncombat fixtures` and no SQF expression/undefined-variable, missing-texture or control-creation error.
- The initial exploratory boot caught briefing-screen registration running before ATLAS post-init. Mission setup now waits for ATLAS before spawning/registering the station. The successful boot supersedes that exploratory failure.
- Server role assignment grants the designated commander flag only to HQ and retains its slot/permission metadata over respawn. Actual separate-client joins, nonleader behaviour, respawn/reconnect, photo transfer, role revocation and JIP remain **NOT RUN** until the session sheet is executed.

The test server was bound to loopback and is stopped after validation. This is not a hosted community server. No community session, invitations, Workshop upload or Discord post was sent automatically.

## Delivery checks

The preparation tool pins all four runtime/security-file hashes, checks the corresponding source ZIP for private keys/generated logs, packages the mission and generates per-file hashes plus `RELEASE-CB1.json`. The archive SHA256 is supplied separately as `ATLAS-Closed-Beta-CB1.zip.sha256`. The verification tool checks all listed files, refuses mismatches and checks the frozen core hash; it does not replace normal server signature verification.

Source code is supplied under `Source/ATLAS-0.12.0-beta.2-source.zip`; the separately revised mission is editable under `MissionSource/ATLAS_Beta.VR`. Test source is not a runtime addon and must not be loaded on the beta server. The kit contains the required public key and signature, never the private signing key.
