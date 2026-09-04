# v1.0.0 — device-tested HZE1 FBE recovery and normal-boot Magisk

First public, physical-device-tested release for the Snapdragon Samsung Galaxy
Note10+ `SM-N9750` on exact stock firmware `N9750ZSU6HZE1`.

## Highlights

- TWRP `3.7.1_12-HZE1-FBE-lab-13`.
- Existing Android PIN/password decrypts FBE `/data`.
- Correct two-stage synthetic-password Gatekeeper flow and SID-validated HAT
  for authenticated Keymaster CE-key decryption.
- Magisk 30.7 in the normal Android boot path; no special boot key combination.
- Custom recovery survives normal Android boot without modifying `/vendor`.
- BOOT and RECOVERY hashes verified by reading the partitions back from the
  physical device.

## Assets

- `SM-N9750-HZE1-Magisk-v30.7-BOOT-v1.0.0.img`
- `SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.0.img`
- `SM-N9750-HZE1-TWRP-Magisk-v1.0.0.zip`
- `device-samsung-d2q-HZE1-lab13.tar.zst`
- `SHA256SUMS`

Read `INSTALL.md` or `INSTALL_RU.md` before flashing.

## Compatibility warning

Only `SM-N9750` / `d2q` / `N9750ZSU6HZE1` is supported. Do not flash on
`SM-N975F`, `SM-N976B`, another model, or another base firmware. Bootloader
unlock wipes data and permanently trips Knox.

---

# v1.0.0 — проверенные на устройстве TWRP с FBE и Magisk при обычной загрузке

Первый публичный релиз для Snapdragon Samsung Galaxy Note10+ `SM-N9750` на
строго определённой стоковой прошивке `N9750ZSU6HZE1`, проверенный на физическом
телефоне.

## Главное

- TWRP `3.7.1_12-HZE1-FBE-lab-13`.
- Штатный Android PIN/пароль расшифровывает FBE-раздел `/data`.
- Реализован правильный двухэтапный Gatekeeper synthetic-password flow и
  проверка HAT по SID для авторизованной расшифровки CE-ключа через Keymaster.
- Magisk 30.7 работает при обычной загрузке Android, без специальной комбинации
  клавиш.
- TWRP сохраняется после загрузки Android без изменения `/vendor`.
- Хэши BOOT и RECOVERY проверены чтением разделов обратно с физического
  устройства.

## Файлы

- `SM-N9750-HZE1-Magisk-v30.7-BOOT-v1.0.0.img`
- `SM-N9750-HZE1-TWRP-3.7.1_12-FBE-v1.0.0.img`
- `SM-N9750-HZE1-TWRP-Magisk-v1.0.0.zip`
- `device-samsung-d2q-HZE1-lab13.tar.zst`
- `SHA256SUMS`

Перед прошивкой прочитайте `INSTALL_RU.md` или `INSTALL.md`.

## Предупреждение о совместимости

Поддерживается только `SM-N9750` / `d2q` / `N9750ZSU6HZE1`. Не прошивайте на
`SM-N975F`, `SM-N976B`, другую модель или другую базовую прошивку. Разблокировка
загрузчика стирает данные и необратимо сжигает Knox.

## Support / Поддержать проект

- Visa T-Bank: `4377 7278 0483 9954`
- USDT on TON / в сети TON:
  `UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R`

Verify the TON network and the complete address before sending. Перед отправкой
проверьте сеть `TON` и весь адрес посимвольно.
