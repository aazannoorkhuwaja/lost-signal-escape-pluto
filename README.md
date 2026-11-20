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

## 🎯 Game Jam themes — LOST × TINY WORLD

**Primary theme: LOST. Secondary inspiration: TINY WORLD.** Our game blends both announced prompts into one cohesive adventure:

- **LOST:** Pluto Station's signal goes silent, the crew loses its route, and the crash scatters critical spaceship components. With limited visibility, players must find a torch, navigate by mini-map and scanner, recover the parts, and find the way back to their spacecraft.
- **TINY WORLD:** The action takes place on a compact, miniature, top-down Pluto surface: one self-contained pocket world with recognizable craters, ice ridges, moving dangers and scattered equipment. A small astronaut explores this isolated world, where every landmark and recovered part matters.
- **How they connect:** The tiny world's terrain hides what was lost. Exploration, navigation, and restoring a way home—not simply collecting objects—drive the gameplay.

**One-line pitch:** *A lost signal strands a tiny explorer on a miniature Pluto. Find the parts, rebuild your ship, and bring the crew home.*

If the judges require **one official theme**, submit **LOST** as the selected theme; explain **TINY WORLD** as an additional visual and design influence rather than claiming two separately selected themes.

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
