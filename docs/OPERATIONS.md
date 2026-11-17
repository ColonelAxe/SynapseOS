# ATLAS Operations — beta 2

Open **Operations** from the SynapseOS desktop. Its shared map and seven tabs extend the existing ATLAS tactical app; messaging, ISR and the normal map tools remain in ATLAS.

## Planning and navigation

In **Plans**, create an overlay first. Draft overlays and their graphics are visible to the author and assigned commanders. Edit its publication to **PUBLISHED** to share with the selected audience. Select **GRAPHIC**, click map points (right-click undoes), then **Details**. Choose the parent overlay, shape, colour and planned speed. Routes and phase lines need at least two points; areas need at least three. Graphics support routes, phase lines, boundaries, objectives and landing zones. Delete an overlay's graphics before deleting the overlay.

Select a route and **Follow**. The moving GPS and air TAD show its checkpoints, distance, bearing and estimated time. Checkpoints advance within 25 metres. ETA uses actual speed while moving, otherwise planned speed. This is navigation guidance; it does not drive vehicles. Hide/show affects only your view. Layer switches control plans, contacts and support independently.

## Reports and contact confidence

The tactical map's contact-report form includes affiliation, every compatible loaded NATO marker, element type, strength, confidence, observation age, expiry and direction. Operations **Contacts** also supports an observation photograph and subsequent updates to the same report. Select a contact and edit it to update its observation instead of creating another marker. Concurrent stale revisions are refused: reopen the latest version before retrying.

Affiliation controls symbol family and colour. Expired observations fade and are labelled stale; expiry is not evidence that a contact disappeared. Resolving a contact hides its marker while retaining its report and journal history. Heading and age are observer estimates. Photographs use the existing Camera capture/mission-transfer pipeline and its access checks.

## Orders and support

**Orders** lists C2 orders and each recipient group's progress: received, acknowledged, executing, completed or cancelled. Receipt is automatic for an addressed connected client; the group's actions advance the other states. The issuer can set a relative deadline or remove it with zero minutes. All expected recipient groups must complete before the overall order completes. The issuer/assigned commander can cancel an order.

**Support** creates CASEVAC, MEDEVAC and logistics requests with location, casualties, urgency, security, landing information and notes. A group leader or commander accepts a request, then advances it to executing and completed. Acceptance claims a request so another group cannot silently take it over. Cancellation is available to the author/commander. These are coordination records; they do not spawn AI medical or supply services.

**Air** contains LZ cards and aircraft tasks. LZ cards carry availability, dimensions, obstacles, wind, marking, security and an optional photo. Tasks select an active friendly crewed aircraft, LZ and optional ingress/egress routes. Their audience is the assigned crew's group. Share/publish referenced information to that crew first. The actual crew group accepts and progresses the task; ATLAS does not force aircraft controls or release weapons.

## Briefing rooms

In Eden, enable the ATLAS briefing-screen attribute on a retexturable screen object and select its side/texture index. An assigned commander or group leader can stand within five metres, select a published side-shared overlay or graphic in Plans, and press **Brief screen**. The room displays that map and selected objective for nearby friendly viewers, including viewers without a carried device. Room displays use the room's shared selection, independent of personal layer switches.

Trusted mission code can register a screen on the server:

```sqf
[tocScreen, west, 0, "Platoon briefing"] call ATLAS_fnc_briefingScreen;
```

Use a screen with a retexturable selection; the index is model-specific. Maximum 20 active screens. Shared-room graphics must be published and side-shared, rather than restricted to a private group. JIP clients receive the screen registry and current selection. The display uses Arma's [UI procedural texture](https://community.bistudio.com/wiki/Procedural_Textures).

## Mission policy, profiles and journal

Place the **ATLAS mission settings** Eden module to permit devices, vehicle consoles, Camera, UAV/helmet feeds, BFT, overlays and support separately. It also configures contact lifetime, journal retention, an optional vehicle class allowlist and command assignment rules. Eden unit attributes assign commander privileges; object attributes configure compatible vehicle consoles and TOC screens. Mission-server code may call `ATLAS_fnc_configureMission` with a hashmap of policy values. This trusted configuration API refuses remote execution.

**Presets** saves local workspace preferences, map view, layers and preferred available carried device. Built-in JTAC, Platoon Leader and Pilot starting layouts are included. Settings links to this workspace screen. Presets never grant equipment or command authority and never persist another mission's private entity IDs. Map coordinates restore only on the same terrain. Maximum 20 saved layouts.

**Journal** provides the authorised chronological view of reports, order progression, operations changes and briefing actions. Export writes that filtered view to the local Arma RPT for handover/AAR. It does not export private chat bodies. This is a bounded mission journal, not a persistent campaign database or full movement replay.

## Feed status and beta limits

ATLAS supplements cTab's authorised BFT list with same-side server observation timestamps. Live is up to 15 seconds old; stale is 15–45 seconds; lost feed is over 45 seconds. Stale tracks retain their sampled position instead of presenting continuing engine movement as fresh information. Lost tracks stop drawing after 120 seconds. A cTab-authorised track without a timestamp is explicitly unverified. This status describes data freshness, not simulated TFAR/ACRE RF propagation. Original cTab TAD tracking remains supplied by cTab.

Operations are server-authoritative, side/audience filtered, revision checked and rate limited. Up to 512 active entities, 64 points per graphic, 100–2000 journal events, and 20 local presets. Entities survive reconnect/JIP within the running mission, not server restarts. Camera transfer and every multiplayer/JIP permission scenario still require testing with real separate clients before public release.
