# SynapseOS usability model

SynapseOS has two deliberate usability tracks: **User Usability** for field players and **Command Element Setup Usability** for HQ staff and mission makers. Live command work remains an in-mission activity, separate from mission configuration.

## 1. Field User

Designed for a player who needs to open the device and act with minimal setup. User-facing screens prioritize clear next steps, familiar controls, and low navigation overhead.

- Home is labelled **Field User / Applications** and presents operational apps.
- **My Settings** contains the personal callsign, display role/rank, notifications, text size, and local preferences.
- **My Layouts** opens role-oriented map/device presets. A profile role can select a helpful starting view in Operations; this is a convenience only.
- The player opens the carried phone, tablet, or portable GPS with the configured keybind or ACE interaction, then uses ATLAS for the map, messages, reports, tasks, and ISR.
- Notifications, large touch controls, remembered map state, and role-oriented starting views reduce repeated navigation.

**Never treat a profile role, callsign, or display rank as authority.** Server policy, group leadership, and mission-assigned commander attributes remain the source of permissions.

## 2. Command Element Setup

Designed for the mission maker or unit staff preparing a mission and its command spaces. Setup is explicit, grouped by purpose, and performed once for the mission rather than mixed into a field user's device settings.

1. Place **Command Element Setup / Mission Policy** from Eden's **SynapseOS / Command Element Setup** category. Configure device availability, sensor/BFT policy, command tools, record retention, and optional vehicle-class restrictions.
2. Assign command authority on the intended HQ unit using **[COMMAND] Assign ATLAS commander**. Global module policy does not itself grant command permissions.
3. Configure supported vehicles with **[VEHICLE] Enable compatible vehicle console**.
4. Mark the intended TOC display with **[TOC] Register briefing screen / command room**, then set the side and model-specific texture selection.
5. Brief command staff to use **Operations** for live planning, reports, orders, support requests, aircraft coordination, and the mission timeline. The operator's profile role only chooses a convenient starting tab.

This keeps server policy and object setup in Eden, personal preferences in **My Settings**, and live operational activity in **Operations**. Mission policy is deliberately not exposed as a control in a field user's device. Mission makers can still use the documented trusted APIs for custom scenarios.

## Responsibilities and permission boundaries

| Setting or action | Where it belongs | Effect |
| --- | --- | --- |
| Personal callsign, displayed role/rank, notifications | Field User → My Settings | Personal identity and display preferences |
| Default device/map layout | Field User → My Layouts | Local presentation only |
| Device, sensor, BFT, overlay, support policy | Eden → SynapseOS mission setup / policy | Server-authoritative mission availability |
| Commander assignment | Eden → unit attributes | Mission command permission |
| Vehicle console and TOC display setup | Eden → object attributes | Enables configured mission objects |
| Orders, support, plans and coordination | Operations during the mission | Server-validated, audience-filtered live records |

## Interface language

- **Field User** means an individual player using SynapseOS equipment.
- **Command Element** means the mission's HQ/TOC staff and their live coordination workflows.
- **Mission Setup** means Eden-time configuration by mission makers or server staff.
- **Operations** means in-mission coordination. It is not the place to change mission policy or grant permissions.

