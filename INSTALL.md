# Installation from stock HZE1

## 1. Read this first

This procedure is only for `SM-N9750` on `N9750ZSU6HZE1`. Bootloader unlock
performs a factory reset and permanently trips Knox. Charge the phone, back up
all data, and keep the complete HZE1 stock firmware available for recovery.

The tested flashing path uses Heimdall. No Odin archive is published because an
Odin wrapper for the final paired images was not tested on hardware.

## 2. Unlock the bootloader

Skip this section only if Download Mode already reports an unlocked bootloader.

1. In Android, enable Developer options and **OEM unlocking**.
2. Power the phone off.
3. Hold both volume buttons while connecting USB to the computer to enter the
   Samsung unlock/download screen.
4. Follow the on-screen long-press Volume Up instruction to unlock the
   bootloader. Confirm the data wipe.
5. Complete the initial Android setup, reconnect to the Internet, enable
   Developer options again, and verify that OEM unlocking is shown as already
   unlocked.

Never relock the bootloader while custom BOOT or RECOVERY is installed.

## 3. Verify the release

Install Heimdall and extract the release package. From the directory containing
the images:

```bash
sha256sum -c SHA256SUMS
```

Both image checks must say `OK`. Also verify the model and firmware in Android:

```bash
adb shell getprop ro.product.model
adb shell getprop ro.build.version.incremental
```

Expected output is `SM-N9750` and `N9750ZSU6HZE1`.

## 4. Flash BOOT and RECOVERY

Enter Download Mode, connect USB, and verify detection:

```bash
heimdall detect
```

Use the included guarded installer:

```bash
./flash-heimdall.sh --flash
```

Or flash manually:

```bash
heimdall flash \
  --BOOT SM-N9750-HZE1-Magisk-v30.7-BOOT-v1.0.0.img \
  --RECOVERY SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.0.img \
  --no-reboot
```

After Heimdall reports success, hold Volume Down + Side/Power until the display
turns black, then immediately switch to Volume Up + Side/Power while USB remains
connected. Release the buttons when TWRP appears.

## 5. First TWRP boot

1. Confirm the version is `3.7.1_12-HZE1-FBE-lab-13`.
2. Enter the same PIN/password used by Android.
3. Verify that internal storage shows normal directory names and sizes.
4. Do not format `/data`. A decrypt failure on the exact HZE1 base is a bug to
   diagnose, not a reason to wipe user data.
5. Select **Reboot > System**.

Android should now boot normally. The patched BOOT stops Samsung's
`vendor_flash_recovery` service during early init, so the custom recovery is not
reconstructed back to stock.

## 6. Install the Magisk app

Download the official Magisk 30.7 APK from the
[Magisk releases page](https://github.com/topjohnwu/Magisk/releases/tag/v30.7)
and install it:

```bash
adb install Magisk-v30.7.apk
```

Open Magisk and verify:

- Installed: `30.7`;
- Zygisk: enabled when the optional hiding stack is required;
- Ramdisk may be reported as `No` on this legacy system-as-root Samsung layout;
  the normal-boot image is intentionally patched with `LEGACYSAR=true`.

To hide the manager itself, open Magisk Settings, choose **Hide the Magisk app**,
accept the default neutral label or enter another one, and let Magisk create a
random package ID.

## 7. Entering recovery later

Power the phone off. Keep USB connected, then hold Volume Up + Side/Power until
TWRP appears.

## 8. Rollback

The safest complete rollback is to flash the full, exact
`N9750ZSU6HZE1` Samsung firmware. Flashing only stock BOOT restores normal
unrooted Android, but the stock vendor service will then restore stock recovery
on the next boot.

Relock the bootloader only after every partition has been returned to complete
stock firmware and the phone has booted successfully. Relocking also wipes data;
Knox remains tripped.

