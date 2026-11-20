# LOST SIGNAL: Escape Pluto

**Theme:** LOST  
**Engine:** Godot 4.x (standard/GDScript)  
**Display:** Landscape, top-down 2D  
**Status:** Source project generated; runtime and APK export must be tested locally in Godot.

## Mobile improvement update (20 November 2026)

This repo is the active project at `LOST_SIGNAL_Godot_Project/LOST_SIGNAL_PlutO/`.
The separate `Lost_Signal/LostSignal/` folder is another project; do not open it by mistake.

**Changes committed:** Fixed the old 960x540 vs 1280x720 screen mismatch, landscape orientation, OpenGL Compatibility Android renderer, HUD overlap, progress meter, target compass, wider touch zones, and touch/restart input handling. Added an **Android** export preset.

**Quick APK instructions for the team:**

1. From `~/Downloads/gamjam`, run `git pull --ff-only origin main`.
2. Open **THIS folder's** `project.godot` in Godot 4.7.2, not the outer `gamjam` folder.
3. Godot **Editor > Manage Export Templates**: install templates for the exact editor version.
4. **Editor > Editor Settings > Export > Android**: set Java SDK Path (JDK 17) and Android SDK Path.
5. **Project > Export**: choose the existing **Android** preset. Resolve any red warnings, then **Export Project** with the debug option enabled. Save as `LOST_SIGNAL-debug.apk`.
6. On a USB-debugging-enabled Android phone: `adb install -r LOST_SIGNAL-debug.apk`. Or transfer and install the APK manually, allowing installs from that source.
7. Test **landscape orientation**, start/restart, left joystick, right SCAN, mini-map, five parts, lives and escape ending.

The APK is **not** included in GitHub; this source change is not yet device-tested. Export requires SDK, JDK, matching Godot export templates and an Android debugging keystore. Do not commit keystores or passwords.

## Play immediately on Ubuntu

1. Extract the ZIP anywhere you have free disk space.
2. Open **Godot Project Manager** > **Import** > select `project.godot` in this folder.
3. Open the project. Press **F5** (Run Project).
4. Press **Enter** or click once to start.
5. Move with **WASD/arrow keys**; **Space** to activate scanner (after torch pickup).
6. On mobile, use the **left thumbstick** to move and **SCAN** on the right.

## Story and mechanics

Your ship has crashed on Pluto. First recover a torch. Follow the live mini-map to find **five** components in order:

1. **Power Cell** — a timed electric barrier.
2. **Engine Core** — moving meteors.
3. **Navigation Chip** — a rock-wall maze.
4. **Fuel Module** — a crater field.
5. **Signal Transmitter** — pulsing signal waves.

You have three lives. Getting hit teleports you back to the most recently recovered component. Each component acts as a checkpoint. After all five, follow the mini-map back to the ship to repair it and see the ending.

The scanner briefly draws a bright route line and widens visibility. It has a five-second cooldown. The minimap always shows your position and the next objective.

## Android APK export (on your Ubuntu laptop)

1. In Godot: **Editor > Manage Export Templates > Download and Install** for **your exact Godot version**.
2. **Editor > Editor Settings > Export > Android**: set `Java SDK Path` (JDK 17) and `Android SDK Path` to the tools you installed. On Ubuntu JDK may be `/usr/lib/jvm/java-17-openjdk-amd64`, and SDK may be `/home/YOUR_USER/Android/Sdk`.
3. **Project > Export > Add... > Android**.
4. Set a unique package name, e.g. `org.yourteam.lostsignal` (replace `yourteam`). Keep landscape orientation and debug build enabled for initial testing.
5. Click **Export Project** and save as `LostSignal.apk`.
6. Connect an Android phone with USB debugging enabled (borrow a teammate's if needed). Install with `adb install -r LostSignal.apk` or copy/install the APK manually.
7. Verify input, screen layout, frame rate, menus, part pickup, death, and ending on an actual phone.

**Do not assume Android export works until tested.** A Windows/Linux Godot playtest is not an Android playtest.

Official Godot instructions: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

## Team division (if adapting during the jam)

- **Member A:** Gameplay & player movement: `main.gd` (coordinate edits with integrator).
- **Member B:** Interface, minimap & visual polish: `hud.gd`, `audio/`.
- **Member C:** Test, level balancing, Godot Android export, `README.md` and final submission.

To minimize merge conflicts with beginners, **only one member edits `main.gd` at a time**. Export tests can happen in parallel.

## Competition submission notes

- Team name: `FILL_IN`
- Team members: `FILL_IN`
- Interpretation of theme: `The astronaut is lost on Pluto after a crash; the route and parts needed to return home are lost. The player recovers the parts with scanner-guided navigation.`
- Controls: virtual thumbstick + SCAN, keyboard WASD/arrows + Space for laptop demonstration.
- Art/asset credits: Geometry, colors and UI are produced with Godot drawing APIs; no downloaded image files are used.
- Audio credits: `audio/*.wav` were newly synthesized for this project, no borrowed music.
- AI disclosure: ChatGPT assisted with game design, source code, shader, UI, sound generation and documentation. Team members should disclose exactly how they used AI and demonstrate they understand the game.

**Competition rule reminder:** Follow organizers' rules for when coding can begin and what files can be submitted. Verify accepted APK format and submission deadline with the organizer.

## Known limitations / polish opportunities

- All visuals are code-drawn shapes rather than custom 3D assets; this prioritizes completion under time pressure.
- The minimap is a live overview, not a fully detailed pathfinder.
- The scanner points directly toward the next item, not an obstacle-aware route.
- The Android APK is **not prebuilt in this ZIP**; export from your Godot installation.
