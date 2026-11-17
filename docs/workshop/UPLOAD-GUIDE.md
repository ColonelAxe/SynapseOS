# Workshop upload guide

Title: copy TITLE.txt.
Visibility: PRIVATE.
Author/brand: Axion Interactive.
Content folder: C:\Users\stijn\OneDrive\Bureaublad\SynapseOS\dist\workshop\SynapseOS
Artwork and copy folder: this folder (docs/workshop). Do NOT upload this folder as the mod.

## Current release gate
The staged binary still requires cTab and CBA. The owner has approved CBA as a dependency, but requires cTab to be removed.
You may upload the current build privately for staging, but it is NOT the requested cTab-free beta.
Do not remove cTab from Steam's Required Items or claim independence until the implementation and a freshly built package pass without cTab installed.
Do not merely remove requiredAddons: inherited classes, assets, equipment, tracking, controls and aircraft interfaces also need replacement.
Do not overwrite the frozen beta archives with untested binaries.

## First upload
1. In Steam Library, enable Tools and install/open Arma 3 Tools.
2. Open its Publisher utility while signed into the correct Steam account.
3. Create a new Workshop item and select the content folder above.
4. Use TITLE.txt. Select 01-workshop-thumbnail.jpg as the preview.
5. Paste DESCRIPTION-CURRENT.bbcode.txt into the description; if Publisher does not expose full formatting, edit the description on the item page after creation.
6. Set visibility to PRIVATE before publishing.
7. Inspect the file list: one signed PBO, its bisign, public bikey, mod.cpp, license/readme and atlas_media_x64.dll. Publisher can exclude executable files: verify the DLL is included if Camera is part of this package. Do not bypass Steam restrictions if rejected.
8. Review/accept Steam's terms yourself and publish.
9. Open the resulting Workshop page and verify it remains Private.
10. Add the current dependencies as Required Items: CBA_A3 and original cTab. For the future validated cTab-free build, CBA_A3 remains required and cTab is removed.
11. Add gallery images using GALLERY.md. Paste the formatted description if needed.
12. Record the item URL and numeric ID in ITEM-RECORD.txt. Update this same item for later builds.
13. Subscribe from your account and test the downloaded package, including the DLL and signatures, rather than assuming the upload matches the local folder.

Private means creator-only, not an invite-only tester list. Do not change to Public. A later tester distribution decision is separate; a direct link alone does not grant access to a Private item.

## Source and credits
Before distributing a binary to testers, provide the matching GPL source archive through an accessible download and put its real URL in the description. Current archive: dist/ATLAS-0.12.0-beta.2-source.zip.
Never distribute .keys/ATLAS_Beta_012.biprivatekey.
Keep attribution for any reused code even after removing its runtime dependency.

## After cTab removal
Rebuild and sign a new revision, run with only Arma 3 + CBA, verify tablet/phone/vehicle/aircraft/GPS/UAV/markers and dedicated-server/JIP behavior, then refresh the upload payload and hashes.
Only then replace the Requirements section with:
"Requires Arma 3 and CBA_A3. cTab is not required. ACE integration is optional."
Recheck current supported features before copying all feature claims into a release description.

## Official references
https://community.bistudio.com/wiki/Arma_3:_Publisher
https://community.bistudio.com/wiki/Publisher
https://partner.steamgames.com/doc/api/isteamremotestorage

No upload is performed by this guide.
