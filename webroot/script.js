const MODDIR = "/data/adb/modules/integrity_box/webroot/common_scripts";
const PROP = `/data/adb/modules/integrity_box/module.prop`;

const modalBackdrop = document.getElementById("modal-backdrop");
const modalTitle = document.getElementById("modal-title");
const modalOutput = document.getElementById("modal-output");
const modalClose = document.getElementById("modal-close");
const modalContent = document.getElementById("modal-content");

function runShell(command) {
  if (typeof ksu !== "object" || typeof ksu.exec !== "function") {
    return Promise.reject("KernelSU JavaScript API not available.");
  }
  const cb = `cb_${Date.now()}`;
  return new Promise((resolve, reject) => {
    window[cb] = (code, stdout, stderr) => {
      delete window[cb];
      code === 0 ? resolve(stdout) : reject(new Error(stderr || "Shell command failed"));
    };
    ksu.exec(command, "{}", cb);
  });
}

function popup(msg) {
  return runShell(`am start -a android.intent.action.MAIN -e mona "${msg}" -n popup.toast/.MainActivity`);
}

function openModal(title, content, fullscreen = false) {
  modalTitle.textContent = title;
  modalOutput.innerHTML = content || "Loading...";
  modalBackdrop.classList.remove("hidden");

  if (fullscreen) {
    modalBackdrop.classList.add("fullscreen");
    modalContent.classList.add("fullscreen");
    modalOutput.classList.add("fullscreen");
  } else {
    modalBackdrop.classList.remove("fullscreen");
    modalContent.classList.remove("fullscreen");
    modalOutput.classList.remove("fullscreen");
  }
}

function closeModal() {
  modalBackdrop.classList.add("hidden");
}

async function getModuleName() {
  try {
    const name = await runShell(`grep '^name=' ${PROP} | cut -d= -f2`);
    document.getElementById("module-name").textContent = name.trim();
    document.title = name.trim();
  } catch {
    document.getElementById("module-name").textContent = "integrity_box";
  }
}

async function updateDashboard() {
  const statusWhitelist = document.getElementById("status-whitelist");
  const statusGms = document.getElementById("status-gms");
  const statusSusfs = document.getElementById("status-susfs");

  try {
    await runShell("[ -f /data/adb/nohello/whitelist ] || [ -f /data/adb/shamiko/whitelist ]");
    statusWhitelist.textContent = "Enabled";
    statusWhitelist.className = "status-indicator enabled";
  } catch {
    statusWhitelist.textContent = "Disabled";
    statusWhitelist.className = "status-indicator disabled";
  }

  try {
    const gmsProp = await runShell("getprop persist.sys.pihooks.disable.gms_props");
    statusGms.textContent = gmsProp.trim() === "true" ? "Disabled" : "Enabled";
    statusGms.className = gmsProp.trim() === "true" ? "status-indicator enabled" : "status-indicator enabled";
  } catch {
    statusGms.textContent = "Unknown";
    statusGms.className = "status-indicator";
  }

  try {
    await runShell("[ -d /data/adb/modules/susfs4ksu ]");
    statusSusfs.textContent = "Detected";
    statusSusfs.className = "status-indicator enabled";
  } catch {
    statusSusfs.textContent = "Not Found";
    statusSusfs.className = "status-indicator disabled";
  }
}

document.addEventListener("DOMContentLoaded", () => {
  getModuleName();
  updateDashboard();

  const sparkleContainer = document.querySelector('.sparkle-container');
  if (sparkleContainer) {
    for (let i = 0; i < 40; i++) {
      const sparkle = document.createElement('div');
      sparkle.classList.add('sparkle');
      sparkle.style.top = `${Math.random() * 100}%`;
      sparkle.style.left = `${Math.random() * 100}%`;
      sparkle.style.animationDelay = `${Math.random() * 3}s`;
      sparkleContainer.appendChild(sparkle);
    }
  }

  const introSubtext = document.getElementById("intro-subtext");
  if (introSubtext) {
    const quotes = [
      "Indeed, With Hardship Comes Ease",
      "Work Hard Dream Big",
      "Stay Focused Never Give Up",
      "Believe In Yourself",
      "Success Starts With Effort",
      "Discipline Is Greater Than Motivation",
      "Dream It Wish It Do It",
      "Your Mind Is Your Power",
      "Grind Quietly, Rise Loudly",
      "Hold the Vision. Trust the Process",
      "Let Silence Build Your Legacy",
      "There's No Tomorrow",
      "Fear Only the Eternal",
      "Whoever Remains Silent Is Saved",
      "Die Before You Die",
      "Die Awake, Not Afraid",
      "Turn Pain Into Purpose",
	 "No Peace Without Struggle",
	 "A Clean Heart Fears Nothing",
	 "Be Water, Not the Wave",
	 "Darkness Teaches Light"
    ];

    const randomQuote = quotes[Math.floor(Math.random() * quotes.length)];
    const words = randomQuote.split(" ");

    introSubtext.innerHTML = "";
    words.forEach((word, index) => {
      const span = document.createElement("span");
      span.textContent = word;
      span.style.opacity = 0;
      span.style.display = "block";
      span.style.fontWeight = "bold";
      span.style.fontSize = "5.2rem";
      span.style.textAlign = "center";
      span.style.transition = "opacity 0.3s ease-in-out";
      span.style.animation = `fadeInWord 0.4s ease forwards ${index * 0.5}s`;
      introSubtext.appendChild(span);
    });
  }

  setTimeout(() => {
    const overlay = document.getElementById("intro-overlay");
    if (overlay) overlay.remove();
  }, 6000);

  document.querySelectorAll(".btn").forEach((btn) => {
    btn.addEventListener("click", async () => {
      const script = btn.dataset.script;
      const type = btn.dataset.type;
      const command = `sh ${MODDIR}/${script}`;
      btn.classList.add("loading");

      try {
        if (type === "scanner") {
          openModal(btn.innerText.trim(), "Running scan...", true);
          const output = await runShell(command);
          modalOutput.innerHTML = (output || "Script executed with no output.").replace(/\n/g, "<br>");
          setTimeout(closeModal, 10000);
        } else if (type === "hash") {
          const output = await runShell(`sh ${MODDIR}/boot_hash.sh get`);
          const lines = output.trim().split(/\r?\n/);
          const saved = lines[1]?.trim() || "";
          const content = `
            <div style="display:flex;flex-direction:column;gap:1rem">
              <label>Enter Verified Boot Hash:</label>
              <input id="new-hash" type="text" value="${saved}" placeholder="abcdef1234..." style="width:100%;padding:0.5rem;font-size:0.9rem;border-radius:8px;border:1px solid var(--border-color);background:var(--panel-bg);color:var(--fg);" />
              <div style="display:flex;gap:1rem;flex-wrap:wrap;">
                <button class="btn" id="apply-hash"><span class="icon material-symbols-outlined">done</span>Apply</button>
                <button class="btn" id="reset-hash"><span class="icon material-symbols-outlined">restart_alt</span>Reset</button>
              </div>
            </div>
          `;
          openModal("Set Verified Boot Hash", content, true);
          setTimeout(() => {
            document.getElementById("apply-hash")?.addEventListener("click", async () => {
              const hash = document.getElementById("new-hash").value.trim();
              const cmd = hash ? `sh ${MODDIR}/boot_hash.sh set ${hash}` : `sh ${MODDIR}/boot_hash.sh clear`;
              try {
                await runShell(cmd);
                popup("Boot hash applied ✅");
              } catch {
                popup("Failed to apply hash ❌");
              } finally {
                await runShell(`sh ${MODDIR}/resethash.sh clear`);
                closeModal();
              }
            });

            document.getElementById("reset-hash")?.addEventListener("click", async () => {
              modalOutput.innerHTML = "Resetting...";
              try {
                await runShell(`sh ${MODDIR}/boot_hash.sh clear`);
                popup("Boot hash reset ✅");
              } catch {
                popup("Failed to reset ❌");
              } finally {
                closeModal();
              }
            });
          }, 100);
        } else if (type === "game") {
          const gameFrame = document.createElement("iframe");
          gameFrame.src = "./game/index.html";
          gameFrame.style.border = "none";
          gameFrame.style.width = "100%";
          gameFrame.style.height = "100%";
          gameFrame.style.flex = "1";
          gameFrame.style.borderRadius = "0";

          openModal("", "", true);
          modalOutput.innerHTML = "";
          modalOutput.appendChild(gameFrame);
          return;
        } else if (script === "support") {
          const content = `
<style>
  .donate-modal * { font-family: inherit; box-sizing: border-box; }
  .donate-modal {
    padding-top: 0;
    margin-top: -1rem;
  }
  .donate-header {
    font-size: 0.9rem;
    font-weight: 500;
    text-align: center;
    margin-bottom: 1.2rem;
    color: var(--fg);
  }
  .donate-entry {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 1.5rem;
  }
  .coin {
    width: 170px !important;
    height: 170px !important;
    margin: 0 auto 0.6rem auto !important;
    display: block;
  }
  .donate-entry span {
    font-size: 0.85rem;
    font-weight: 600;
    color: var(--fg);
    margin-bottom: 0.5rem;
  }
  .donate-address-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background-color: var(--panel-bg);
    padding: 0.7rem 0.9rem;
    border-radius: 10px;
    font-family: monospace;
    font-size: 0.8rem;
    word-break: break-all;
    border: 1px solid var(--border-color);
    margin-bottom: 0.5rem;
  }
  .donate-address {
    flex-grow: 1;
    margin-right: 0.8rem;
  }
  .copy-btn {
    background: var(--accent);
    color: var(--bg);
    border: none;
    padding: 14px 12px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 0.7rem;
    font-weight: 600;
  }
</style>

<div class="donate-modal">
  <div class="donate-header">
    Only donate if you're earning.<br>
    Students and unemployed supporters, your kindness is more than enough 💖
  </div>

  <div class="donate-entry">
    <img src="https://raw.githubusercontent.com/VadimMalykhin/binance-icons/main/crypto/busd.svg" alt="TRC20 USDT" class="coin" />
    <span>TRC20 USDT</span>
  </div>
  <div class="donate-address-row">
    <span class="donate-address">TCfhyVTfJDw8gHQT8Ph7DknNgie6ZAH5Bt</span>
    <button class="copy-btn" data-copy="TCfhyVTfJDw8gHQT8Ph7DknNgie6ZAH5Bt">🪙</button>
  </div>

  <div class="donate-entry">
    <img src="https://raw.githubusercontent.com/VadimMalykhin/binance-icons/main/crypto/busd.svg" alt="BEP20 USDT" class="coin" />
    <span>BEP20 USDT</span>
  </div>
  <div class="donate-address-row">
    <span class="donate-address">0x6b3f76339f2953db765dd2fb305784643e7d49df</span>
    <button class="copy-btn" data-copy="0x6b3f76339f2953db765dd2fb305784643e7d49df">🪙</button>
  </div>

  <div class="donate-entry">
    <img src="https://ziadoua.github.io/m3-Markdown-Badges/badges/PayPal/paypal1.svg" alt="PayPal" class="coin" />
  </div>
  <div class="donate-address-row">
    <span class="donate-address">https://paypal.me/TempMeow</span>
    <button class="copy-btn" data-copy="https://paypal.me/TempMeow">🪙</button>
  </div>
</div>
`;
          openModal("Support the Developer", content.trim(), true);

          document.querySelectorAll('.copy-btn').forEach(btn => {
            btn.addEventListener('click', () => {
              const text = btn.getAttribute('data-copy');
              navigator.clipboard.writeText(text).then(() => {
                btn.textContent = "🩷";
                setTimeout(() => (btn.textContent = "✅"), 2000);
              });
            });
          });
        } else {
          await runShell(command);
        }
      } catch (error) {
        if (type === "scanner") {
          modalOutput.textContent = `Error executing script:\n\n${error.message}`;
        } else {
          popup(`Error: ${error.message}`);
        }
      } finally {
        btn.classList.remove("loading");
        setTimeout(updateDashboard, 1000);
      }
    });
  });

  modalClose.addEventListener("click", closeModal);
  modalBackdrop.addEventListener("click", (e) => {
    if (e.target === modalBackdrop) closeModal();
  });

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && !modalBackdrop.classList.contains("hidden")) {
      closeModal();
    }
  });

  const langDropdown = document.getElementById("lang-dropdown");
  langDropdown.addEventListener("change", async () => {
    const lang = langDropdown.value;
    document.documentElement.setAttribute("dir", lang === "ar" || lang === "ur" ? "rtl" : "ltr");

    try {
      const module = await import(`./lang/${lang}.js`);
      const { translations, buttonGroups, buttonOrder } = module;

      document.querySelectorAll(".group-title").forEach(title => {
        const originalKey = title.dataset.key || title.textContent;
        if (!title.dataset.key) title.dataset.key = originalKey;
        if (buttonGroups[originalKey] && buttonGroups[originalKey][lang]) {
          title.textContent = buttonGroups[originalKey][lang];
        }
      });

      const labels = translations[lang] || translations["en"];
      buttonOrder.forEach((scriptName, index) => {
        const btn = document.querySelector(`.btn[data-script='${scriptName}']`);
        if (btn) {
          const icon = btn.querySelector('.icon');
          const spinner = btn.querySelector('.spinner');
          const label = labels[index] || btn.textContent.trim();
          btn.innerHTML = '';
          if (icon) btn.appendChild(icon);
          btn.appendChild(document.createTextNode(label));
          if (spinner) btn.appendChild(spinner);
        }
      });
    } catch (e) {
      console.error("Failed to load language file", e);
    }
  });

  langDropdown.dispatchEvent(new Event("change"));

  const toggle = document.getElementById("theme-toggle");
  function applyTheme(theme) {
    if (theme === "light") {
      document.documentElement.classList.remove("dark");
      document.documentElement.classList.add("light");
      toggle.checked = false;
    } else {
      document.documentElement.classList.remove("light");
      document.documentElement.classList.add("dark");
      toggle.checked = true;
    }
  }

  function changeLanguage(lang) {
    localStorage.setItem("lang", lang);

    const existingScript = document.getElementById("lang-script");
    if (existingScript) existingScript.remove();

    window.translations = {};

    const script = document.createElement("script");
    script.id = "lang-script";
    script.src = `lang/${lang}.js`;
    script.onload = () => {
      if (window.translations) {
        translateUI();
      }
    };
    document.head.appendChild(script);
  }

  function translateUI() {
    document.querySelectorAll("[data-i18n]").forEach((el) => {
      const key = el.getAttribute("data-i18n");
      if (window.translations && window.translations[key]) {
        el.innerText = window.translations[key];
      }
    });
  }

  document.addEventListener("DOMContentLoaded", () => {
    const savedLang = localStorage.getItem("lang") || "en";
    changeLanguage(savedLang);
  });

    const introText = document.querySelector('.intro-text');
    if (introText && document.documentElement.classList.contains('light')) {
      introText.style.color = '#ec407a';
      introText.style.borderRight = '2px solid #ec407a';
    }

    const savedTheme = localStorage.getItem("theme") || "dark";
    applyTheme(savedTheme);

    toggle.addEventListener("change", () => {
      const newTheme = toggle.checked ? "dark" : "light";
      localStorage.setItem("theme", newTheme);
      applyTheme(newTheme);
    });
  });
