[SIZE=3][B]Добавочное обновление BOOT: Magisk Alpha 31000 — v1.0.2[/B][/SIZE]

Установка APK Alpha 31000 обновляет приложение-manager, но не меняет core,
встроенный в раздел BOOT. BOOT-only v1.0.2 обновляет core с
[CODE]e8a58776-alpha (30700)[/CODE] до
[CODE]96221b69-alpha (31000)[/CODE] и сохраняет правило
[CODE]overlay.d/twrp-survival.rc[/CODE], которое останавливает Samsung
[CODE]vendor_flash_recovery[/CODE] и защищает TWRP.

[B]Обновление предназначено только для уже разблокированного SM-N9750 / d2q
на точной базе N9750ZSU6HZE1 с установленным комплектом v1.0.1.[/B]
Прошивается только BOOT, без wipe. В AP нет RECOVERY, USERDATA, PIT, BL, CP,
CSC или SUPER.

[SPOILER="Что проверено на телефоне"]
[LIST]
[*]Android загрузился, пользователь 0 разблокирован, CE-данные читаются.
[*]Magisk: 96221b69-alpha:MAGISK:R / 31000; su работает в u:r:magisk:s0.
[*]DenyList включён.
[*]Read-back BOOT: 3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4.
[*]Пройден цикл Android → TWRP → Android.
[*]TWRP сохранился: 3.7.1_12-HZE1-FBE-lab-13.
[*]RECOVERY не изменился: d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415.
[*]После возврата в Android vendor_flash_recovery остановлен.
[/LIST]
[/SPOILER]

[SPOILER="Windows / Odin 3.14.4"]
[LIST=1]
[*]Сверить SHA-256 по SHA256SUMS-v1.0.2.txt.
[*]В Download Mode дождаться ID:COM / Added!!.
[*]В поле AP выбрать AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5.
[*]BL, CP, CSC и USERDATA оставить пустыми. Не включать Re-Partition, Nand Erase All и Flash Lock, не выбирать PIT. F. Reset Time и Auto Reboot можно оставить.
[*]Нажать Start, дождаться PASS и загрузки Android.
[*]Открыть manager Alpha и проверить core 96221b69-alpha (31000).
[/LIST]
[/SPOILER]

[CODE]
3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4  SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img
28019d0c876fb50944aedac2d27efa5917665d39adb205b35350176537e95469  AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5
f77216f829cd0185f58e4b87526544891cca562b8e71a7730856871c24265300  Magisk-Alpha-96221b69-31000.apk
7886b7a4cedae68daf03cddcec4e6f4d8cb71f9d3cb97a9ff6470f1b59a4cbfa  INSTALL_UPDATE_RU_EN.txt
[/CODE]

[B]К сообщению приложены BOOT-only AP для Odin, точный APK Alpha 31000,
RU/EN-инструкция и SHA256SUMS-v1.0.2.txt. Raw BOOT также находится в релизе
GitHub v1.0.2.[/B]

Play Integrity и решения банков зависят от серверов и отдельно после
обновления core не проверялись. Результаты банковского профиля v1.0.1 не
являются бессрочной гарантией для v1.0.2.

[B]Релиз v1.0.2:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.2
