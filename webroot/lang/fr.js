// Language: Français
// Translated by: @alananassss

// [SECTION 1] Translate the text inside " "
export const translations = {
  "fr": [
    "Désactiver le mode d'ajout automatique à la liste blanche",
    "Activer le mode d'ajout automatique à la liste blanche",
    "Définir un prop/json PIF personnalisé",
    "Falsifier / restaurer les valeurs d’injection PIF",
    "Falsifier / restaurer les valeurs Fork PIF",
    "Tuer le processus GMS",
    "CORRIGER : appareil non certifié",
    "Mettre à jour la Keybox",
    "Ajouter toutes les applis de la liste cible",
    "Ajouter uniquement les applis utilisateur de la liste cible",
    "Basculer vers la Keybox par défaut",
    "Basculer vers la Keybox AOSP",
    "Falsifier le patch Tricky Store",
    "Obtenir la liste des Keybox bannies",
    "Mettre à jour la configuration SusFS",
    "Définir le hachage de démarrage vérifié",
    "Activer le spoofing GMS intégré",
    "Masquer les détections de prop GMS",
    "Spoofing PixelOS",
    "Spoofing Xiaomi EU",
    "Spoofing HentaiOS",
    "Spoofing Derpfest",
    "Détection anormale",
    "Applis signalées",
    "Détection de props",
    "Soutenir le développeur",
    "Rejoindre le canal de mise à jour",
    "Rejoindre le groupe d’aide",
    "Code source",
    "Signaler un problème / bug",
    "Changer l’état SELinux",
    "Infos du module",
    "Redimensionner l’interface Web",
    "Interrupteur de fermeture auto de la modale",
    "Jouer"
  ]
};

// [SECTION 2] Translate the text inside { " " }
export const buttonGroups = {
  "Whitelist": { "fr": "Liste blanche" },
  "PIF": { "fr": "Play Integrity Fix" },
  "TS": { "fr": "Tricky Store" },
  "Sus": { "fr": "SusFS" },
  "CrSpoof": { "fr": "Spoof ROM personnalisée" },
  "Check": { "fr": "Diagnostic" },
  "Help": { "fr": "Communauté & Support" },
  "Basic": { "fr": "Général" },
  "TimePass": { "fr": "Jeu" }
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
