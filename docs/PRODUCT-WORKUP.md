# SynapseOS product workup

Updated: 18 November 2026  
Branch: `dev`

This is a release worklist based on the current source, beta checkup and acceptance sheets. It distinguishes implemented features from work that still needs replacement or evidence. It is not a claim that every multiplayer case has passed.

## Current position

SynapseOS has a unified device shell, ATLAS, Operations, Settings, Camera and Notifications; tablet/phone/compact/vehicle layouts; tactical map tools, reports, channels, orders, support coordination and mission TOC support. The local validation record documents 681 client checks and 20 isolated backend checks for the prior beta build.

The product requirement is **CBA may remain; cTab must not be required**. The current implementation still relies on cTab for device base classes/assets, authorised BFT rosters, marker drawing, aircraft TAD, vehicle-seat policy and ISR camera helpers. Removing only `requiredAddons[]` would break those features. This is the largest implementation gap.

The prior multiplayer acceptance sheet is still marked NOT RUN. Local checks and a dedicated-server initialization do not establish separate-client delivery, JIP, permissions, contention, respawn or side isolation.

The existing UI checkup documents completed geometry/readability work for six layouts. Actual player resolutions, UI scales, long rosters, third-party interface mods and supported device screens still need visual acceptance. No new in-game visual defect is confirmed by this source-only review.

## Prioritized work

### P0 — independent runtime, before calling it standalone

1. **Replace the cTab runtime surface in layers.**
   - Inventory/device classes and icons/models: use SynapseOS-owned assets or vanilla Arma parent classes.
   - Friendly BFT: own server-authoritative roster and equipment eligibility, position cadence, heading and stale/lost state.
   - Map markers and NATO symbology: own draw path and marker records.
   - Vehicle access: mission-configurable seat/class policy without cTab globals.
   - Aircraft display and ISR: replace cTab TAD and render helpers with SynapseOS-owned interfaces.
   - Remove legacy cTab item aliases only after migration guidance and mission compatibility are ready.
   - Keep CBA keybinds; do not bundle cTab code or assets.

2. **Prove the dependency target.** Launch and run the required flows with only Arma 3 + CBA. Confirm no missing config classes, textures, functions or runtime globals. Then update workshop requirements and credits for the actual final dependency set.

### P0 — cross-client acceptance before widening beta

Run the existing CB01–CB14 sheet with two or more clients: directed messages, channel grants/revocation, report revision conflicts, simultaneous claims, orders, screen privacy, UAV ownership, JIP/reconnect, respawn and opposing-side slot changes. Preserve evidence and issue IDs. Repeat on the exact server modpack.

### P1 — quality, robustness and operator workflow

- Add a compact connection/track-health legend that explains **fresh, aging, stale and lost** with last-update time; never imply RF delivery that the game does not model.
- Add explicit confirmation/undo for destructive actions (delete channel, resolve contact, cancel order) and retain a short local undo window where safe.
- Add keyboard focus cues, predictable Enter/Escape behavior, visible disabled reasons, and tooltips for icon-only controls.
- Standardize empty, loading, stale, denied and error states across apps; include a useful next action and avoid silent failures.
- Add configurable update cadence and marker density/trails for server admins and players; publish safe defaults and profile persistence scope.
- Add localization-ready string tables and a high-contrast palette alongside the existing text-size preferences.
- Make camera availability/status visible before capture and give clear timeout/retry guidance when the extension or upload path is unavailable.
- Improve installer/release UX: one current `@SynapseOS` package, checksums, dependency manifest, matching source archive, migration notes and a tested rollback build.

### P2 — optional capabilities after core stability

- Optional radio bridge status adapters for TFAR/ACRE that report available radios without claiming tactical data follows radio range.
- Configurable mission presets for TOC layout, device grants, callsign policy, marker expiry and which roles may issue orders.
- Export/import for mission workspaces and operational presets with schema versioning.
- Observer/replay tools only if server performance and privacy controls are specified first.

## Release gates

1. **Standalone beta:** cTab-free build passes its focused smoke path on Arma 3 + CBA, and no cTab config/runtime references remain in the production addon.
2. **Closed beta:** P0 multiplayer cases pass on the target modpack; crashes, information leaks and data-loss issues are resolved; UI is reviewed at tester resolutions/scales.
3. **Public release:** matching source/runtime/signature packages are reproducible; Workshop description and required-item list match the binary; release notes document known limitations and rollback.

## Tracking

Use GitHub Issues for individual defects and implementation items. Each issue should name a reproduction or acceptance condition, affected branch/build, severity and evidence. Keep this worklist as the dependency and release-gate overview; update it when acceptance evidence changes.
