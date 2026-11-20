# Lost Signal: Escape Pluto

A top-down Android adventure built for the **LOST** theme at Coder’s Cup ’26, FAST NUCES Karachi. Pluto has stopped transmitting. After a crash landing, recover a torch, navigate five hazards and rebuild your spacecraft before your suit runs out of lives.

## Play locally

Open the [active Godot project](LOST_SIGNAL_Godot_Project/LOST_SIGNAL_PlutO/project.godot) in **Godot 4.7.2** and press **F5**. For Android, install the signed debug APK on an ARM phone running Android 7.0 or later. See the [player guide and credits](LOST_SIGNAL_Godot_Project/LOST_SIGNAL_PlutO/README.md) for mission details and the AI declaration.

| Action | Android | Desktop |
| --- | --- | --- |
| Start or replay | Tap the screen | Enter |
| Move | Left thumbstick | WASD or arrow keys |
| Scan after collecting the torch | Tap SCAN with a second finger | Space |

## Build and verify

Run these commands from the repository root. Set `GODOT` to your Godot 4.7.2 executable. Android export requires JDK 17, the Android SDK and the matching Android debug template configured in Godot.

```sh
GODOT=godot
project=LOST_SIGNAL_Godot_Project/LOST_SIGNAL_PlutO

"$GODOT" --headless --path "$project" --import
"$GODOT" --headless --path "$project" --script "$PWD/qa/flight_check.gd"
"$GODOT" --headless --path "$project" --export-debug Android "$PWD/LostSignal-debug.apk"
adb install -r LostSignal-debug.apk
```

The flight check walks all five missions and the return trip, then checks damage, restart and scanner input. Desktop mouse controls have been exercised at 960×540, 1440×720 and 960×720. The Android package passed signature and alignment checks. Physical-device testing is pending.

## Repository layout

| Location | Contents |
| --- | --- |
| [Active game](LOST_SIGNAL_Godot_Project/LOST_SIGNAL_PlutO/) | Scene, gameplay, HUD, shader, sound effects and Android export preset |
| [QA](qa/) | Headless gameplay regression |
| [Competition documents](docs/competition/) | Organizer guidelines and participant starter guide |
| [Archive](archive/) | Original source snapshot and reference recording |

## Prepare the submission

Fill in the team name and three member names in the [game README](LOST_SIGNAL_Godot_Project/LOST_SIGNAL_PlutO/README.md) and commit the update. Export the APK from that revision. Package the active game and its README with the following command, replacing the team name for submission.

```sh
git archive --format=zip --prefix=LostSignal/ --output=TeamName_LostSignal.zip \
  HEAD:LOST_SIGNAL_Godot_Project/LOST_SIGNAL_PlutO
```

The [mobile guidelines](docs/competition/mobile-game-guidelines.pdf) accept multiple engines. The [starter guide](docs/competition/participant-starter-guide.pdf) lists Unity source and requires an APK. Confirm Godot source acceptance with the organizers.
