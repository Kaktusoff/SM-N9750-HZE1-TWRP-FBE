# История изменений

## v1.0.0 — 2026-09-04

Первый публичный релиз, полностью проверенный на физическом устройстве.

### Recovery и расшифровка FBE

- TWRP 3.7.1_12 собран из зафиксированных исходников Android 12.1 под точную
  геометрию recovery HZE1 и штатный аппаратный стек телефона.
- Реализован отсутствовавший двухэтапный Samsung/Qualcomm-процесс synthetic
  password:
  - HAT от пользовательского PIN/пароля открывает synthetic-password blob;
  - отдельно вычисляется credential `sp-gk-authentication`;
  - проверяется Gatekeeper handle synthetic password основного пользователя;
  - второй HAT сохраняется и проверяется по Secure User ID;
  - SID-совместимый HAT авторизует расшифровку CE-ключа через Keymaster.
- Добавлена совместимость с Android 12 KeyMint/Keymaster в HZE1.
- Удалён недоступный старый путь `keystore_auth`, при этом сохранены нужные HZE1
  службы `keystore2`, Gatekeeper, Keymaster и qseecomd.
- Добавлены recovery HIDL-зависимости для Qualcomm QSEECom.
- На реальном телефоне подтверждена расшифровка `/data` пользователя 0 штатным
  Android PIN/паролем.

### Обычная загрузка и сохранение TWRP

- Точный BOOT из работающей HZE1 обработан официальными скриптами Magisk 30.7.
- Root работает при обычной загрузке: `RECOVERYMODE=false`, `LEGACYSAR=true`,
  `PREINITDEVICE=cache`, `KEEPVERITY=true`, `KEEPFORCEENCRYPT=true`.
- Сохранены геометрия BOOT и встроенный vbmeta descriptor; Magisk устанавливает
  AVB flags 3 для разблокированного загрузчика.
- Добавлен `overlay.d/twrp-survival.rc`: он останавливает Samsung-службу
  `vendor_flash_recovery` на early-init без изменения `/vendor`.
- Подтверждены обычная загрузка Android, рабочий `su` и сохранение lab13 TWRP
  после загрузки системы.

### Проверка результата

- SHA-256 раздела BOOT, считанного обратно с телефона, совпадает с релизом.
- SHA-256 раздела RECOVERY после обычной загрузки Android совпадает с релизом.
- После Android TWRP снова загружен и сообщил версию lab13.
