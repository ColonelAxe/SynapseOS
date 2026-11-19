# Workshop upload guide

Title: copy TITLE.txt.
Visibility: PRIVATE.
Author/brand: Axion Interactive.
Content folder (after acceptance only): `dist/release-candidate/0.12.0-beta.3/@SynapseOS`
Artwork and copy folder: this folder (docs/workshop). Do NOT upload this folder as the mod.

## Current release gate
The 0.12.0-beta.3 candidate source and PBO no longer require cTab and build with CBA_A3 as the only mod dependency. The candidate is signed and package tooling is prepared, but it has not passed a clean Arma launch or in-game acceptance. Do not upload or describe it as a released standalone mod until those checks pass.
The existing `dist/@SynapseOS` and frozen beta archives still contain the older cTab-dependent build. Do not use those folders for a standalone upload, and do not overwrite the archived packages.

## First upload
1. Complete the clean Arma + CBA launch, focused in-game smoke and multiplayer release gates in `docs/PRODUCT-WORKUP.md`.
2. Verify the candidate's PBO signature and `SHA256SUMS.txt`; rebuild/re-sign if any runtime file changes.
3. In Steam Library, enable Tools and install/open Arma 3 Tools.
4. Open its Publisher utility while signed into the correct Steam account.
5. Create a new Workshop item and select the content folder above.
6. Use TITLE.txt. Select 01-workshop-thumbnail.jpg as the preview.
7. Paste DESCRIPTION-CURRENT.bbcode.txt into the description.
8. Set visibility to PRIVATE before publishing.
9. Inspect the file list: one signed PBO, its bisign, public bikey, mod.cpp, license/readme and `atlas_media_x64.dll`. Verify that the DLL is included if Camera is part of the release. Do not bypass Steam restrictions if rejected.
10. Review/accept Steam's terms yourself and publish.
11. Open the resulting Workshop page and verify it remains Private.
12. Add **CBA_A3 only** as a Required Item; do not list cTab. Add ACE only if the selected dependency policy requires it.
13. Add verified in-game gallery images. Record the item URL and numeric ID in ITEM-RECORD.txt. Subscribe and test the downloaded package, including the DLL and signatures.

Private means creator-only, not an invite-only tester list. Do not change to Public. A later tester distribution decision is separate; a direct link alone does not grant access to a Private item.

## Source and credits
Before distributing a binary, provide the matching GPL source archive through an accessible download and put its real URL in the description. Candidate source archive: `dist/release-candidate/0.12.0-beta.3/SynapseOS-0.12.0-beta.3-source.zip`.
Never distribute .keys/ATLAS_Beta_012.biprivatekey.
Keep attribution for any reused code even after removing its runtime dependency.

## Requirements copy after acceptance
Use this Requirements text after the candidate passes the standalone acceptance gate:
"Requires Arma 3 and CBA_A3. cTab is not required. ACE integration is optional."
Recheck current supported features before copying all feature claims into a release description.

## Official references
https://community.bistudio.com/wiki/Arma_3:_Publisher
https://community.bistudio.com/wiki/Publisher
https://partner.steamgames.com/doc/api/isteamremotestorage

No upload is performed by this guide.
