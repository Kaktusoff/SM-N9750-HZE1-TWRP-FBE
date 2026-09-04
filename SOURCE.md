# Reproducing the TWRP build

Use a Linux build host with the standard Android/TWRP build dependencies and
the `repo` tool.

1. Initialize a TWRP Android 12.1 workspace.
2. Place `source/pinned-base-manifest.xml` in the manifest repository and
   reinitialize with that manifest, then run `repo sync`.
3. Extract `device-samsung-d2q-HZE1-lab13.tar.zst` so that the result is
   `device/samsung/d2q`.
4. Apply the four patches from `source/patches/` in their matching projects:

```bash
git -C system/vold apply ../../source/patches/system-vold-hze1-fbe-lab13.patch
git -C bootable/recovery apply ../../source/patches/bootable-recovery-hze1.patch
git -C system/libhidl apply ../../source/patches/system-libhidl-recovery.patch
git -C device/qcom/twrp-common apply ../../../source/patches/qcom-twrp-common-hze1.patch
```

Adjust the patch paths to the location of this repository. Then build:

```bash
source build/envsetup.sh
lunch twrp_d2q-eng
ALLOW_MISSING_DEPENDENCIES=true mka recoveryimage
```

`ALLOW_MISSING_DEPENDENCIES=true` is used because the minimal recovery manifest
does not include unrelated CTS/VTS defaults. It does not replace the completed
ramdisk dependency audit.

The published final image was repacked into the exact stock HZE1 recovery
container. A build output with a different size or hardware payload must not be
flashed as though it were the published image.

The normal-boot image was created from the exact live HZE1 BOOT using official
Magisk 30.7 scripts and the supplied `source/boot-overlay/twrp-survival.rc`.

