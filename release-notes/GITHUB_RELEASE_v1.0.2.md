# v1.0.2 — incremental Magisk Alpha 31000 BOOT update

This release updates only the Magisk core in `BOOT`, from
`e8a58776-alpha (30700)` to `96221b69-alpha (31000)`, for the exact
Snapdragon Samsung Galaxy Note10+ `SM-N9750` / `d2q` on
`N9750ZSU6HZE1` Android 12.

It is an incremental update for devices that already have the v1.0.1
TWRP+Alpha package. Installing the Alpha 31000 APK alone updates the manager
app but does not replace the core embedded in `BOOT`.

The v1.0.2 BOOT preserves the same `overlay.d/twrp-survival.rc` protection.
Only BOOT is flashed: there is no RECOVERY, USERDATA, PIT, BL, CP, CSC, or
SUPER payload and no Android-data wipe.

## Verified on the physical reference phone

- Android boot completed and user 0 unlocked; CE data was readable.
- Magisk reported `96221b69-alpha:MAGISK:R` / `31000`.
- `su` ran as root in `u:r:magisk:s0`; DenyList remained enforced.
- BOOT read-back exactly matched
  `3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4`.
- The phone completed Android → TWRP → Android.
- TWRP remained `3.7.1_12-HZE1-FBE-lab-13`.
- RECOVERY stayed unchanged at
  `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415`.
- `vendor_flash_recovery` remained stopped after returning to Android.

Play Integrity and banking decisions are server-side and were not separately
re-tested for this core-only update. The v1.0.1 banking result is not treated
as a permanent property of v1.0.2.

## Assets

- `AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5` —
  Windows/Odin BOOT-only package.
- `SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img` — raw BOOT image for
  Linux/Heimdall.
- `Magisk-Alpha-96221b69-31000.apk` — exact Alpha manager APK whose payload
  was used for the BOOT update.
- `INSTALL_UPDATE_RU_EN.txt` — concise Windows/Odin and Linux/Heimdall steps.
- `SHA256SUMS-v1.0.2.txt` — checksums for all four files above.

```text
3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4  SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img
28019d0c876fb50944aedac2d27efa5917665d39adb205b35350176537e95469  AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5
f77216f829cd0185f58e4b87526544891cca562b8e71a7730856871c24265300  Magisk-Alpha-96221b69-31000.apk
7886b7a4cedae68daf03cddcec4e6f4d8cb71f9d3cb97a9ff6470f1b59a4cbfa  INSTALL_UPDATE_RU_EN.txt
```

Read `UPDATE_ALPHA_31000.md` before flashing. Never relock the bootloader while
custom BOOT or RECOVERY is installed. Do not flash on `SM-N975F`, `SM-N976B`,
`d2s`, `d2x`, another bootloader revision, or another firmware base.

## Support the project

- Visa T-Bank: `4377 7278 0483 9954`
- USDT on TON: `UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R`

Verify the `TON` network and the complete address before sending.

---

# v1.0.2 — добавочное обновление BOOT до Magisk Alpha 31000

Релиз обновляет только ядро Magisk внутри `BOOT`: с
`e8a58776-alpha (30700)` до `96221b69-alpha (31000)` для точного Snapdragon
Samsung Galaxy Note10+ `SM-N9750` / `d2q` на Android 12
`N9750ZSU6HZE1`.

Это добавочное обновление для телефона с уже установленным комплектом
TWRP+Alpha v1.0.1. Одна установка APK Alpha 31000 обновляет manager, но не
заменяет core, встроенный в `BOOT`.

BOOT v1.0.2 сохраняет прежнюю защиту `overlay.d/twrp-survival.rc`. Прошивается
только BOOT: в файлах нет RECOVERY, USERDATA, PIT, BL, CP, CSC или SUPER;
данные Android не стираются.

## Проверено на физическом телефоне

- Android завершил загрузку, пользователь 0 разблокирован, CE-данные читаются.
- Magisk сообщает `96221b69-alpha:MAGISK:R` / `31000`.
- `su` работает как root в `u:r:magisk:s0`, DenyList включён.
- Read-back BOOT точно совпал с
  `3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4`.
- Пройден полный цикл Android → TWRP → Android.
- Сохранился TWRP `3.7.1_12-HZE1-FBE-lab-13`.
- RECOVERY остался без изменений:
  `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415`.
- После возврата в Android служба `vendor_flash_recovery` остановлена.

Play Integrity и решения банков зависят от серверов и отдельно для этого
обновления core не проверялись. Банковский результат v1.0.1 не объявляется
постоянным свойством v1.0.2.

## Файлы

- `AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5` —
  BOOT-only для Windows/Odin.
- `SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img` — raw BOOT для
  Linux/Heimdall.
- `Magisk-Alpha-96221b69-31000.apk` — точный manager APK, payload которого
  использован для BOOT.
- `INSTALL_UPDATE_RU_EN.txt` — краткая инструкция Windows/Odin и
  Linux/Heimdall.
- `SHA256SUMS-v1.0.2.txt` — контрольные суммы четырёх файлов выше.

Перед прошивкой прочитайте `UPDATE_ALPHA_31000_RU.md`. Не блокируйте загрузчик
при custom BOOT/RECOVERY. Не прошивайте файлы на `SM-N975F`, `SM-N976B`, `d2s`,
`d2x`, другую ревизию загрузчика или другую базовую прошивку.

## Поддержать проект

- Visa T-Bank: `4377 7278 0483 9954`
- USDT в сети TON: `UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R`

Перед отправкой USDT проверьте сеть `TON` и полный адрес.
