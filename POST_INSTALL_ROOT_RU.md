# Рабочий root/банковский профиль v1.0.1

Это описание фактической конфигурации эталонного `SM-N9750`, а не список
«поставьте всё подряд». Именно минимизация активных хуков помогла получить
рабочий T‑Pay.

## Подтверждённое состояние 5 сентября 2026 года

- Magisk Alpha `e8a58776-alpha`, version code `30700`;
- встроенный Zygisk: включён;
- DenyList: включён;
- активны Play Integrity Fork `v18` и Tricky Store `v1.4.1`;
- на телефоне, где T‑Pay заработал и была добавлена карта, стоял Tricky Store
  build `248-3b07ee3`;
- Shamiko `1.2.5`, Vector `2.2` и Zygisk Next `1.2.9.1` установлены, но
  отключены;
- HMA `3.8.3` установлен, но без активного Vector его hooks не работают;
- Play Integrity дал три зелёных результата;
- T‑Pay стал доступен после замены официального Magisk 30.7 на Alpha;
- в T‑Банке `8.2.2` одновременно проверены T‑Pay, добавленная карта и вход по
  отпечатку после устранения каталога-триггера `/sdcard/TWRP`.

Официальный публичный upstream Tricky Store на дату релиза предлагает
`v1.4.1 build 245`. Он загружается только со страницы автора. Закрытый бинарник
build 248 проект повторно не публикует.

## Почему не включены все модули одновременно

Shamiko, Zygisk Next, Vector и HMA полезны в других сценариях, но каждый
добавляет ещё один runtime hook и ещё один сигнал для банковского приложения.
На эталонном телефоне T‑Pay заработал без них. Поэтому v1.0.1 использует
bank-first профиль: Alpha + встроенный Zygisk + PIF + Tricky Store.

Integrity Box v41 и Play Integrity Fork v18 имеют одинаковый module id
`playintegrityfix`; одновременно активными они быть не могут. Integrity Box
можно временно использовать для обновления keybox/fingerprint. Не удаляйте его
перед переходом на PIF: uninstall-скрипт именно этой версии Integrity Box
удаляет `keybox.xml` и `target.txt` Tricky Store. После сохранения итоговой
конфигурации ставьте PIF v18 прямо поверх того же module id.

## Порядок настройки после прошивки

1. Установите точный `Magisk-Alpha-e8a58776-30700.apk` из релиза. При обновлении
   со старого официального manager 30.7 сначала откройте Alpha и подтвердите
   root, затем удалите только прежний APK командой
   `adb uninstall com.topjohnwu.magisk`. Если он был скрыт, сначала восстановите
   старое имя приложения либо удалите точно определённое старое приложение из
   карточки Android. Не угадывайте случайный пакет и не выбирайте полное
   удаление Magisk/root.
2. В Alpha выполните **Скрыть приложение Magisk**, задайте перепакованному
   manager нейтральные случайные имя/пакет и нигде не публикуйте получившееся
   имя пакета. Затем включите встроенный Zygisk и **Enforce DenyList** и
   перезагрузитесь.
3. Установите Tricky Store только из
   [официального upstream](https://github.com/5ec1cff/TrickyStore/releases/tag/1.4.1).
4. Если обновление keybox действительно требуется, сначала остановитесь при
   наличии внешней конфигурации OMK или TEE Simulator:

   ```bash
   adb shell su -c 'if [ -d /data/misc/keystore/omk ] || [ -d /data/adb/teesim ] || [ -d /data/adb/tricky_store/persistent_keys ]; then echo EXTERNAL_OR_PERSISTENT_ATTESTATION_STATE_PRESENT_ABORT_INSTALL_OR_ACTION; exit 76; else echo OK_NO_EXTERNAL_ATTESTATION_STATE; fi'
   ```

   Установщик Integrity Box и Action оба вызывают его key updater. Он
   переписывает файлы OMK/TEE Simulator и удаляет/создаёт заново
   `persistent_keys`, если эти пути существуют, а очистка при переходе на PIF
   их не восстанавливает. Владельцы, SELinux-контекст и формат отката зависят
   от конкретного модуля, поэтому инструкция не делает небезопасный
   универсальный restore. Если проверка завершилась словом
   `ABORT_INSTALL_OR_ACTION`, остановитесь и сначала используйте штатную
   процедуру backup/restore автора соответствующего attestation-модуля.

   Затем сохраните текущие файлы Tricky Store **до установки или запуска
   Integrity Box** в закрытый root-only каталог:

   ```bash
   adb shell su -c 'set -e; r=/data/adb/tricky_store; d="$r/private-backups"; mkdir -p "$d"; chmod 0700 "$d"; t=$(date +%Y%m%d-%H%M%S); for f in keybox.xml target.txt security_patch.txt; do s="$r/$f"; if [ -e "$s" ]; then b="$d/$f.pre-integrity-box.$t"; [ ! -e "$b" ]; cp -p "$s" "$b"; cmp -s "$s" "$b"; fi; done; echo PRE_ACTION_BACKUP_OK_$t'
   ```

   Установщик Integrity Box и Action не ограничены keybox: они очищают кэши
   ключей Tricky Store и могут переписать fingerprint, `target.txt`,
   `security_patch.txt`, системное значение security patch и конфигурации
   OMK/TEE Simulator.
5. Обеспечьте стабильный Интернет и решите, что доверяете текущему endpoint
   издателя, **до установки** Integrity Box v41: установщик сразу вызывает тот
   же сетевой key updater и может изменить перечисленные файлы. Установщик не
   останавливается гарантированно при ошибке этого helper, поэтому сообщение
   `Installation Completed` не доказывает обновление keybox. Перезагрузитесь и
   проверьте, что поле `name=` в
   `/data/adb/modules/playintegrityfix/module.prop` теперь относится именно к
   Integrity Box. Если обновление всё ещё требуется, только после загрузки
   активного Integrity Box и при стабильном Интернете один раз выполните Action.
6. В v41 нет готового keybox. И установщик, и Action получают изменяемый
   закодированный payload с сервера издателя, сохраняют прежний файл в
   `/data/adb/Box-Brain/KeyBackup`, затем пытаются записать декодированный
   результат прямо в `/data/adb/tricky_store/keybox.xml`. SHA-256 релизного ZIP
   не удостоверяет этот последующий сетевой payload. v41 также отключает
   проверку TLS-сертификата при загрузке и проверяет только непустой результат,
   но не структуру XML/сертификатов, подпись, свежесть или статус отзыва.
   Запускайте операцию только если доверяете издателю и текущему содержимому его
   endpoint.
7. Проверьте последний запуск updater из установщика/Action, а не только его
   экранное сообщение:

   ```bash
   adb shell su -c 'grep -E "^(name|version)=" /data/adb/modules/playintegrityfix/module.prop'
   adb shell su -c 'tail -n 30 /data/adb/Box-Brain/Integrity-Box-Logs/keybox.log | grep -E "Keybox successfully updated|ERROR:"'
   adb shell su -c 'if [ -s /data/adb/tricky_store/keybox.xml ]; then ls -ln /data/adb/tricky_store/keybox.xml; else echo MISSING_OR_EMPTY; fi'
   ```

   Строка успеха и непустой файл подтверждают только выполнение updater, но не
   валидность, неотозванность или принятие keybox Google. Значок Strong/Device
   в WebUI берётся из отдельного удалённого status-файла и не проверяет
   локальный keybox. На эталонном телефоне автоматический updater не оставил в
   Tricky Store нужный актуальный файл, поэтому свежеполученный файл был
   сохранён и вручную скопирован именно по этому пути.
8. После установщика/Action заново задайте точные Tricky Store targets ниже:
   любой из этих путей может переписать `target.txt`. Сохраните итоговые
   `keybox.xml`, `target.txt` и `security_patch.txt` под уникальными именами в
   закрытом root-only каталоге вне `/data/adb/Box-Brain`.
9. Установите PIF v18 прямо поверх Integrity Box, не удаляя Integrity Box
   отдельно. До перезагрузки выполните fail-closed проверку: унаследованный
   uninstall-скрипт Integrity Box удаляется, только если подготовленный модуль
   имеет точные имя/версию PIF v18, а скрипт содержит сигнатуру Integrity Box. При
   отсутствующем или неожиданном состоянии команда аварийно остановится:

   ```bash
   adb shell su -c 'set -e; p=/data/adb/modules_update/playintegrityfix; [ -f "$p/module.prop" ] || { echo MISSING_STAGED_PIF_ABORT >&2; exit 71; }; grep -q "^name=Play Integrity Fork$" "$p/module.prop" && grep -q "^version=v18$" "$p/module.prop" && grep -q "^versionCode=180000$" "$p/module.prop" || { echo NOT_EXACT_STAGED_PIF_V18_ABORT >&2; exit 72; }; u="$p/uninstall.sh"; if [ -e "$u" ]; then if grep -q "Integrity-Box Uninstall Started" "$u"; then rm -f "$u"; else echo UNKNOWN_UNINSTALLER_ABORT >&2; exit 73; fi; fi; [ ! -e "$u" ] || { echo UNINSTALLER_REMOVE_FAILED_ABORT >&2; exit 74; }; echo STAGED_PIF_V18_UNINSTALLER_SAFE'
   ```

   Не перезагружайтесь, пока команда не напечатает
   `STAGED_PIF_V18_UNINSTALLER_SAFE` и не завершится успешно. Иначе установщик
   именно этого PIF копирует `uninstall.sh` прежнего модуля, и последующее
   удаление PIF может снести keybox и targets Tricky Store. После перезагрузки
   проверьте активный PIF v18, сохранность файлов Tricky Store и аварийно
   завершите проверку при наличии любого uninstall-скрипта:

   ```bash
   adb shell su -c 'set -e; p=/data/adb/modules/playintegrityfix; grep -q "^name=Play Integrity Fork$" "$p/module.prop" && grep -q "^version=v18$" "$p/module.prop" && grep -q "^versionCode=180000$" "$p/module.prop" || { echo ACTIVE_MODULE_IS_NOT_EXACT_PIF_V18_ABORT >&2; exit 75; }; [ -s /data/adb/tricky_store/keybox.xml ] || { echo KEYBOX_MISSING_ABORT >&2; exit 76; }; [ -s /data/adb/tricky_store/target.txt ] || { echo TARGETS_MISSING_ABORT >&2; exit 77; }; [ ! -e "$p/uninstall.sh" ] || { echo UNSAFE_OR_UNKNOWN_UNINSTALLER_ABORT >&2; exit 78; }; echo OK_ACTIVE_PIF_V18_NO_UNINSTALLER'
   ```
10. Не копируйте общий keybox/fingerprint из этой инструкции: актуальный
    материал приватен и может быть отозван удалённо. Не включайте Export Keybox
    в Integrity Box без необходимости: он создаёт `/sdcard/keybox.xml` в общей
    памяти.

Если ручная замена действительно нужна и свежий доверенный файл уже находится
на вашем компьютере, сохраните старый вне `Box-Brain` и установите только этот
известный файл:

```bash
adb push /путь/к/current-keybox.xml /data/local/tmp/current-keybox.xml
adb shell su -c 'set -e; s=/data/local/tmp/current-keybox.xml; k=/data/adb/tricky_store/keybox.xml; [ -s "$s" ]; d=/data/adb/tricky_store/private-backups; mkdir -p "$d"; chmod 0700 "$d"; t=$(date +%Y%m%d-%H%M%S); b="$d/keybox-manual-before.$t.xml"; [ ! -e "$b" ]; if [ -e "$k" ]; then cp -p "$k" "$b"; cmp -s "$k" "$b"; fi; cp -f "$s" "$k"; chown 0:0 "$k"; chmod 0600 "$k"; cmp -s "$s" "$k"; sync; rm -f "$s"'
```

Проверьте, что целевой файл существует и не пуст, затем перезагрузитесь. Сам
keybox нельзя вставлять, загружать или прикладывать к issue/сообщению форума.

Минимальные цели Tricky Store для банковского профиля:

```text
com.google.android.gms!
com.google.android.gsf
com.android.vending
com.idamob.tinkoff.android!
io.github.vvb2060.keyattestation!
```

Суффикс `!` принудительно включает generate-certificate mode. Три строки с
суффиксом выше — точная конфигурация эталонного телефона; не добавляйте `!` ко
всем пакетам подряд.

Чтобы заменить созданный Action список именно этим проверенным набором,
используйте атомарную запись с предварительной резервной копией. Временная
копия и установленный файл сверяются побайтно; любая ошибка даёт ненулевой код:

```bash
adb shell su -c 'set -e; r=/data/adb/tricky_store; d="$r/private-backups"; mkdir -p "$d"; chmod 0700 "$d"; o="$r/target.txt"; t=$(date +%Y%m%d-%H%M%S); if [ -e "$o" ]; then b="$d/target.before-tested-set.$t.txt"; [ ! -e "$b" ]; cp -p "$o" "$b"; cmp -s "$o" "$b"; fi; n="$r/.target.new.$$"; v="$r/.target.verify.$$"; trap "rm -f \"$n\" \"$v\"" 0 1 2 3 15; printf "%s\n" "com.google.android.gms!" "com.google.android.gsf" "com.android.vending" "com.idamob.tinkoff.android!" "io.github.vvb2060.keyattestation!" > "$n"; [ "$(wc -l < "$n")" -eq 5 ]; cp -p "$n" "$v"; cmp -s "$n" "$v"; chown 0:0 "$n"; chmod 0600 "$n"; mv -f "$n" "$o"; cmp -s "$o" "$v"; echo TARGETS_ATOMIC_WRITE_OK'
```

Перед установкой PIF поверх Integrity Box сохраните итоговые файлы Tricky Store
вне `Box-Brain` (очистка при переходе удаляет `Box-Brain`):

```bash
adb shell su -c 'set -e; r=/data/adb/tricky_store; [ -s "$r/keybox.xml" ]; [ -s "$r/target.txt" ]; d="$r/private-backups"; mkdir -p "$d"; chmod 0700 "$d"; t=$(date +%Y%m%d-%H%M%S); for f in keybox.xml target.txt security_patch.txt; do s="$r/$f"; if [ -e "$s" ]; then b="$d/$f.$t"; [ ! -e "$b" ]; cp -p "$s" "$b"; cmp -s "$s" "$b"; fi; done'
```

Минимальный DenyList эталонного профиля:

```text
com.idamob.tinkoff.android | com.idamob.tinkoff.android
com.google.android.gsf | com.google.android.gsf
isolated | com.android.vending:isolated_service:com.google.android.finsky.verifier.apkanalysis.service.ApkContentsScanService
isolated | com.google.android.gms:com.google.android.gms.chimera.IsolatedBoundBrokerService
```

Для этого профиля **Enforce DenyList должен быть включён**, а
`com.idamob.tinkoff.android` должен оставаться в списке. Shamiko отключён. В
проверенном Shamiko-режиме банковское приложение дополнительно видело
`/system_ext/bin/su`, поэтому замена Enforce DenyList на Shamiko не решила
задачу.

Не добавляйте в DenyList приложения, которым нужен root. Например,
`be.mygod.vpnhotspot` после этого пишет `Root is missing`, даже если в Magisk
для него стоит `ALLOW`.

Если T‑Pay и карты уже работают, **не очищайте данные и не переустанавливайте
T‑Банк**: это удаляет локальный вход и может потребовать заново активировать
платёжные токены. Эта инструкция вообще не использует очистку банковского
приложения как шаг диагностики. Очистка Google Play Store относится только к
отдельной диагностике Play Integrity и не означает разрешение очистить T‑Банк.

## Почему может исчезнуть вход по отпечатку

В T‑Банке `8.2.2` проверка MIAF явно ищет
`/storage/emulated/0/TWRP` (`/sdcard/TWRP`). Достаточно даже пустого каталога:
T‑Pay при этом может продолжать работать, но пункт биометрического входа
исчезает. На эталонном телефоне каталог был переименован без очистки данных
банка, после чего пользователь подтвердил одновременно рабочие T‑Pay и вход по
отпечатку.

TWRP может создать этот каталог снова. После каждого запуска recovery и до
первого запуска банка выполните один из приложенных скриптов:

```bash
./scripts/fix-tbank-biometric.sh
```

```powershell
.\scripts\fix-tbank-biometric.ps1
```

Для помощников нужны актуальные Android Platform Tools. Сам Odin не требует
USB-отладки, но помощник требует: загрузите Android, временно включите отладку
по USB, подключите кабель, разблокируйте телефон и подтвердите RSA-ключ этого
компьютера. Команда `adb devices` должна показывать ровно одно устройство со
статусом `device`, а не `unauthorized`. Если Windows блокирует запуск скрипта
политикой PowerShell, используйте разовый обход только для этого процесса, не
меняя системную политику:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\fix-tbank-biometric.ps1
```

Скрипт не удаляет резервные копии: он останавливает только T‑Банк и переносит
весь каталог в уникальный
`/sdcard/RecoveryBackups/TWRP-ГГГГММДД-ЧЧММСС`. Для ручного исправления:

```bash
adb shell am force-stop com.idamob.tinkoff.android
adb shell mkdir -p /sdcard/RecoveryBackups
adb shell mv /sdcard/TWRP /sdcard/RecoveryBackups/TWRP-manual
```

Если `TWRP-manual` уже существует, выберите другое имя — ничего не
перезаписывайте. Перед восстановлением старой TWRP-копии каталог можно временно
вернуть на место; после выхода из recovery уберите `/sdcard/TWRP` снова.

## YouTube и YouTube Music

На эталонном телефоне снова включены и проверены запуском:

- YouTube ReVanced Extended `20.51.39`;
- YouTube Music ReVanced Extended `9.15.51`.

Они установлены как обычные data-приложения, поэтому их Magisk-модули в
bank-first профиле можно оставить отключёнными. Это уменьшает число системных
mount/hook-следов и не удаляет сами приложения. Модифицированные APK проект не
распространяет; используйте только upstream
[MANCrimSon/YouTube-ReVanced-Extended](https://github.com/MANCrimSon/YouTube-ReVanced-Extended/releases).

## Проверка

```bash
adb shell su -c 'magisk -v'
adb shell su -c 'magisk -V'
adb shell su -c 'magisk --denylist ls'
adb shell su -c 'grep -E "^(name|version|versionCode)=" /data/adb/modules/playintegrityfix/module.prop'
adb shell su -c 'grep -E "^(name|version|versionCode)=" /data/adb/modules/tricky_store/module.prop'
```

Ожидаются Alpha `e8a58776`, code `30700`, PIF `v18`, Tricky Store `v1.4.1`,
Zygisk и DenyList включены. Зелёный Play Integrity не является гарантией
конкретного банка: T‑Pay дополнительно проверяет собственные сигналы, включая
доступные приложению следы в общей памяти.
