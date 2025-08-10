`I originally wrote this code in Notepad and haven’t been very active on Git. I’m uploading it here mainly to keep things transparent. Feel free to inspect the code.`
`Happy debugging`
<details>
<summary><strong>Why I Built This Module</strong></summary>


*I noticed a lot of people either selling leaked keyboxes or paying for modules that claim to pass strong Play Integrity but only offer leaked keyboxes. I created this module to give you **real**, **working keyboxes** completely **free**, no hidden charges, no scams, just **legit access** along with several useful features. 🚫🔑*
</details>


<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" alt="Catppuccin Footer" />
</p>

<div align="center">
  <a href="https://github.com/MeowDump/Integrity-Box/releases" target="_blank">
    <img src="DUMP/download.png" alt="Download Button" width="600" />
  </a>
</div>

## Module Features

> **This module offers the following features:**  

-  Updates valid `keybox.xml`  
-  Updates `target.txt` as per your TEE status
-  Hides debug fingerprint detection
-  Hides debug build detection
-  Re-freshes target list on every reboot for seamless exprience
-  Switch Shamiko & Nohello modes (via module toggle)
-  Guides users if their module setup is incorrect to pass play integrity
-  Adds all custom ROM detection packages in the **SusFS path**  
-  Disables EU injector by default  
-  Disables GMS ROM spoofing for  various cROMs 
-  Spoofs encryption status   
-  Spoofs ROM release key  
-  Spoofs SE Linux status
-  Updates PIF Fingerprint
-  Spoofs PIF Injection Values
-  Spoofs Tricky Store's Security Patch
-  Switches between AOSP & Valid keybox
-  FIXES Device not certified error
-  Shows banned keybox list
-  Set's verified boot hash via SusFs
-  Detects abnormal activity to help debug issues
-  Detects flagged & spoofed apps
-  More feature are there, check [WebUI](https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/webui.gif)

## Pre-Requirements

> Please make sure you have the following **modules installed** before using Integrity Box:

- [**Play Integrity Fork**](https://github.com/osm0sis/PlayIntegrityFork/releases)
- [**Tricky Store**](https://github.com/5ec1cff/TrickyStore/releases) or [**Tricky Store OSS**](https://github.com/beakthoven/TrickyStoreOSS/releases)
> Make sure to properly hide root & zygisk traces, otherwise you won't be able to pass play integrity verdicts

## Support
<table align="center" cellspacing="20" style="border: none;">
  <tr align="center">
    <td style="border: none;">
      <a href="https://t.me/MeowDump" target="_blank" style="border: none;">
        <img src="https://upload.wikimedia.org/wikipedia/commons/8/82/Telegram_logo.svg" alt="Join our Telegram Group" width="150" style="border: none;"><br>
        <code>Join help group</code>
      </a>
    </td>
    <td style="border: none;">
      <a href="https://github.com/MeowDump/Integrity-Box/blob/main/support.md" target="_blank" style="border: none;">
        <img src="https://www.svgrepo.com/show/194198/donate-donation.svg" alt="Support Developer" width="150" style="border: none;"><br>
        <code>Donate to Developer</code>
      </a>
    </td>
  </tr>
</table>

## Preview
<p align="center">
  <img 
    src="https://m3-markdown-badges.vercel.app/stars/7/1/MeowDump/Integrity-Box" 
    alt="GitHub Stars" 
  />
</p>

<table align="center">
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/installation.gif" alt="1" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/webui.gif" alt="2" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/webui2.gif" alt="3" style="max-width: 100%; height: auto;" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/5.gif" alt="4" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/action.png" alt="5" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/prop.png" alt="6" style="max-width: 100%; height: auto;" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/8.png" alt="7" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/2.png" alt="8" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/3.png" alt="9" style="max-width: 100%; height: auto;" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/4.png" alt="10" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/module.png" alt="11" style="max-width: 100%; height: 2400;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/1.png" alt="12" style="max-width: 100%; height: auto;" /></td>
  </tr>
</table>

<details>
<summary><strong>Notes</strong></summary>

<br>
NOTE: Use Action/WebUI button to report bugs/issues

- Hide root properly if play integrity isn't passing for you. If you are using a custom rom, make sure you have disabled inbuilt gms spoofing. How to disable it? Well it depends on what rom you're using. Join your rom help group & ask `how to disable it` there.  
- Avoid conflicting or unnecessary modules that expose your root environment

</details>

<details>
<summary><strong>FAQ</strong></summary>

<br>

> NOTICE: THE POPUP TOASTER WILL BE DISCONTINUED IN v15

## Why the Popup Toaster App Remains After Module Removal

This is because the app was installed using the `pm install <package-name>` command, while module installation, which installs the APK directly onto the system to avoid unexpected crashes due to broken installation.

Magisk’s standard uninstall process does not support removing applications installed this way. That's why it still remains after module removal

## Complete Uninstallation

To fully remove all components, including the Popup Toaster app, you must run the module’s uninstall script `($MODDIR/uninstall.sh)` with `su` manually or simply remove the module from your root manager and uninstall the Popup Toaster app manually.

</details>
