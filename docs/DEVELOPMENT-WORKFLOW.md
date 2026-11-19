# Development and Workshop testing cycle

1. Implement requested fixes on `dev`.
2. Run relevant checks and rebuild the signed Workshop upload folder.
3. Promote the same source snapshot to `main` without force-pushing.
4. Report the commit, upload folder, and any limits, then say ready to republish for Workshop testing.
5. The owner republishes, tests in Arma, and reports the next fixes.

Ready to republish means the package is prepared for owner testing. It does not claim in-game or multiplayer acceptance before those tests happen.


Use only dist/workshop/SynapseOS for Workshop uploads. Rebuilds update that folder in place. Do not create dated mod folders.

