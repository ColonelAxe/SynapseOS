# Hatchet H-60 integration

SynapseOS core remains independent of Hatchet. `sics_hatchet` is an optional
compatibility PBO and loads only when the Hatchet H-60 configuration, MFD, and
Interaction Framework are present.

## Current integration

- Adds an **ATLAS TAD** touch action to the tactical-map MFD bezel for the
  H-60 pilot and copilot displays.
- Opens the existing SynapseOS aviation layout, using the same mission network,
  BFT tracks, reports, orders, and map state as the handheld and vehicle views.
- Leaves Hatchet's flight controls, sensor pages, map page, and JVMF implementation
  intact. The action is added on the tactical map page at the currently unused
  24th MFD bezel selection.
- When an ATLAS interface is already open, the action minimizes it.

## Loadout

Enable the base `@SynapseOS` mod and Hatchet's H-60 pack plus its Interaction
Framework. The compatibility PBO belongs to an optional `@SynapseOS-Hatchet`
addon folder; do not add its PBO to the base SynapseOS mod, because its required
Hatchet addons are intentionally optional for the core product.

## Validation status

HEMTT config/SQF validation checks that the adapter compiles. In-game acceptance
must confirm that all four Hatchet touch selections are clickable and that the
ATLAS overlay opens in pilot and copilot seats. A live Hatchet mission and the
same Hatchet build are required for that final acceptance; config compilation
alone does not verify cockpit selection geometry or touch input behavior.

The current adapter opens the ATLAS aviation console from Hatchet's MFD bezel.
Rendering ATLAS symbology directly inside Hatchet's MFD raster page is a separate
follow-on integration and is not represented as completed by this adapter.
