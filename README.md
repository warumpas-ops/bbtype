# BBType — Monkeytype for BlackBerry Q5

A fast, lightweight, and offline typing speed test built specifically for the **BlackBerry Q5** (and other BB10 physical keyboard devices like the Q10, Classic, and Passport).

---

## 📦 What's Included

- **`BBType.apk`** (~25 KB): Standalone Android application package, signed and compatible with the BlackBerry 10 Android 4.3 runtime (API 18+).
- **`index.html`**: Standalone, zero-dependency HTML file that can also be run directly in the BB10 native browser.

---

## ⚡ Features Tailored for BlackBerry Q5

- **Screen Optimization**: Designed for the 1:1 square **720×720** display.
- **Physical Keyboard Support**:
  - **`Space`**: Submits current word.
  - **`Backspace`**: Erases characters; if pressed at the start of a word, it steps back into the previous word to fix mistakes (just like real Monkeytype!).
  - **`Tab`** or **`Enter`**: Instant restart.
- **Classic Monkeytype Theme**: Charcoal background (`#323437`) and gold accents (`#e2b714`).
- **Real-time Metrics**: Live WPM counter, live Accuracy (%), and end-of-test detailed stats (Net WPM, Raw WPM, Correct/Incorrect keystrokes).
- **Modes**: 15s, 30s, 60s tests, with optional **Punctuation** (`@ punct`) and **Numbers** (`# num`) toggles.
- **Personal Best (PB)**: Automatically tracked and stored locally for each test duration.
- **Synthesized Key Click Sound (Optional)**: Toggleable click feedback powered by Web Audio API without needing external sound files.
- **100% Offline**: Zero internet connection, zero tracking, zero external CDNs.

---

## 🚀 How to Install on BlackBerry Q5

### Step 1: Enable Sideloading on your Q5
1. Go to **Settings** on your BlackBerry.
2. Tap **App Manager** > **Installing Apps**.
3. Toggle **Allow apps from other sources to be installed** to **ON**.

### Step 2: Transfer `BBType.apk` to your Phone
Choose any convenient method:
- **USB Cable**: Connect your Q5 to your PC via USB in **Media Transfer** or **USB Mass Storage** mode, and drag `BBType.apk` into the **Downloads** or **Documents** folder.
- **MicroSD Card**: Copy `BBType.apk` onto your microSD card and insert it into the Q5.
- **Bluetooth**: Send `BBType.apk` directly over Bluetooth from your PC to your phone.

### Step 3: Install the App
1. Open the **File Manager** app on your BlackBerry Q5.
2. Navigate to where you saved `BBType.apk`.
3. Tap on **`BBType.apk`** and select **Install** at the top right.
4. Launch **BBType** from your home screen and start typing!

---

## 🌐 Alternative: Standalone Browser Mode
If you prefer not to install the APK:
1. Copy `index.html` to your BlackBerry.
2. Open `index.html` in the BlackBerry Browser.
3. Tap the bottom right menu (`⋮`) and select **Add to Home Screen**.
