# Project naming

- **SynapseOS — Modular Tactical Platform:** the overall Arma 3 mod/project, device shell and extensible application platform.
- **ATLAS:** the battlefield-management application within SynapseOS.
- **Settings, Camera, Notifications and Operations:** applications/workspaces supplied by the current implementation. Future tools can use the existing app-registration API.

The development root is `C:\Users\stijn\OneDrive\Bureaublad\SynapseOS`, renamed from `SICS`. Reopen this directory in your editor and update any personal shortcuts that pointed to the old root. Build/release tools derive their root from their script location, so no absolute development path is required.

The build-project name, mod launcher metadata, addon display name, README and preview page title use SynapseOS. Internal addon prefix `x\sics\addons\core`, `sics_core.pbo`, legacy API aliases, native extension name, signing authority and inventory class IDs remain stable for compatibility with existing missions and equipment. A cosmetic project rename does not require changing these identifiers.

Frozen beta 2/CB1 packages retain their original filenames, installed `@ATLAS` folder and validated binary hashes. The renamed source metadata will apply on the next explicit rebuild/release; it does not silently replace the already validated beta core. Release tools continue to locate those named baseline artifacts relative to this project root.
