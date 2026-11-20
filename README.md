<h1 align="center">Lost Signal: Escape Pluto</h1>
<p align="center"><strong>A transmission cuts out in Pakistan. Three astronauts go looking for its source.</strong><br>
A landscape Android adventure by bunyan al marsoos.</p>
<p align="center">
  <a href="https://github.com/aazannoorkhuwaja/lost-signal-escape-pluto/releases/tag/pluto-campaign"><img alt="Crew Edition release" src="https://img.shields.io/badge/release-Crew_Edition-307156"></a>
  <img alt="Android 7.0 or later" src="https://img.shields.io/badge/Android-7.0%2B-384757">
  <img alt="Built with Godot 4.7.2" src="https://img.shields.io/badge/Godot-4.7.2-46789b">
</p>
<p align="center">
  <a href="https://github.com/aazannoorkhuwaja/lost-signal-escape-pluto/releases/download/pluto-campaign/LostSignal.apk">Download for Android</a> ·
  <a href="https://github.com/aazannoorkhuwaja/lost-signal-escape-pluto/releases/download/pluto-campaign/LostSignal-demo.mp4">Watch the gameplay demo</a>
</p>

## 🎯 Game Jam themes — LOST × TINY WORLD × DON'T TOUCH

**Primary theme: LOST. Supporting themes: TINY WORLD and DON'T TOUCH.**

Our game combines all three themes, but **LOST is the heart of the story, objectives, and player experience**:

- **🧭 LOST — Main theme:** Pluto Station's signal disappears, the crew loses its route, and the spaceship crashes. Critical parts are scattered across the surface. With limited visibility, the astronauts must find a torch, follow scanner and mini-map clues, recover missing components, and find their way home.
- **🪐 TINY WORLD — Setting and exploration:** The adventure unfolds on a compact, top-down interpretation of Pluto: a small, isolated world of ice ridges, craters, rocks, hazards, and hidden components. Every landmark matters when you are lost.
- **⚡ DON'T TOUCH — Survival mechanic:** Dangerous meteors, electrical hazards, crater zones, and moving obstacles force players to navigate carefully. Contact with hazards can cost lives or end a recovery attempt, making avoidance an essential part of reaching each lost component.

**How the themes work together:** You are **LOST** on a **TINY WORLD**, where you must **DON'T TOUCH** dangerous obstacles while recovering your spacecraft and finding a way home.

**One-line pitch:** *Lost on a tiny Pluto, three astronauts dodge deadly hazards, recover their scattered ship parts, and fight to find a way home.*

**For judges:** **LOST is our primary submission theme.** TINY WORLD strengthens the setting and level design; DON'T TOUCH strengthens the obstacle-avoidance gameplay. They support the LOST experience rather than replacing its central premise.

## 📡 The last transmission

In this fictional mission, the night shift at SUPARCO Mission Control in Pakistan is listening to a weather report from Pluto Station when the transmission cuts off. Abbas Ahmed, Aazan Noor Khuwaja and Mushaf ALi Mir launch for Pluto. Without the station’s landing beacon, the crew spots an ice ridge too late. The hull splits, and the first five components skid out of sight.

Abbas has a torch somewhere east of the wreck. That’s all the crew has to navigate by until he finds it.

### 🎮 Watch the gameplay

![Lost Signal: Escape Pluto — looping gameplay preview with scanner, obstacles, part recovery and level progression](docs/images/gameplay-demo.gif)

*Autoplaying, looping preview from the published Campaign Edition. [Watch the full gameplay video](https://github.com/aazannoorkhuwaja/lost-signal-escape-pluto/releases/download/pluto-campaign/LostSignal-demo.mp4).*

## 🧑‍🚀 Meet the crew

The three members of **bunyan al marsoos** appear as the astronauts you play, one per level.

| Flight | Astronaut | Recovery |
| --- | --- | --- |
| Easy | **Abbas Ahmed** | Find the torch, recover the first five parts and get the craft off the ice. |
| Medium | **Aazan Noor Khuwaja** | Recover six parts, including the coolant pump. Three fractured ice patches cut across the route. |
| Hard | **Mushaf ALi Mir** | Bring back all seven parts, including the flight recorder. Six fractures guard the route home to Pakistan. |

## 📱 Install and play

The public `pluto-campaign` release currently carries the downloadable APK and gameplay demo. The newer `pluto-crew` release is still a draft; its assets are not publicly accessible until it is published.



1. Download **LostSignal.apk** from the release linked above. Open it on an ARM Android phone running Android 7.0 or later.
2. Hold the phone in landscape. Tap to begin Abbas’s flight. Move east to pick up the torch and bring the map online.
3. Follow **gold** to the next component. **Green** marks your astronaut and **blue** marks the ship. Tap **SCAN** for a bearing. It recharges in five seconds. Return to the ship after the final pickup.

| Action | Android | Desktop |
| --- | --- | --- |
| Move | Drag the left thumbstick | WASD or arrow keys |
| Scan | Tap SCAN with your right thumb | Space |
| Advance after launch | Tap Next | Enter |
| Retry the current flight | Tap Replay level or Retry level | R |

Each recovery saves a checkpoint. A part earns 100 points for Abbas, 200 for Aazan and 300 for Mushaf. Launch adds 100 points per remaining life and up to 300 for speed. Advancing banks the score. A retry resets only the current flight’s points.

## 🛠 Run from source

Open [game/project.godot](game/project.godot) in Godot 4.7.2 and press **F5**. Press **Enter** to start or skip the opening. The Android export preset is included. To run the [campaign regression test](tests/flight_check.gd) from the repository root:

```sh
godot --headless --path game --import
godot --headless --path game --script "$PWD/tests/flight_check.gd"
```

## Credits

Built for the **LOST** theme at Coder’s Cup ’26, with **TINY WORLD** as a second creative interpretation. The terrain, spacecraft and lighting are drawn in Godot. Sound effects are synthesized, and text uses Godot’s bundled font. ChatGPT and Codex assisted with design, code, interface, sound generation, testing, Android packaging and documentation.
