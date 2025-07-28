// Language: Russian
// Translated by: InternalHellhound & NV4K

// [SECTION 1] Translate the text inside " "
export const translations = {
  "ru": [
    "Выключить автоматический белый список",
    "Включить автоматический белый список",
    "Установить кастомные PIF пропы/json",
    "Скрыть значения PIF Injection",
    "Скрыть значения PIF Fork",
    "Остановить процесс GMS",
    "Исправить статус сертификации устройства",
    "Обновить Keybox",
    "Добавить все приложения в список целей",
    "Добавить только пользовательские приложения в список целей",
    "Установить Keybox по умолчанию",
    "Установить AOSP Keybox",
    "Скрыть патч Tricky Store",
    "Запросить список недействительных Keybox",
    "Обновить конфигурацию SusFS",
    "Установить Verified Boot Hash",
    "Включить встроенную подмену GMS",
    "Скрыть обнаружение GMS пропов",
    "Скрыть PixelOS",
    "Скрыть Xiaomi EU",
    "Скрыть HentaiOS",
    "Скрыть Derpfest",
    "Аномальное состояние среды",
    "Подозрительные приложения",
    "Обнаружение пропов",
    "Поддержать разработчика",
    "Группа с обновлениями",
    "Группа поддержки",
    "Исходный код",
    "Сообщить о проблеме",
    "Изменить статус SELinux",
    "Информация о модуле",
    "Изменить размеры WebUI",
    "Автоматически закрывать консоль",
    "Сыграть в игру"
  ]
};

// [SECTION 2] Translate the text inside { " " }
export const buttonGroups = {
  "Whitelist": { "ru": "Белый список" },
  "PIF": { "ru": "Play Integrity Fix" },
  "TS": { "ru": "Tricky Store" },
  "Sus": { "ru": "SusFS" },
  "CrSpoof": { "ru": "Скрытие кастомных прошивок" },
  "Check": { "ru": "Диагностика" },
  "Help": { "ru": "Сообщество и поддержка" },
  "Basic": { "ru": "Прочее" },
  "TimePass": { "ru": "Игра" }
};

// [SECTION 3] There's nothing to translate in this section
export const buttonOrder = [
  "stop.sh", "start.sh", 
  "pif.sh", "spoof.sh", "piffork.sh", "kill.sh", "vending.sh",  "key.sh",
  "systemuser.sh", "user.sh", "keybox.sh", "aosp.sh", "patch.sh", "banned.sh",
  "sus.sh", "boot_hash.sh",
  "setprop.sh", "resetprop.sh", "pixelos.sh", "xiaomi.sh", "helluva.sh", "derpfest.sh",
  "abnormal.sh", "app.sh", "prop.sh",
  "support", "meowdump.sh", "meowverse.sh", "info.sh", "report.sh",
  "selinux.sh", "module_info.sh", "resize.sh", "modal.sh",
  "game.sh"
];