# Дополнительная настройка root, скрытия и приложений

Эти компоненты не встроены в BOOT или RECOVERY. Ниже описана комбинация,
проверенная на эталонном `SM-N9750`.

## Базовая настройка

1. Включите Zygisk в Magisk и перезагрузите телефон.
2. Установите [Shamiko](https://github.com/LSPosed/LSPosed.github.io/releases).
3. Не включайте **Enforce DenyList**. Shamiko использует выбранные в DenyList
   процессы как чёрный список.
4. Добавляйте только приложения, от которых требуется скрыть root.
5. Никогда не добавляйте приложение, которому нужен root. Например,
   `be.mygod.vpnhotspot` внутри DenyList сообщает `Root is missing`, даже когда
   политика Magisk для него установлена в `ALLOW`.

Проверено с Shamiko `1.2.5 (414)` в blacklist mode.

## Integrity Box

- [Integrity Box](https://github.com/MeowDump/Integrity-Box) v41;
- [Tricky Store](https://github.com/5ec1cff/TrickyStore) v1.4.1 (248).

По документации Integrity Box для аттестации нужен Tricky Store либо TEE
Simulator. Не публикуйте, не передавайте и не импортируйте чужой `keybox.xml`,
если не понимаете его происхождение и последствия. Результаты Play Integrity
могут измениться без обновления локальных компонентов.

## Vector и HMA

- [Vector](https://github.com/JingMatrix/Vector) v2.2 (3080);
- [Hide My Applist](https://github.com/Dr-TSNG/Hide-My-Applist) v3.8.3.

Установите Vector как модуль Magisk, перезагрузитесь, установите HMA, включите
HMA в Vector и выдайте HMA область действия только для приложений, которым не
следует видеть выбранные имена пакетов. HMA 3.4 и новее прямо запрещает
повторное распространение, поэтому скачивайте его только со страницы upstream.

## ReVanced

Используйте upstream-релизы
[j-hc ReVanced Magisk](https://github.com/j-hc/revanced-magisk-module/releases).
На эталонном телефоне проверены:

- YouTube ReVanced Extended `20.51.39`, patches `dev.7.mpp`;
- YouTube Music ReVanced Extended `9.15.51`, patches `dev.7.mpp`.

Проект не распространяет модифицированные APK YouTube или YouTube Music.

## Проверка через ADB

```bash
adb shell magisk -v
adb shell su -c id
adb shell su -c 'magisk --denylist status'
adb shell su -c 'magisk --denylist ls'
```

Ожидаемое базовое состояние: Magisk 30.7, UID 0 от `su`, включённый Zygisk и
`Denylist is not enforced`, пока Shamiko работает в blacklist mode.
