# Upstream integration

- Repository: https://github.com/Riouken/cTab
- Inspected revision: `d0e532812743157506a38125daecb282d5629249`
- Upstream config version: 2.2.2.5
- License: GPL-2.0 (upstream LICENSE, reproduced at repository root)
- Credits: Riouken, Gundy, Raspu and cTab contributors.

No upstream SQF, model, texture, sound or PBO is included in the SICS packages. The development reference checkout under `vendor/ctab` is excluded. Install cTab separately.

## Runtime dependencies used

| cTab API / data | SICS use |
| --- | --- |
| `cTab_fnc_checkGear` | Device eligibility |
| `cTab_fnc_drawBftMarkers` | Existing NATO BFT rendering |
| `cTab_fnc_drawUserMarkers` | Existing shared cTab map annotations |
| `cTabBFTgroups`, `cTabBFTvehicles`, `cTabBFTmembers` | Force roster |
| `cTab_fnc_createUavCam`, `cTab_fnc_deleteUAVcam` | Embedded ISR camera and cleanup |
| `cTab_fnc_close` | Close original cTab display before opening SICS |

Different cTab forks can change internal arrays and camera helpers. The inspected original revision is the baseline; other forks need a compatibility test before being advertised as supported.

ACRE public API checked against https://acre2.idi-systems.com/wiki/frameworks/functions-list: `[] call acre_api_fnc_getCurrentRadioList` returns the local player's radio IDs. TFAR adapters use `TFAR_fnc_haveSWRadio` and `TFAR_fnc_haveLRRadio` when defined.
