[SIZE=4][B]SM-N9750 HZE1: TWRP FBE + Magisk Alpha — база v1.0.1 + BOOT v1.0.2[/B][/SIZE]

[B]Устройство:[/B] Samsung Galaxy Note10+ Snapdragon, SM-N9750 / d2q
[B]Обязательная база:[/B] N9750ZSU6HZE1, Android 12
[B]Статус:[/B] базовый комплект и BOOT v1.0.2 проверены на физическом телефоне

[B]Это не custom ROM.[/B] One UI остаётся стоковой, заменяются только BOOT и
RECOVERY. /vendor не изменяется.

[SPOILER="BOOT v1.0.2 — Magisk Alpha 31000"]
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

[B]Проверено на телефоне:[/B]
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

[B]Windows / Odin 3.14.4:[/B]
[LIST=1]
[*]Сверить SHA-256 по SHA256SUMS-v1.0.2.txt.
[*]В Download Mode дождаться ID:COM / Added!!.
[*]В поле AP выбрать AP_SM-N9750_HZE1_Magisk-Alpha-31000-BOOT-only_v1.0.2.tar.md5.
[*]BL, CP, CSC и USERDATA оставить пустыми. Не включать Re-Partition, Nand Erase All и Flash Lock, не выбирать PIT. F. Reset Time и Auto Reboot можно оставить.
[*]Нажать Start, дождаться PASS и загрузки Android.
[*]Открыть manager Alpha и проверить core 96221b69-alpha (31000).
[/LIST]

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
[/SPOILER]

[SPOILER="Базовый комплект v1.0.1"]
BOOT объединяет рабочий Magisk Alpha normal boot
[CODE]e8a58776-alpha (30700)[/CODE] и
[CODE]overlay.d/twrp-survival.rc[/CODE], который на early-init останавливает
Samsung [CODE]vendor_flash_recovery[/CODE] и сохраняет TWRP. На эталонном
телефоне с этой конфигурацией T‑Pay стал доступен и карта была успешно
добавлена.
[/SPOILER]

[SPOILER="Что проверено"]
[LIST]
[*]Обычная загрузка Android, Magisk Alpha 30700 и рабочий su.
[*]TWRP 3.7.1_12-HZE1-FBE-lab-13.
[*]Расшифровка /data штатным PIN/паролем Android.
[*]SID-проверенный synthetic-password / Gatekeeper / Keymaster flow для CE-ключа пользователя 0.
[*]Полный цикл Android → TWRP → Android с Alpha-BOOT.
[*]TWRP не заменяется стоковым recovery.
[*]Read-back BOOT: 027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5.
[*]Read-back RECOVERY: d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415.
[*]YouTube ReVanced Extended 20.51.39 и YouTube Music ReVanced Extended 9.15.51 включены и запускаются.
[*]На рабочем банковском профиле: три зелёных Play Integrity, T‑Pay доступен, карта добавлена.
[*]В T‑Банке 8.2.2 восстановлен вход по отпечатку без очистки данных; T‑Pay и добавленная карта сохранились.
[/LIST]
[/SPOILER]

[SPOILER="Установка без wipe"]
[B]Важно:[/B] первая разблокировка загрузчика Samsung всегда стирает данные и
необратимо сжигает Knox. Режим no-wipe относится только к уже разблокированному
SM-N9750 на точной HZE1.

[B]Linux / Heimdall:[/B]
[CODE]./flash-heimdall.sh --flash-no-wipe[/CODE]
прошивает BOOT+RECOVERY. Команда
[CODE]./flash-heimdall.sh --twrp-only-no-wipe[/CODE]
прошивает только RECOVERY; стоковый BOOT способен восстановить stock recovery.

[B]Windows / Odin 3.14.4:[/B]
[LIST=1]
[*]Установить Samsung USB Driver, закрыть Smart Switch/Kies.
[*]Сверить SHA-256 файлов.
[*]В Download Mode дождаться ID:COM / Added!!.
[*]В поле AP выбрать один файл:
[LIST]
[*]AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5 — BOOT+RECOVERY;
[*]AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5 — только RECOVERY.
[/LIST]
[*]BL, CP, CSC и USERDATA оставить пустыми. Auto Reboot выключить, F. Reset Time оставить. Не включать Re-Partition, Nand Erase All, Flash Lock и не выбирать PIT.
[*]После зелёного PASS! удерживать Volume Down + Side/Power до чёрного экрана и сразу перейти на Volume Up + Side/Power при подключённом USB.
[/LIST]

[CODE]
aa12bed3104f48bdea7e7b18a26b72efe3f249237fbc18fdbfad9a483ec1cbd2  AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5
363f8272d86450017ae7488f9f5c28976bbfc664886159de1040339200bd4206  AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5
6d4d523e9e298717a224229d0b6f3e4bcf4141855b4eb98c913280025f549fc3  TBank-biometric-fix-v1.0.1.zip
[/CODE]

В AP-архивах нет USERDATA, SUPER, PIT, CSC или модема.

[B]Оба Odin-файла, SHA256SUMS-ODIN.txt и маленький архив с помощниками и RU/EN-инструкцией
TBank-biometric-fix-v1.0.1.zip прикреплены прямо к этому сообщению.[/B]
[/SPOILER]

[SPOILER="Рабочий банковский профиль"]
Default bank-first профиль эталонного телефона:
[LIST]
[*]Magisk Alpha e8a58776 / 30700;
[*]встроенный Zygisk включён;
[*]DenyList включён;
[*]Play Integrity Fork v18;
[*]Tricky Store v1.4.1 (успешный T‑Pay получен на build 248-3b07ee3).
[/LIST]

В Magisk выполнено «Скрыть приложение Magisk»: перепакованному manager задано
нейтральное случайное имя/пакет, которое не публикуется. Enforce DenyList
остаётся включённым.

Если на телефоне установлен официальный manager Magisk 30.7, сначала
установите/откройте Alpha из полного архива релиза и подтвердите рабочий root,
затем удалите [B]только[/B]
официальный manager командой [CODE]adb uninstall com.topjohnwu.magisk[/CODE].
Если он был скрыт под случайным пакетом, сначала восстановите имя приложения
либо удалите именно это приложение через его карточку Android. Не выбирайте
полное удаление Magisk: оно удалит root, а не только manager. Для
ADB-команды нужны актуальные Platform Tools, временная USB-отладка и
подтверждённый RSA-ключ компьютера.

Shamiko 1.2.5, Vector 2.2 и Zygisk Next 1.2.9.1 на рабочем телефоне
[B]отключены[/B]. HMA 3.8.3 без активного Vector не hook-ит приложения. Это
сделано намеренно: лишние Zygisk/Xposed hooks повышали поверхность детекта.

Integrity Box v41 и PIF v18 имеют одинаковый id [CODE]playintegrityfix[/CODE] и
заменяют друг друга. Integrity Box можно использовать для актуализации
keybox/fingerprint, затем поставить PIF v18. И установщик v41, и Action вызывают
сетевой updater, который должен писать прямо в
[CODE]/data/adb/tricky_store/keybox.xml[/CODE], но на эталонном телефоне
автоматический результат пришлось довести ручной заменой свежеполученного файла.
Поэтому до установки обязательны backup и проверка внешнего attestation-state,
а после — проверка
[CODE]/data/adb/Box-Brain/Integrity-Box-Logs/keybox.log[/CODE] и непустого нового
keybox, а не только экран завершения. Общий keybox, fingerprint, Magisk DB,
данные банка и модифицированные Google APK в релиз не входят.

PIF v18 нужно ставить прямо поверх Integrity Box, не удаляя Integrity Box
отдельно: его uninstaller удаляет keybox/targets Tricky Store. Этот PIF также
может унаследовать [CODE]uninstall.sh[/CODE] из заменяемого модуля, поэтому до
перезагрузки его нужно удалить только после проверки двух сигнатур по команде из
POST_INSTALL_ROOT_RU.md. Там же дан root-only backup итоговой конфигурации.

Для Tricky Store v1.4.1 официальный публичный build — 245. Build 248 закрыт и
недоступен из официальных источников. Все ссылки, точный порядок, targets,
DenyList и случай с VPN Hotspot / Root is missing описаны в
POST_INSTALL_ROOT_RU.md.

[CODE]
com.google.android.gms!
com.google.android.gsf
com.android.vending
com.idamob.tinkoff.android!
io.github.vvb2060.keyattestation!
[/CODE]

Это точные Tricky Store targets эталонного телефона; [CODE]![/CODE] не нужно
добавлять всем пакетам подряд.

[B]Отдельный триггер отпечатка T‑Банка 8.2.2:[/B] приложение проверяет
[CODE]/storage/emulated/0/TWRP[/CODE]. Даже пустой каталог убирал пункт
биометрического входа при рабочем T‑Pay. После использования recovery
распакуйте [CODE]TBank-biometric-fix-v1.0.1.zip[/CODE] и запустите
[CODE]fix-tbank-biometric.sh[/CODE] или [CODE]fix-tbank-biometric.ps1[/CODE]:
помощник через ADB без root остановит
только T‑Банк и перенесёт весь каталог под уникальным именем в
[CODE]/sdcard/RecoveryBackups[/CODE], ничего не удаляя и не перезаписывая.
Для помощника нужны Android Platform Tools, временно включённая USB-отладка и
принятый RSA-ключ компьютера; для самой прошивки Odin USB-отладка не нужна.
Если Windows блокирует скрипт, разово запустите
[CODE]powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\fix-tbank-biometric.ps1[/CODE]
без изменения системной политики. TWRP может создать каталог снова. Очищать
данные или переустанавливать банк для этого исправления не нужно.

Банки и Play Integrity меняют серверные правила. Успешный результат 05.09.2026
не является бессрочной гарантией.
[/SPOILER]

[B]GitHub, полный архив, исходные патчи, инструкции RU/EN и changelog:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE

[B]Актуальное обновление BOOT v1.0.2:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.2

[B]Полный базовый комплект v1.0.1:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.1

[B][COLOR=red]Нельзя прошивать на SM-N975F, SM-N976B, d2s, d2x, другую
ревизию загрузчика или другую базовую прошивку.[/COLOR][/B]
