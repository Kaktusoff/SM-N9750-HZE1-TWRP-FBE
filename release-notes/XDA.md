[SIZE=6][B]SM-N9750 HZE1: TWRP FBE + Magisk Alpha — v1.0.1 base + v1.0.2 BOOT update[/B][/SIZE]

[B]Device:[/B] Samsung Galaxy Note10+ Snapdragon, SM-N9750 / d2q
[B]Required base:[/B] N9750ZSU6HZE1, Android 12
[B]Status:[/B] BOOT and RECOVERY tested on physical hardware

[B]This is not a custom ROM.[/B] Stock One UI remains installed. For a fresh installation, use the complete v1.0.1 TWRP+Alpha package. v1.0.2 is an incremental BOOT-only update for a phone that already has v1.0.1 installed.

[SIZE=5][B]Latest update: Magisk Alpha 31000 — v1.0.2[/B][/SIZE]

Installing the Alpha 31000 APK updates the manager application, but it does not replace the Magisk core embedded in BOOT. The v1.0.2 image updates that core from [CODE]e8a58776-alpha (30700)[/CODE] to [CODE]96221b69-alpha (31000)[/CODE] while retaining [CODE]overlay.d/twrp-survival.rc[/CODE], which prevents Samsung's [CODE]vendor_flash_recovery[/CODE] service from replacing TWRP.

This is a no-wipe BOOT-only update. It contains no RECOVERY, USERDATA, PIT, BL, CP, CSC, or SUPER payload.

[SPOILER="v1.0.2 physical-device verification"]
[LIST]
[*]Android completed boot; user 0 unlocked and CE data was readable
[*]Magisk reported [CODE]96221b69-alpha:MAGISK:R[/CODE] / [CODE]31000[/CODE]
[*][CODE]su[/CODE] ran as root in [CODE]u:r:magisk:s0[/CODE]; DenyList remained enforced
[*]BOOT read-back exactly matched [CODE]3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4[/CODE]
[*]The phone completed Android → TWRP → Android
[*]TWRP remained [CODE]3.7.1_12-HZE1-FBE-lab-13[/CODE]
[*]RECOVERY remained unchanged at [CODE]d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415[/CODE]
[*][CODE]vendor_flash_recovery[/CODE] remained stopped after returning to Android
[/LIST]
[/SPOILER]

[B]v1.0.2 release and files:[/B]
[URL unfurl="true"]https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.2[/URL]

[CODE]
3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4  SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img
28019d0c876fb50944aedac2d27efa5917665d39adb205b35350176537e95469  AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5
f77216f829cd0185f58e4b87526544891cca562b8e71a7730856871c24265300  Magisk-Alpha-96221b69-31000.apk
7886b7a4cedae68daf03cddcec4e6f4d8cb71f9d3cb97a9ff6470f1b59a4cbfa  INSTALL_UPDATE_RU_EN.txt
[/CODE]

[SPOILER="Install v1.0.2 with Windows / Odin 3.14.4"]
[LIST=1]
[*]Verify the download against [CODE]SHA256SUMS-v1.0.2.txt[/CODE].
[*]Enter Download Mode and wait for Odin to show ID:COM / Added!!.
[*]Put [CODE]AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5[/CODE] in AP.
[*]Leave BL, CP, CSC, and USERDATA empty. Do not enable Re-Partition, Nand Erase All, or Flash Lock, and do not select a PIT. F. Reset Time and Auto Reboot may remain enabled.
[*]Start, wait for PASS, and let Android boot.
[*]Open the Alpha manager and confirm core [CODE]96221b69-alpha (31000)[/CODE].
[/LIST]
[/SPOILER]

[SPOILER="Install v1.0.2 with Linux / Heimdall"]
From Download Mode, flash only the raw BOOT image:
[CODE]heimdall flash --BOOT SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img[/CODE]
[/SPOILER]

[B]Play Integrity and banking-app decisions are server-side and were not separately re-tested for the v1.0.2 core-only update.[/B] The banking result documented below belongs to the v1.0.1 reference profile and is not a permanent guarantee for v1.0.2.

[SIZE=5][B]Fresh installation: complete v1.0.1 base[/B][/SIZE]

The first Samsung bootloader unlock always wipes data and trips Knox. No-wipe applies only after the bootloader is already unlocked on the exact HZE1 base.

[B]Linux / Heimdall:[/B]
[CODE]./flash-heimdall.sh --flash-no-wipe[/CODE]
flashes BOOT+RECOVERY. Use
[CODE]./flash-heimdall.sh --twrp-only-no-wipe[/CODE]
for RECOVERY only; stock BOOT may restore stock recovery.

[B]Windows / Odin 3.14.4:[/B] choose one v1.0.1 AP package:
[LIST]
[*][CODE]AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5[/CODE] — BOOT+RECOVERY
[*][CODE]AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5[/CODE] — RECOVERY only
[/LIST]

Leave BL, CP, CSC, and USERDATA empty. Disable Auto Reboot, leave F. Reset Time enabled, and never use Re-Partition, Nand Erase All, Flash Lock, or PIT. After green PASS!, force-exit Download Mode and immediately boot TWRP while USB stays connected.

[CODE]
aa12bed3104f48bdea7e7b18a26b72efe3f249237fbc18fdbfad9a483ec1cbd2  AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5
363f8272d86450017ae7488f9f5c28976bbfc664886159de1040339200bd4206  AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5
6d4d523e9e298717a224229d0b6f3e4bcf4141855b4eb98c913280025f549fc3  TBank-biometric-fix-v1.0.1.zip
[/CODE]

Neither v1.0.1 AP archive contains USERDATA, SUPER, PIT, CSC, or modem images.

[B]Complete v1.0.1 base release:[/B]
[URL unfurl="true"]https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.1[/URL]

[SPOILER="v1.0.1 physical-device verification"]
[LIST]
[*]Normal Android boot, Magisk Alpha [CODE]e8a58776-alpha (30700)[/CODE], and working [CODE]su[/CODE]
[*]TWRP [CODE]3.7.1_12-HZE1-FBE-lab-13[/CODE]
[*]FBE /data decryption with the existing Android PIN/password
[*]SID-validated synthetic-password / Gatekeeper / Keymaster CE flow
[*]Complete Android → TWRP → Android cycle
[*]Persistent custom recovery after Android boot
[*]BOOT read-back: [CODE]027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5[/CODE]
[*]RECOVERY read-back: [CODE]d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415[/CODE]
[*]YouTube RVX 20.51.39 and YouTube Music RVX 9.15.51 enabled and launch-tested
[*]Known-good banking profile produced three green Play Integrity verdicts, made T-Pay available, and accepted a card
[*]T-Bank 8.2.2 fingerprint sign-in restored without clearing app data; T-Pay and the provisioned card remained intact
[/LIST]
[/SPOILER]

[SIZE=5][B]v1.0.1 banking profile and T-Bank fingerprint note[/B][/SIZE]

[LIST]
[*]Magisk Alpha [CODE]e8a58776-alpha (30700)[/CODE]
[*]Built-in Zygisk enabled
[*]DenyList enabled
[*]Play Integrity Fork v18
[*]Tricky Store v1.4.1; the successful T-Pay result used build [CODE]248-3b07ee3[/CODE]
[/LIST]

Magisk's [B]Hide the Magisk app[/B] function is applied with a neutral random manager name/package, which is intentionally not published. Enforce DenyList remains enabled.

Shamiko 1.2.5, Vector 2.2, and Zygisk Next 1.2.9.1 are [B]disabled[/B] in the working bank-first profile. HMA 3.8.3 does not hook apps without active Vector. This is intentional: unnecessary Zygisk/Xposed hooks increased the detection surface.

Integrity Box v41 and PIF v18 share the module id [CODE]playintegrityfix[/CODE] and replace each other. Install PIF v18 directly over Integrity Box; do not uninstall Integrity Box first because its uninstaller deletes Tricky Store keybox/targets. No shared keybox, fixed fingerprint, Magisk database, banking-app data, or modified Google APK is included. Full ordering, signature checks, backup guards, and the exact Tricky Store targets are documented in [CODE]POST_INSTALL_ROOT.md[/CODE] in the repository.

[B]Separate T-Bank 8.2.2 fingerprint trigger:[/B] the app checks [CODE]/storage/emulated/0/TWRP[/CODE]. Even an empty directory removed the biometric-sign-in option while T-Pay kept working. After using recovery, run the helpers from the full package or [CODE]TBank-biometric-fix-v1.0.1.zip[/CODE]. The helper force-stops only T-Bank and moves the complete directory to a unique name under [CODE]/sdcard/RecoveryBackups[/CODE], without deleting or overwriting backups. TWRP can recreate the directory, so check it after every recovery boot. Do not clear or reinstall the banking app for this correction.

Server-side banking and Play Integrity rules may change. The successful v1.0.1 result on September 5, 2026 is not a permanent guarantee.

[SIZE=5][B]Repository and documentation[/B][/SIZE]

[URL unfurl="true"]https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE[/URL]

The repository contains RU/EN installation guides, post-install notes, build scripts, audit records, and changelogs.

[SIZE=5][B]Warning[/B][/SIZE]

Do not flash on SM-N975F, SM-N976B, d2s, d2x, another bootloader revision, or another firmware base. Never relock while custom BOOT or RECOVERY is installed.

[HR][/HR]

[SIZE=6][B]Русская версия[/B][/SIZE]

[B]Устройство:[/B] Samsung Galaxy Note10+ Snapdragon, SM-N9750 / d2q
[B]Точная база:[/B] N9750ZSU6HZE1, Android 12
[B]Статус:[/B] BOOT и RECOVERY проверены на физическом телефоне

[B]Это не кастомная прошивка.[/B] Stock One UI остаётся установленной. Для первой установки нужен полный комплект TWRP+Alpha v1.0.1. v1.0.2 — добавочное обновление только BOOT для телефона, на котором уже установлен v1.0.1.

[SIZE=5][B]Актуальное обновление: Magisk Alpha 31000 — v1.0.2[/B][/SIZE]

Установка APK Alpha 31000 обновляет приложение-manager, но не заменяет core Magisk внутри BOOT. Образ v1.0.2 обновляет core с [CODE]e8a58776-alpha (30700)[/CODE] до [CODE]96221b69-alpha (31000)[/CODE] и сохраняет [CODE]overlay.d/twrp-survival.rc[/CODE], который не даёт службе Samsung [CODE]vendor_flash_recovery[/CODE] заменить TWRP.

Это BOOT-only обновление без wipe. Оно не содержит RECOVERY, USERDATA, PIT, BL, CP, CSC или SUPER.

[SPOILER="Проверка v1.0.2 на физическом телефоне"]
[LIST]
[*]Android полностью загрузился; пользователь 0 разблокирован, CE-данные читаются
[*]Magisk сообщает [CODE]96221b69-alpha:MAGISK:R[/CODE] / [CODE]31000[/CODE]
[*][CODE]su[/CODE] работает как root в [CODE]u:r:magisk:s0[/CODE]; DenyList включён
[*]Read-back BOOT точно совпал с [CODE]3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4[/CODE]
[*]Пройден цикл Android → TWRP → Android
[*]Сохранился TWRP [CODE]3.7.1_12-HZE1-FBE-lab-13[/CODE]
[*]RECOVERY не изменился: [CODE]d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415[/CODE]
[*]После возврата в Android [CODE]vendor_flash_recovery[/CODE] остановлен
[/LIST]
[/SPOILER]

[B]Релиз и файлы v1.0.2:[/B]
[URL unfurl="true"]https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.2[/URL]

[CODE]
3e0bf40a2e4d64dce1924d37c7e06a1fb3777079d7b1ce027563ad483240f8c4  SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img
28019d0c876fb50944aedac2d27efa5917665d39adb205b35350176537e95469  AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5
f77216f829cd0185f58e4b87526544891cca562b8e71a7730856871c24265300  Magisk-Alpha-96221b69-31000.apk
7886b7a4cedae68daf03cddcec4e6f4d8cb71f9d3cb97a9ff6470f1b59a4cbfa  INSTALL_UPDATE_RU_EN.txt
[/CODE]

[SPOILER="Установка v1.0.2 через Windows / Odin 3.14.4"]
[LIST=1]
[*]Сверить загрузку по [CODE]SHA256SUMS-v1.0.2.txt[/CODE].
[*]Перейти в Download Mode и дождаться ID:COM / Added!! в Odin.
[*]Выбрать [CODE]AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5[/CODE] в поле AP.
[*]BL, CP, CSC и USERDATA оставить пустыми. Не включать Re-Partition, Nand Erase All или Flash Lock и не выбирать PIT. F. Reset Time и Auto Reboot можно оставить.
[*]Нажать Start, дождаться PASS и загрузки Android.
[*]Открыть manager Alpha и проверить core [CODE]96221b69-alpha (31000)[/CODE].
[/LIST]
[/SPOILER]

[SPOILER="Установка v1.0.2 через Linux / Heimdall"]
Из Download Mode прошить только raw-образ BOOT:
[CODE]heimdall flash --BOOT SM-N9750-HZE1-Magisk-Alpha-31000-BOOT-v1.0.2.img[/CODE]
[/SPOILER]

[B]Play Integrity и решения банковских приложений зависят от серверов и отдельно для core-only обновления v1.0.2 не проверялись.[/B] Описанный ниже банковский результат относится к контрольному профилю v1.0.1 и не является постоянной гарантией для v1.0.2.

[SIZE=5][B]Первая установка: полный базовый комплект v1.0.1[/B][/SIZE]

Первая разблокировка загрузчика Samsung всегда стирает данные и необратимо срабатывает Knox. Установка без wipe применима только к уже разблокированному телефону на точной базе HZE1.

[B]Linux / Heimdall:[/B]
[CODE]./flash-heimdall.sh --flash-no-wipe[/CODE]
прошивает BOOT+RECOVERY. Команда
[CODE]./flash-heimdall.sh --twrp-only-no-wipe[/CODE]
прошивает только RECOVERY; stock BOOT может восстановить stock recovery.

[B]Windows / Odin 3.14.4:[/B] выбрать один AP v1.0.1:
[LIST]
[*][CODE]AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5[/CODE] — BOOT+RECOVERY
[*][CODE]AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5[/CODE] — только RECOVERY
[/LIST]

BL, CP, CSC и USERDATA оставить пустыми. Отключить Auto Reboot, оставить F. Reset Time и никогда не включать Re-Partition, Nand Erase All, Flash Lock и не выбирать PIT. После зелёного PASS! принудительно выйти из Download Mode и сразу загрузить TWRP, не отключая USB.

[CODE]
aa12bed3104f48bdea7e7b18a26b72efe3f249237fbc18fdbfad9a483ec1cbd2  AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5
363f8272d86450017ae7488f9f5c28976bbfc664886159de1040339200bd4206  AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5
6d4d523e9e298717a224229d0b6f3e4bcf4141855b4eb98c913280025f549fc3  TBank-biometric-fix-v1.0.1.zip
[/CODE]

[B]Полный базовый релиз v1.0.1:[/B]
[URL unfurl="true"]https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.1[/URL]

[SPOILER="Проверка v1.0.1 на физическом телефоне"]
[LIST]
[*]Обычная загрузка Android, Magisk Alpha [CODE]e8a58776-alpha (30700)[/CODE] и работающий [CODE]su[/CODE]
[*]TWRP [CODE]3.7.1_12-HZE1-FBE-lab-13[/CODE]
[*]Расшифровка /data существующим PIN/паролем Android
[*]Проверенный SID-поток synthetic password / Gatekeeper / Keymaster CE
[*]Полный цикл Android → TWRP → Android
[*]Сохранение кастомного recovery после загрузки Android
[*]Read-back BOOT: [CODE]027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5[/CODE]
[*]Read-back RECOVERY: [CODE]d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415[/CODE]
[*]YouTube RVX 20.51.39 и YouTube Music RVX 9.15.51 включены и проверены запуском
[*]Контрольный банковский профиль дал три зелёных вердикта Play Integrity, T-Pay стал доступен, карта добавлена
[*]Вход по отпечатку в T-Bank 8.2.2 восстановлен без очистки данных приложения; T-Pay и добавленная карта сохранились
[/LIST]
[/SPOILER]

[SIZE=5][B]Банковский профиль v1.0.1 и отпечаток T-Bank[/B][/SIZE]

[LIST]
[*]Magisk Alpha [CODE]e8a58776-alpha (30700)[/CODE]
[*]Встроенный Zygisk включён
[*]DenyList включён
[*]Play Integrity Fork v18
[*]Tricky Store v1.4.1; успешный результат T-Pay получен со сборкой [CODE]248-3b07ee3[/CODE]
[/LIST]

Функция Magisk [B]Hide the Magisk app[/B] применена с нейтральным случайным именем/пакетом manager, который намеренно не публикуется. Enforce DenyList остаётся включённым.

Shamiko 1.2.5, Vector 2.2 и Zygisk Next 1.2.9.1 [B]отключены[/B] в рабочем bank-first профиле. Integrity Box v41 и PIF v18 имеют общий module id [CODE]playintegrityfix[/CODE] и заменяют друг друга. PIF v18 ставится прямо поверх Integrity Box; сначала удалять Integrity Box нельзя, потому что его деинсталлятор удаляет keybox/targets Tricky Store. Общий keybox, фиксированный fingerprint, база Magisk, данные банковских приложений и изменённые APK Google в релиз не входят. Полный порядок, проверки подписей, резервные меры и точные Tricky Store targets описаны в [CODE]POST_INSTALL_ROOT_RU.md[/CODE].

[B]Отдельный триггер отпечатка T-Bank 8.2.2:[/B] приложение проверяет [CODE]/storage/emulated/0/TWRP[/CODE]. Даже пустой каталог убирал возможность входа по отпечатку, хотя T-Pay продолжал работать. После TWRP используйте помощники из полного архива или [CODE]TBank-biometric-fix-v1.0.1.zip[/CODE]. Помощник останавливает только T-Bank и переносит весь каталог в уникальное имя внутри [CODE]/sdcard/RecoveryBackups[/CODE], не удаляя и не перезаписывая резервные копии. TWRP может создать каталог снова, поэтому проверяйте его после каждого входа в recovery. Для этого исправления не очищайте и не переустанавливайте банковское приложение.

Серверные правила банков и Play Integrity могут измениться. Успешный результат v1.0.1 от 5 сентября 2026 года не является постоянной гарантией.

[SIZE=5][B]Репозиторий и документация[/B][/SIZE]

[URL unfurl="true"]https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE[/URL]

В репозитории находятся инструкции RU/EN, post-install материалы, скрипты сборки, результаты аудита и changelog.

[SIZE=5][B]Предупреждение[/B][/SIZE]

Не прошивайте эти файлы на SM-N975F, SM-N976B, d2s, d2x, другую ревизию загрузчика или другую базовую прошивку. Никогда не блокируйте загрузчик с установленными custom BOOT или RECOVERY.

[SIZE=5][B]Support the project[/B][/SIZE]

[B]Visa T-Bank:[/B] 4377 7278 0483 9954
[B]USDT on TON:[/B] UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R

Verify the TON network and the complete address before sending. / Перед отправкой проверьте сеть TON и полный адрес.
