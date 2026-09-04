# Samsung Galaxy Note10+ SM-N9750 HZE1: TWRP FBE + Magisk

**[Русский](README_RU.md)** · [English](README.md)

Неофициальный, проверенный на реальном устройстве комплект TWRP 3.7.1_12 и
Magisk 30.7 для Snapdragon-версии Samsung Galaxy Note10+ `SM-N9750` на строго
определённой стоковой прошивке `N9750ZSU6HZE1` (Android 12).

Это не custom ROM: система One UI остаётся стоковой. Меняются только разделы
`BOOT` и `RECOVERY`.

## Что уже проверено

Релиз `v1.0.1` использует те же проверенные на устройстве образы, что и v1.0.0,
и добавляет явные защищённые режимы установки без wipe:

- Android HZE1 загружается обычным нажатием питания, без комбинаций клавиш;
- Magisk 30.7 и `su` работают при обычной загрузке;
- запускается TWRP `3.7.1_12-HZE1-FBE-lab-13`;
- штатный PIN Android расшифровывает `/data` в TWRP;
- CE-хранилище пользователя 0 открывается через проверенный по SID HAT;
- Android больше не восстанавливает стоковый recovery;
- хэши BOOT и RECOVERY, считанные с телефона, совпадают с релизом.
- `--flash-no-wipe` прошивает проверенную пару BOOT+RECOVERY, не затрагивая
  `USERDATA`, если загрузчик уже разблокирован;
- `--twrp-only-no-wipe` прошивает только RECOVERY и предупреждает, что стоковый
  BOOT может восстановить стоковый recovery после запуска Android.

## Совместимость

Комплект предназначен только для:

- модели `SM-N9750`;
- устройства `d2q`, Snapdragon;
- прошивки `N9750ZSU6HZE1`;
- Android 12 / API 31.

Не прошивать на `SM-N975F`, `SM-N976B`, `d2s`, `d2x`, другую ревизию
загрузчика или другую базовую прошивку.

Полная инструкция: [INSTALL_RU.md](INSTALL_RU.md). Настройка root и скрытия:
[POST_INSTALL_ROOT_RU.md](POST_INSTALL_ROOT_RU.md). Технический журнал:
[BUILD_AUDIT.md](BUILD_AUDIT.md). История изменений:
[CHANGELOG_RU.md](CHANGELOG_RU.md).

## Важное предупреждение

Разблокировка загрузчика стирает пользовательские данные и необратимо сжигает
Knox. Samsung Pay, Secure Folder и другие Knox-функции могут не восстановиться
даже после возврата на сток. Перед началом нужен отдельный офлайн-backup.
Если загрузчик уже разблокирован, прошивка точных опубликованных образов BOOT и
RECOVERY сама по себе не стирает `USERDATA`.

## Проверенный дополнительный набор

- Integrity Box v41 + Tricky Store v1.4.1 (248);
- Shamiko v1.2.5 (414), blacklist mode;
- Vector v2.2 (3080) + HMA 3.8.3;
- YouTube ReVanced Extended 20.51.39;
- YouTube Music ReVanced Extended 9.15.51.

Сторонние модули и модифицированные Google APK не включены в релиз. Они
устанавливаются только из официальных источников по
[POST_INSTALL_ROOT_RU.md](POST_INSTALL_ROOT_RU.md).

## Поддержать проект

- Visa T-Bank: `4377 7278 0483 9954`
- USDT в сети TON: `UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R`

Перед отправкой USDT проверьте сеть `TON` и весь адрес посимвольно. Подробнее:
[DONATE.md](DONATE.md).
