# Добавочное обновление BOOT до Magisk Alpha 31000 — v1.0.2

Обновление предназначено только для уже разблокированного Snapdragon Galaxy
Note10+ `SM-N9750` / `d2q` на точной базе Android 12 `N9750ZSU6HZE1` с
установленным комплектом TWRP+Alpha v1.0.1.

Установка APK Alpha 31000 обновляет приложение-manager, но не заменяет ядро
Magisk внутри раздела `BOOT`. Образ v1.0.2 обновляет core с
`e8a58776-alpha (30700)` до `96221b69-alpha (31000)` и сохраняет прежнее
правило `overlay.d/twrp-survival.rc`, не позволяющее Samsung-службе
`vendor_flash_recovery` заменить TWRP.

Это no-wipe обновление только раздела BOOT. В нём нет `RECOVERY`, `USERDATA`,
`PIT`, `BL`, `CP`, `CSC` или `SUPER`.

## Файлы

| Файл | SHA-256 |
|---|---|
| `SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img` | `3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4` |
| `AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5` | `28019d0c876fb50944aedac2d27efa5917665d39adb205b35350176537e95469` |
| `Magisk-Alpha-96221b69-31000.apk` | `f77216f829cd0185f58e4b87526544891cca562b8e71a7730856871c24265300` |

APK подписан тем же сертификатом `CN=vvb2060`, что и Alpha 30700 из v1.0.1.
SHA-256 fingerprint сертификата:

```text
59:C2:3D:1C:00:72:8B:02:84:D6:A4:6D:41:14:61:8C:20:D3:54:CB:17:DD:74:3B:AA:76:44:E5:41:BC:1E:44
```

## Windows / Odin 3.14.4

1. Сверьте загрузку по `SHA256SUMS-v1.0.2.txt`.
2. Переведите телефон в Download Mode и дождитесь `ID:COM` / `Added!!`.
3. Выберите `AP_...BOOT-only_v1.0.2.tar.md5` в поле **AP**. Поля **BL**,
   **CP**, **CSC** и **USERDATA** оставьте пустыми.
4. Не включайте **Re-Partition**, **Nand Erase All** и **Flash Lock**, не
   выбирайте PIT. **F. Reset Time** и **Auto Reboot** можно оставить.
5. Нажмите Start, дождитесь `PASS` и загрузки Android. Откройте manager Alpha и
   проверьте core `96221b69-alpha (31000)`.

## Linux / Heimdall

В Download Mode прошейте только raw-образ BOOT:

```bash
heimdall flash --BOOT SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img
```

## Проверка на физическом телефоне

Финальный образ прошит на эталонный `SM-N9750` и считан обратно побайтно.
Android завершил загрузку, пользователь 0 разблокирован и CE-данные читаются,
`su` работает в `u:r:magisk:s0`, core сообщает
`96221b69-alpha (31000)`, DenyList включён. Телефон прошёл цикл Android → TWRP
→ Android; TWRP сохранился и сообщил `3.7.1_12-HZE1-FBE-lab-13`, RECOVERY не
изменился и имеет SHA-256
`d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415`,
а `vendor_flash_recovery` после возврата в Android остановлен.

Play Integrity и решения банковских приложений зависят от серверов и отдельно
после этого обновления core не проверялись. Банковский результат v1.0.1 не
объявляется постоянным свойством v1.0.2.

Не блокируйте загрузчик при custom BOOT/RECOVERY. Не прошивайте обновление на
`SM-N975F`, `SM-N976B`, `d2s`, `d2x`, другую ревизию загрузчика или другую
прошивку.
