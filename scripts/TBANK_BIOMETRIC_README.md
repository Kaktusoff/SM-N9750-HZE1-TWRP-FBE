# T-Bank biometric helper / Помощник входа по отпечатку T‑Банка

These helpers address the confirmed T-Bank `8.2.2` filesystem trigger on the
reference SM-N9750: even an empty `/storage/emulated/0/TWRP` (`/sdcard/TWRP`)
can hide fingerprint sign-in while T-Pay continues to work.

Помощники устраняют подтверждённый на эталонном SM-N9750 файловый триггер
T‑Банка `8.2.2`: даже пустой `/storage/emulated/0/TWRP` (`/sdcard/TWRP`) может
убрать вход по отпечатку при продолжающем работать T‑Pay.

## Before running / Перед запуском

- Install current Android Platform Tools (`adb`).
- Boot Android and temporarily enable USB debugging. Odin itself does not need
  USB debugging; this post-recovery helper does.
- Connect and unlock the phone, accept the computer RSA prompt, and confirm
  that `adb devices` shows exactly one device as `device`, not `unauthorized`.
- Do not clear or reinstall T-Bank while T-Pay/cards work.

- Установите актуальные Android Platform Tools (`adb`).
- Загрузите Android и временно включите USB-отладку. Самому Odin она не нужна;
  она нужна этому помощнику после recovery.
- Подключите и разблокируйте телефон, подтвердите RSA-ключ компьютера и
  убедитесь, что `adb devices` показывает ровно одно устройство со статусом
  `device`, а не `unauthorized`.
- Не очищайте и не переустанавливайте T‑Банк, пока работают T‑Pay/карты.

## Linux/macOS

```bash
chmod +x fix-tbank-biometric.sh
./fix-tbank-biometric.sh
```

## Windows PowerShell

```powershell
.\fix-tbank-biometric.ps1
```

If execution policy blocks it, use a one-process bypass without changing the
system policy / Если мешает политика PowerShell, используйте разовый обход без
изменения системной политики:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\fix-tbank-biometric.ps1
```

The helper uses ADB without root, force-stops only
`com.idamob.tinkoff.android`, and moves the complete `/sdcard/TWRP` directory
without overwriting it to a unique
`/sdcard/RecoveryBackups/TWRP-YYYYMMDD-HHMMSS` path. It never clears app data or
deletes backups. Open T-Bank manually afterwards and test fingerprint sign-in.

Помощник работает через ADB без root, останавливает только
`com.idamob.tinkoff.android` и без перезаписи переносит весь `/sdcard/TWRP` под
уникальным именем `/sdcard/RecoveryBackups/TWRP-ГГГГММДД-ЧЧММСС`. Он не
очищает данные приложения и не удаляет резервные копии. После выполнения
откройте T‑Банк вручную и проверьте вход по отпечатку.

TWRP can recreate `/sdcard/TWRP`; rerun the helper after every recovery use and
before opening T-Bank. / TWRP может создать `/sdcard/TWRP` снова; повторяйте
проверку после каждого recovery и до запуска T‑Банка.
