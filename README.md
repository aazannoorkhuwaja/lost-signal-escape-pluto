# Lost Signal: Escape Pluto

Pluto has gone silent. Sent to investigate, you crash on the surface with three suit lives and a broken ship. Find your torch to bring navigation back online, recover five scattered components, and make it back to the crash site.

**Team:** bunyan al marsoos

**Members:** Aazan Noor Khuwaja, Mushaf ALi Mir, Abbas Ahmed

[Watch the gameplay demo](https://github.com/aazannoorkhuwaja/lost-signal-escape-pluto/releases/download/pluto-campaign/LostSignal-demo.mp4) · [Download the Android APK](https://github.com/aazannoorkhuwaja/lost-signal-escape-pluto/releases/download/pluto-campaign/LostSignal.apk)

## How to play

On Android, hold the phone in landscape. Tap to start and use the left thumbstick to reach the torch east of the ship. Once the map lights up, follow the gold marker to the next part. Tap **SCAN** with your right thumb for a bearing through the dark. The scanner recharges in five seconds. Each recovered part saves a checkpoint. Return to the blue ship marker after the final recovery.

On desktop, press **Enter** to start, move with **WASD** or the **arrow keys**, and press **Space** to scan.

## Flights and scoring

Easy has five components. Medium adds a coolant pump and three unstable ice patches. Hard adds the flight recorder and three more fractures. The salmon-colored rims mark unsafe ice.

Each part earns 100 points on Easy, 200 on Medium and 300 on Hard. Launch adds 100 points per remaining life and a speed bonus of up to 300 points. Choose **Next** to carry the score forward, or **Replay level** to retry that flight. Finishing Hard unlocks the campaign replay. On desktop, Enter advances and R retries the current flight.

## Run from source

Open [game/project.godot](game/project.godot) in Godot 4.7.2 and press **F5**. The project includes an Android debug export preset. The [flight test](tests/flight_check.gd) covers the route from the torch to launch.

## Credits

The game uses procedural artwork, synthesized sound effects, and Godot’s bundled font. ChatGPT and Codex assisted with design, code, UI, sound generation, testing, Android packaging, and documentation.
