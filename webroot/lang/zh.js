// Language:Traditional_Chinese
// Translated by:Peter & thegreatlan

// [SECTION 1] Translate the text inside " "
export const translations = {
  "zh": [
    "停用自動白名單模式",
    "啟用自動白名單模式",
    "設定自訂 PIF prop/json",
    "欺騙/反欺騙 PIF 注入值",
    "欺騙/反欺騙 PIF 分叉值",
    "強制停止 GMS 應用程式",
    "修復未認證的設備",
    "更新Keybox",
    "將所有應用程式加入目標清單",
    "僅將使用者應用程式加入目標清單",
    "切換到預設Keybox",
    "切換到AOSP Keybox",
    "欺騙TrickyStore補丁",
    "取得被禁用的Keybox清單",
    "更新 SusFS 設定",
    "設定已驗證的啟動雜湊",
    "啟用內建 GMS 欺騙",
    "隱藏 GMS 屬性偵測",
    "PixelOS 欺騙",
    "小米EU欺騙",
    "HentaiOS 欺騙",
    "Derpfest 欺騙",
    "異常檢測",
    "標記的應用程式",
    "道具檢測",
    "支持開發者",
    "加入更新TG頻道",
    "加入幫助TG頻道",
    "原始碼",
    "報告問題/Bug",
    "更改 SELinux 狀態",
    "模組資訊",
    "調整 WebUI 大小",
    "模態自動關閉開關",
    "玩遊戲"
  ]
};

// [SECTION 2] Translate the text inside { " " }
export const buttonGroups = {
  "Whitelist": { "zh": "白名单" },
  "PIF": { "zh": "Play Integrity 修复" },
  "TS": { "zh": "Tricky Store" },
  "Sus": { "zh": "SusFS" },
  "CrSpoof": { "zh": "自定义 ROM 伪装" },
  "Check": { "zh": "诊断" },
  "Help": { "zh": "社区与支持" },
  "Basic": { "zh": "常规" },
  "TimePass": { "zh": "游戏" }
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