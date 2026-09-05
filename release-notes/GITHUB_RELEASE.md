# v1.0.1 — Magisk Alpha, persistent TWRP, and the known-good banking profile

The existing v1.0.1 release was replaced in place with this complete package;
no new release was created. It supersedes the withdrawn v1.0.0 for the
Snapdragon Samsung Galaxy Note10+ `SM-N9750` on exact stock firmware
`N9750ZSU6HZE1`.

Official Magisk 30.7 provided working root and green Play Integrity verdicts,
but T-Pay still reported that the service was unavailable. On the same physical
phone, switching to Magisk Alpha `e8a58776-alpha (30700)` made T-Pay available
and a card was added successfully.

The updated BOOT combines that tested Alpha normal boot with
`overlay.d/twrp-survival.rc`. The rule stops Samsung's
`vendor_flash_recovery` service during early init so stock recovery cannot
replace TWRP.

## Verified on physical hardware

- Normal Android boot, Magisk Alpha 30700, and working `su`.
- TWRP `3.7.1_12-HZE1-FBE-lab-13`.
- Existing Android PIN/password decrypts FBE `/data`.
- Complete SID-validated synthetic-password / Gatekeeper / Keymaster CE flow.
- Full Android → TWRP → Android cycle with the updated BOOT.
- BOOT read-back SHA-256:
  `027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5`.
- RECOVERY read-back SHA-256:
  `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415`.
- YouTube ReVanced Extended `20.51.39` and YouTube Music ReVanced Extended
  `9.15.51` enabled and launch-tested on the reference phone.
- Known-good banking profile: three green Play Integrity verdicts, T-Pay
  available, and a successfully added card.
- T-Bank `8.2.2` fingerprint sign-in restored without clearing app data while
  T-Pay and the provisioned card remained intact.

## Banking-profile correction

The final bank-first profile uses Magisk Alpha, built-in Zygisk, DenyList,
Play Integrity Fork v18, and Tricky Store v1.4.1. Shamiko, Vector, Zygisk Next,
and HMA hooks are not enabled in that profile. Extra injection layers increased
the detection surface and were not required for the successful T-Pay result.
Magisk's **Hide the Magisk app** function is applied with a neutral random
manager name/package, which is intentionally not published, and Enforce
DenyList remains enabled.

Existing v1.0.1 users must first install/open Alpha from the full release
package and confirm working root,
then remove **only** the legacy official manager APK with
`adb uninstall com.topjohnwu.magisk`. If the old manager was hidden under a
random package, restore its app name first or remove that exact old app from
Android App info. Never select **Complete uninstall**: that removes Magisk/root,
not merely the obsolete manager app. The ADB command requires current Platform
Tools, temporarily enabled USB debugging, and the accepted computer RSA prompt.

The successful reference phone used Tricky Store build `248-3b07ee3`. The
author's public upstream offered build 245 when this release was prepared. This
project does not rehost the closed build 248 binary. Integrity Box v41 and PIF
v18 share the module id `playintegrityfix`; the guide explains the required
replacement order. Both the Integrity Box v41 installer and Action invoke a
network updater designed to write directly to
`/data/adb/tricky_store/keybox.xml`; the pre-install backup/guard, keybox log,
and resulting non-empty file must be verified. On the reference phone, the
freshly obtained file had to be backed up and copied to that destination
manually before reboot.
The v41 release ZIP checksum does not authenticate its later mutable network
payload; the detailed guide records its limited validation and trust boundary.
The exact Tricky Store targets were:

```text
com.google.android.gms!
com.google.android.gsf
com.android.vending
com.idamob.tinkoff.android!
io.github.vvb2060.keyattestation!
```

PIF v18 must be installed directly over Integrity Box rather than uninstalling
Integrity Box first, because the latter's uninstaller deletes Tricky Store
keybox/targets. This exact PIF installer can also inherit that old
`uninstall.sh`; the guide includes a signature-checked removal and private
backup before reboot.

T-Bank `8.2.2` also checks for `/storage/emulated/0/TWRP`. Even an empty
directory can remove fingerprint sign-in while T-Pay remains available. The
included Linux/macOS and Windows ADB helpers force-stop only T-Bank and move
the directory intact under a unique `/sdcard/RecoveryBackups/...` name. TWRP
can recreate the path, so run the helper after recovery use. The helper needs
Android Platform Tools, temporarily enabled USB debugging, and an accepted
computer RSA authorization; Odin itself does not need USB debugging. Do not
clear or reinstall the bank app for this correction.

No shared keybox, fixed fingerprint, Magisk database, banking-app data, or
modified Google APK is included. These items are private, revocable, or not
redistributable. Banking and Play Integrity server-side rules can change, so
the September 5, 2026 result is not a permanent guarantee.

## Assets

- `SM-N9750-HZE1-TWRP-Magisk-Alpha-v1.0.1.zip` — full Linux/Heimdall package,
  documentation, exact Alpha manager APK, Integrity Box v41, and PIF v18.
- `AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5` — Odin
  BOOT+RECOVERY, no USERDATA/PIT.
- `AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5` — Odin RECOVERY only.
- `SHA256SUMS-ODIN.txt` — Odin package checksums.
- `SHA256SUMS.v1.0.1` — checksums for the full package, helper archive, and
  both Odin packages.
- `TBank-biometric-fix-v1.0.1.zip` — the two non-root ADB helpers and a bilingual
  quick guide, for Odin users who did not download the full package.

```text
e6a4546c7f0959b0b78d0d23ca28888cf57fa0e30489a09c0353809cea3f8a0b  SM-N9750-HZE1-TWRP-Magisk-Alpha-v1.0.1.zip
6d4d523e9e298717a224229d0b6f3e4bcf4141855b4eb98c913280025f549fc3  TBank-biometric-fix-v1.0.1.zip
aa12bed3104f48bdea7e7b18a26b72efe3f249237fbc18fdbfad9a483ec1cbd2  AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5
363f8272d86450017ae7488f9f5c28976bbfc664886159de1040339200bd4206  AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5
```

Read `INSTALL.md` / `INSTALL_RU.md` before flashing and
`POST_INSTALL_ROOT.md` / `POST_INSTALL_ROOT_RU.md` before changing the root
profile.

Only `SM-N9750` / `d2q` / `N9750ZSU6HZE1` is supported. The first bootloader
unlock wipes data and permanently trips Knox. Never relock the bootloader while
custom BOOT or RECOVERY is installed.

---

# v1.0.1 — Magisk Alpha, постоянный TWRP и рабочий банковский профиль

Существующий релиз v1.0.1 полностью заменён на месте этим комплектом; новый
релиз не создавался. Он заменяет снятый с публикации v1.0.0 для Snapdragon
Samsung Galaxy Note10+ `SM-N9750` на точной стоковой базе `N9750ZSU6HZE1`.

Официальный Magisk 30.7 давал root и зелёный Play Integrity, но T‑Pay писал,
что сервис недоступен. На том же физическом телефоне после перехода на Magisk
Alpha `e8a58776-alpha (30700)` T‑Pay заработал и карта была успешно добавлена.

Обновлённый BOOT объединяет проверенный Alpha normal boot с
`overlay.d/twrp-survival.rc`. Правило на early-init останавливает Samsung
`vendor_flash_recovery`, поэтому стоковый recovery не заменяет TWRP.

## Проверено на телефоне

- Обычная загрузка Android, Magisk Alpha 30700 и рабочий `su`.
- TWRP `3.7.1_12-HZE1-FBE-lab-13`.
- Расшифровка FBE `/data` штатным PIN/паролем Android.
- Полный SID-проверенный synthetic-password / Gatekeeper / Keymaster CE flow.
- Цикл Android → TWRP → Android после прошивки нового BOOT.
- Read-back BOOT:
  `027447589dc1845d65d6018df5322d54b01410e939a441e0fdcf63ae9c12a8c5`.
- Read-back RECOVERY:
  `d8b050f0d342abde7339a95c5a255098a004399ff1ec78d33b0b151cf2967415`.
- YouTube ReVanced Extended `20.51.39` и YouTube Music ReVanced Extended
  `9.15.51` включены и проверены запуском.
- Рабочий банковский профиль: три зелёных Play Integrity, T‑Pay доступен,
  карта добавлена.
- В T‑Банке `8.2.2` восстановлен вход по отпечатку без очистки данных, при этом
  T‑Pay и добавленная карта сохранились.

## Исправление банковской инструкции

Фактический bank-first профиль использует Magisk Alpha, встроенный Zygisk,
DenyList, Play Integrity Fork v18 и Tricky Store v1.4.1. Shamiko, Vector,
Zygisk Next и HMA hooks в нём отключены. Лишние слои инъекции увеличивали
поверхность детекта и не потребовались для T‑Pay.
В Magisk выполнено **«Скрыть приложение Magisk»** с нейтральными случайными
именем/пакетом manager, которые намеренно не публикуются; Enforce DenyList
остаётся включённым.

Пользователям прежнего комплекта v1.0.1 нужно сначала установить/открыть Alpha
из полного архива релиза и подтвердить рабочий root, затем удалить **только**
старый официальный manager командой `adb uninstall com.topjohnwu.magisk`. Если
прежний manager был скрыт под случайным пакетом, сначала восстановите его имя
либо удалите именно это старое приложение через карточку Android. Не выбирайте
**полное удаление** — оно удаляет Magisk/root, а не только устаревший manager.
Для ADB-команды нужны актуальные Platform Tools, временная USB-отладка и
подтверждённый RSA-ключ компьютера.

Успешный результат получен с Tricky Store build `248-3b07ee3`. Публичный
upstream автора на дату подготовки релиза предлагает build 245. Закрытый build
248 проект не перепубликует. Integrity Box v41 и PIF v18 имеют общий module id
`playintegrityfix`; правильный порядок замены описан в инструкции. И установщик
Integrity Box v41, и его Action вызывают сетевой updater, который должен писать
прямо в `/data/adb/tricky_store/keybox.xml`; поэтому до установки нужны
backup/guard, а после — проверка keybox-журнала и непустого итогового файла. На
эталонном телефоне свежеполученный файл пришлось сохранить и вручную скопировать
по этому пути перед перезагрузкой. SHA-256
самого ZIP v41 не удостоверяет последующий изменяемый сетевой payload; границы
доверия и ограниченная проверка подробно описаны в инструкции. Точные Tricky
Store targets:

```text
com.google.android.gms!
com.google.android.gsf
com.android.vending
com.idamob.tinkoff.android!
io.github.vvb2060.keyattestation!
```

PIF v18 нужно ставить прямо поверх Integrity Box, не удаляя Integrity Box
отдельно: его uninstaller удаляет keybox/targets Tricky Store. Этот PIF также
может унаследовать старый `uninstall.sh`; инструкция содержит проверяемое по
двум сигнатурам удаление и закрытую резервную копию перед перезагрузкой.

T‑Банк `8.2.2` также проверяет наличие `/storage/emulated/0/TWRP`. Даже пустой
каталог может убрать вход по отпечатку при рабочем T‑Pay. Приложенные ADB-
помощники для Linux/macOS и Windows останавливают только T‑Банк и переносят
каталог целиком под уникальным именем в `/sdcard/RecoveryBackups/...`. TWRP
может создать путь снова, поэтому помощник нужно запускать после использования
recovery. Для помощника нужны Android Platform Tools, временно включённая
USB-отладка и принятый RSA-ключ компьютера; для самого Odin USB-отладка не
нужна. Очищать данные или переустанавливать банк для этого не нужно.

Общий keybox, фиксированный fingerprint, Magisk DB, данные банка и
модифицированные APK Google не включены: они приватны, отзываемы или не могут
перепубликоваться. Серверные правила банков и Play Integrity меняются, поэтому
результат от 5 сентября 2026 года не является бессрочной гарантией.

## Файлы

- `SM-N9750-HZE1-TWRP-Magisk-Alpha-v1.0.1.zip` — полный Linux/Heimdall
  комплект, документация, точный Alpha manager APK, Integrity Box v41 и PIF
  v18.
- `AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5` — Odin
  BOOT+RECOVERY без USERDATA/PIT.
- `AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5` — Odin только RECOVERY.
- `SHA256SUMS-ODIN.txt` — хэши Odin-пакетов.
- `SHA256SUMS.v1.0.1` — хэши полного комплекта, архива-помощника и обоих
  Odin-пакетов.
- `TBank-biometric-fix-v1.0.1.zip` — два ADB-помощника без root и двуязычная
  краткая инструкция для пользователей Odin, не скачивавших полный комплект.

```text
e6a4546c7f0959b0b78d0d23ca28888cf57fa0e30489a09c0353809cea3f8a0b  SM-N9750-HZE1-TWRP-Magisk-Alpha-v1.0.1.zip
6d4d523e9e298717a224229d0b6f3e4bcf4141855b4eb98c913280025f549fc3  TBank-biometric-fix-v1.0.1.zip
aa12bed3104f48bdea7e7b18a26b72efe3f249237fbc18fdbfad9a483ec1cbd2  AP_SM-N9750_HZE1_TWRP-Magisk-Alpha_v1.0.1.tar.md5
363f8272d86450017ae7488f9f5c28976bbfc664886159de1040339200bd4206  AP_SM-N9750_HZE1_TWRP-only_v1.0.1.tar.md5
```

Перед прошивкой прочитайте `INSTALL_RU.md` / `INSTALL.md`, перед изменением
root-профиля — `POST_INSTALL_ROOT_RU.md` / `POST_INSTALL_ROOT.md`.

Поддерживается только `SM-N9750` / `d2q` / `N9750ZSU6HZE1`. Первая
разблокировка загрузчика стирает данные и необратимо сжигает Knox. Нельзя
блокировать загрузчик при установленном custom BOOT или RECOVERY.

## Support / Поддержать проект

- Visa T-Bank: `4377 7278 0483 9954`
- USDT on TON / в сети TON:
  `UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R`

Verify the TON network and the complete address before sending. Перед отправкой
проверьте сеть TON и весь адрес.
