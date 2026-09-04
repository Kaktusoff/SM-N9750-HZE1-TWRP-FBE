[SIZE=4][B]TWRP 3.7.1_12 с рабочей FBE + Magisk 30.7 для SM-N9750 HZE1 — v1.0.1[/B][/SIZE]

[B]Устройство:[/B] Samsung Galaxy Note10+ Snapdragon, SM-N9750 / d2q
[B]Обязательная база:[/B] N9750ZSU6HZE1, Android 12
[B]Статус:[/B] проверено на реальном телефоне

[B]Это не custom ROM.[/B] One UI остаётся стоковой, заменяются только BOOT и
RECOVERY.

[SPOILER="Что работает"]
[LIST]
[*]Обычная загрузка Android с Magisk 30.7 и рабочим su, без комбинаций клавиш.
[*]TWRP 3.7.1_12-HZE1-FBE-lab-13.
[*]Расшифровка /data штатным PIN/паролем Android.
[*]Расшифровка CE-ключа пользователя 0 через проверенный по SID synthetic-password HAT.
[*]TWRP не заменяется стоковым recovery после загрузки Android.
[*]Хэши BOOT и RECOVERY проверены обратным чтением разделов телефона.
[/LIST]
[/SPOILER]

[SPOILER="Поддержать проект"]
[B]Visa T-Bank:[/B] 4377 7278 0483 9954
[B]USDT в сети TON:[/B] UQAT_xqILzlNaVgnkqqpHC2v5MouL6jdhZArOAmE6TeJjo3R

Перед отправкой USDT обязательно проверьте сеть TON и весь адрес посимвольно.
[/SPOILER]

[SPOILER="Что исправлено"]
Стоковая HZE1 использует два разных Gatekeeper-домена. Первый HAT открывает
synthetic-password blob. После этого recovery должен отдельно вывести
sp-gk-authentication credential, проверить handle пользователя 0, получить
второй HAT, сверить его SID и только затем авторизовать CE Keymaster. В lab13
реализована вся цепочка.

В BOOT добавлено Magisk overlay.d-правило, которое на early-init останавливает
Samsung-службу vendor_flash_recovery. Поэтому recovery-from-boot.p больше не
перезаписывает TWRP; /vendor не изменяется.
[/SPOILER]

[SPOILER="Установка со стока"]
[LIST=1]
[*]Сделать полный backup. Разблокировка загрузчика стирает данные и навсегда сжигает Knox.
[*]Проверить модель SM-N9750 и сборку N9750ZSU6HZE1.
[*]Проверить SHA256SUMS из релиза.
[*]Перевести телефон в Download Mode.
[*]Запустить flash-heimdall.sh --flash-no-wipe либо прошить опубликованные BOOT и RECOVERY одной командой Heimdall с --no-reboot. При уже разблокированном загрузчике USERDATA не затрагивается.
[*]После успешной прошивки удерживать Volume Down + Side/Power до погасания экрана и сразу переключиться на Volume Up + Side/Power при подключённом USB.
[*]В TWRP ввести штатный PIN Android и проверить расшифрованную внутреннюю память.
[*]Reboot System, затем установить официальный APK Magisk 30.7.
[/LIST]

[B]Режим только TWRP без wipe:[/B] если загрузчик уже разблокирован, команда
[CODE]./flash-heimdall.sh --twrp-only-no-wipe[/CODE]
прошивает только RECOVERY и не меняет BOOT или USERDATA. На полностью стоковом
BOOT Samsung может восстановить стоковый recovery после следующего запуска
Android. Для постоянного TWRP и Magisk используйте
[CODE]./flash-heimdall.sh --flash-no-wipe[/CODE]
Первая разблокировка загрузчика Samsung всегда стирает данные — обойти это
данным комплектом нельзя.
[/SPOILER]

[B]GitHub, исходные патчи, подробные инструкции и changelog:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE

[B]Готовый релиз v1.0.1:[/B]
https://github.com/Kaktusoff/SM-N9750-HZE1-TWRP-FBE/releases/tag/v1.0.1

[B][COLOR=red]Нельзя прошивать на SM-N975F, SM-N976B, d2s, d2x, другую
ревизию загрузчика или другую базовую прошивку.[/COLOR][/B]

[SPOILER="Проверенный дополнительный набор"]
Integrity Box v41 + Tricky Store v1.4.1 (248), Shamiko v1.2.5 (414), Vector
v2.2 (3080) + HMA 3.8.3, YouTube ReVanced Extended 20.51.39 и YouTube Music
ReVanced Extended 9.15.51.

Сами сторонние APK/модули в релиз не включены. Ссылки только на официальные
источники и правильная настройка приведены в POST_INSTALL_ROOT.md. Приложения,
которым нужен root (например VPN Hotspot), нельзя добавлять в blacklist Shamiko,
иначе они будут писать Root is missing при выданном разрешении.
[/SPOILER]
