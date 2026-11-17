# CB1 session sheet

Session/date: __________  Lead: __________  Note taker: __________

Kit revision + archive SHA256: __________  Core/mission SHA256: __________

Server Arma version: __________  Dependency versions / preset: __________

Players / roles: __________  ACE: __________  Radio system: __________

Result values: **PASS / FAIL / BLOCKED / NOT RUN**. Fill every row; attach issue IDs and times. This blank sheet is not evidence of a passed multiplayer test.

## Session one — baseline, approximately 75 minutes

| ID / time budget | Exercise and acceptance | Result / time / issue |
|---|---|---|
| CB01 / 0–10 min | All clients match CB1 hashes/preset. HQ and ALPHA open supplied tablet/phone. Desktop, Settings and ATLAS/Operations work. Wrong/duplicate build is corrected before continuing. | NOT RUN |
| CB02 / 10–15 | HQ sends a side broadcast and a group-directed message/order. Intended peers receive each once; unintended groups do not receive directed traffic. Check banners/audio/unread on the desktop and inside the app. | NOT RUN |
| CB03 / 15–20 | HQ creates Command chat, grants ALPHA group, leaves BRAVO/EAGLE ungranted. ALPHA leader and member can read/send; ungranted testers cannot. A normal member cannot create/manage the channel. | NOT RUN |
| CB04 / 20–25 | Grant EAGLE a Ground-to-Air chat, exchange messages, then revoke membership and reconnect that tester. Old channel/history/photos cannot be reopened; unrelated authorised traffic still works. Delete a disposable channel and verify removal on both clients. | NOT RUN |
| CB05 / 25–30 | ALPHA marks a contact: designation, NATO type, affiliation, strength, confidence, observation age and lifetime. HQ receives the same location/data. Update the existing contact: one report/marker is updated, not duplicated. Resolve it and verify the marker stays hidden. | NOT RUN |
| CB06 / 30–35 | Two authorised clients edit the same contact revision. First accepted edit is retained; stale second edit is refused with a useful message. Repeat on a support claim: only one group takes the initial claim. | NOT RUN |
| CB07 / 35–40 | Publish a plan, add route/phase line/objective and share it. A route appears on a second client; Follow shows checkpoint/bearing/distance on moving GPS while walking. Pan away from an authorised friendly symbol and Centre selected finds it again. | NOT RUN |
| CB08 / 40–45 | HQ issues an order to ALPHA with a short deadline. Receipt, acknowledgement, executing and completion appear correctly at HQ. A nonrecipient cannot progress it. Completion/cancellation cannot be reopened or moved backwards. | NOT RUN |
| CB09 / 45–50 | ALPHA creates a MEDEVAC/CASEVAC request with casualties, urgency and pickup details. Another leader accepts, executes and completes it. HQ creates an LZ/air task for occupied EAGLE aircraft; assigned crew can access references and progress the task. No automatic AI service is expected. | NOT RUN |
| CB10 / 50–55 | Near the screen, HQ briefs a published side-shared overlay/objective. Two nearby friendly viewers see the same map/focus, including a viewer temporarily without carried ATLAS/cTab equipment. Private/draft graphics stay off the public room screen. | NOT RUN |
| CB11 / 55–60 | EAGLE checks ground console, helicopter Main/Secondary TAD and Tertiary carried device. Rear passengers without equipment do not gain console access. Two operators attempt the same drone role; the occupied role cannot be stolen. Streams/control release cleanly. | NOT RUN |
| CB12 / 60–65 | Late join and reconnect: only authorised current mission data appears; no duplicate notifications. Respawn reissues devices and preserves HQ/non-HQ permissions correctly. Switch to an opposing slot and check old channels/drafts/photos are unavailable. | NOT RUN |
| CB13 / 65–70 | Optional Camera gate: under normal security policy capture/upload/attach a photo, receive and reopen it on another client. Include it in a report or LZ card. Revoke access and reconnect. If extension loading fails, log BLOCKED and the exact error. | NOT RUN |
| CB14 / 70–75 | Export the authorised journal, inspect long text/dropdowns at normal/larger text scale and agree the blocker list. Record FPS before opening, while open and after closing. Save diagnostics and relevant RPT excerpts. | NOT RUN |

If a case takes longer, record partial coverage and schedule another session. Do not rush privacy, role or JIP checks to finish the timetable.

## Session two — compatibility and endurance

Repeat CB02–CB13 using the community's exact mission/mod preset. Test TFAR and ACRE in separate agreed runs rather than combining radio systems arbitrarily. Radio integration indicates available equipment; data freshness does not model RF range. Run 30–60 minutes of ordinary movement, contact updates and communication. Record player/AI/marker/entity counts, client/server FPS and any degradation after repeated open/close/capture/JIP cycles. Exercise the resolutions and UI scales actually used by testers, including ultrawide if available; the local geometry suite is not a substitute.

## Decisions / handover

- P0/P1 issues (stop expansion): __________
- Other issues and owners: __________
- Blocked or NOT RUN cases + next session: __________
- Required retests on next revision: __________
- Session lead decision: HOLD / repeat closed beta / expand closed beta

Expand only after the critical cross-client workflows and JIP/access cases pass on the target preset and no unresolved crash, information leak, data-loss or blocked-core-workflow issue remains. A successful closed beta does not automatically approve a public release.
