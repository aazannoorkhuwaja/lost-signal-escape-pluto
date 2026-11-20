# LOST SIGNAL: Escape Pluto

A landscape Android exploration game for the Coder’s Cup ’26 LOST theme. Pluto stops transmitting. A rescue pilot crashes while investigating and must rebuild the ship with a flashlight, a scanner and three suit lives.

**Team:** bunyan al marsoos

**Members:** Aazan Noor Khuwaja, Mushaf ALi Mir, Abbas Ahmed

## Play

Install the signed debug APK on an ARM Android phone running Android 7.0 or newer. With USB debugging enabled, run `adb install -r LostSignal-debug.apk` and open Lost Signal from the launcher.

Tap to begin. Use the left stick to reach the gold torch east of the crash site. The torch restores the minimap. Green marks the astronaut, gold marks the next component and blue marks the ship. Hold the stick and tap SCAN with another finger for a bearing and a wider light radius. The scanner recharges in five seconds.

Time the electrical crossing, avoid the two moving meteors, navigate the rock maze, skirt the craters and flashing cryovent, and cross the transmitter field between pulses. Each component saves a checkpoint. Return all five to the crash site to launch. Tap the ending or game-over screen to replay.

## Run and export

Open `project.godot` in Godot 4.7.2 and press F5. Enter starts the game, WASD or arrows move, and Space scans. The mouse can operate either touch control. The logical canvas is 1280×720 with aspect-preserving scaling and Android safe-area positioning.

Use JDK 17, Android SDK platform-tools and build-tools, and the matching Godot Android debug template. Set the SDK and JDK directories in Godot editor settings. From this folder run `godot --headless --export-debug Android ../../LostSignal-debug.apk` with your Godot executable. The Android preset uses the Compatibility renderer and includes ARM64 and ARMv7. The APK is distributed separately from Git.

The source repository includes a flight regression test. Run Godot with `--headless --path <project-directory> --script <absolute-path-to-qa/flight_check.gd>`.

## Credits and AI declaration

Terrain, spacecraft, astronaut, HUD and lighting are generated with Godot drawing primitives and a project shader. The four sound effects are project-synthesized WAV files. Text uses Godot’s bundled fallback font. ChatGPT and Codex assisted with design, implementation, sound generation, UI, testing, debugging, Android packaging and documentation.

## Competition handoff

Submit the signed APK, the cache-free project source and this README. Use the submission filename `BunyanAlMarsoos_LostSignal.zip` for the source archive. The guidelines allocate 90 minutes to development and close submissions two hours after the session starts. The starter guide requires an APK and lists Unity project files, while the mobile guidelines allow other engines. This submission supplies Godot source. Confirm the source-format discrepancy with the volunteer desk.
