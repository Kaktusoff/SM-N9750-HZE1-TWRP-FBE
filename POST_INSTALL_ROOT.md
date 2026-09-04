# Optional root-hiding and application stack

These components are not embedded in BOOT/RECOVERY. Versions below describe the
combination tested on the reference `SM-N9750`.

## Base configuration

1. Enable Zygisk in Magisk and reboot.
2. Install [Shamiko](https://github.com/LSPosed/LSPosed.github.io/releases).
3. Keep **Enforce DenyList disabled**. Shamiko reads the selected DenyList
   processes as a blacklist.
4. Add only applications from which root must be hidden.
5. Never add an application that needs root. For example, adding
   `be.mygod.vpnhotspot` makes VPN Hotspot report `Root is missing` even when its
   Magisk policy is `ALLOW`.

Tested: Shamiko `1.2.5 (414)`, reporting blacklist mode.

## Integrity Box

- [Integrity Box](https://github.com/MeowDump/Integrity-Box) v41;
- [Tricky Store](https://github.com/5ec1cff/TrickyStore) v1.4.1 (248).

Integrity Box documents Tricky Store or TEE Simulator as a required attestation
component. Do not publish, share, or import private `keybox.xml` material unless
you understand its origin and security implications. Play Integrity results can
change without a local software update.

## Vector and HMA

- [Vector](https://github.com/JingMatrix/Vector) v2.2 (3080);
- [Hide My Applist](https://github.com/Dr-TSNG/Hide-My-Applist) v3.8.3.

Install Vector as a Magisk module, reboot, install HMA, enable HMA in Vector, and
give HMA scope only over the applications that should not see selected package
names. HMA 3.4 and later explicitly forbids redistribution, so obtain it from
the upstream release page.

## ReVanced

Use the upstream
[j-hc ReVanced Magisk releases](https://github.com/j-hc/revanced-magisk-module/releases).
The tested reference phone currently uses:

- YouTube ReVanced Extended `20.51.39`, patches `dev.7.mpp`;
- YouTube Music ReVanced Extended `9.15.51`, patches `dev.7.mpp`.

Patched YouTube/YouTube Music binaries are not redistributed by this project.

## Verify from ADB

```bash
adb shell magisk -v
adb shell su -c id
adb shell su -c 'magisk --denylist status'
adb shell su -c 'magisk --denylist ls'
```

Expected base state: Magisk 30.7, UID 0 from `su`, Zygisk enabled, and
`Denylist is not enforced` while Shamiko is in blacklist mode.

