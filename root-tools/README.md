# Root tools for v1.0.1

The release directory contains the exact Magisk Alpha APK and two GPL tools
used while configuring the reference phone:

- `Magisk-Alpha-e8a58776-30700.apk`;
- `Integrity-Box-v41.zip`;
- `PlayIntegrityFork-v18.zip`.

Integrity Box and PIF cannot remain active together because both use the module
id `playintegrityfix`. Follow `POST_INSTALL_ROOT.md` for the correct order and
minimal configuration.

Tricky Store is not rehosted: current releases are closed source, so its binary
must come from the author's official release. `download-tricky-store.sh` and
`download-tricky-store.ps1` download public stable build 245 and verify the
author-published SHA-256 before saving it.

Build 245 is the public upstream file, but it is not claimed to be equivalent
to the closed `248-3b07ee3` build used on the reference phone when T-Pay first
worked. Follow the verification and manual fallback in `POST_INSTALL_ROOT.md`.
Both the Integrity Box v41 installer and its Action invoke a network updater
that is intended to write directly to `/data/adb/tricky_store/keybox.xml`.
Back up and perform the external attestation-state precheck before installation;
then verify the log and resulting file instead of trusting either completion
screen.

When changing from Integrity Box to PIF v18, install PIF directly over the same
module id; do not uninstall Integrity Box first. This exact PIF installer can
copy Integrity Box's old `uninstall.sh`, which would later delete Tricky Store
configuration. `POST_INSTALL_ROOT.md` includes the signature-checked removal
step and the required private backup.

No `keybox.xml`, fingerprint, Magisk database, banking-app data, or modified
Google APK is included.
