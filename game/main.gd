extends Node2D

# LOST SIGNAL: ESCAPE PLUTO
# One-scene, original-asset, Godot 4 top-down mobile jam game.
# All geometry is drawn with Godot primitives; no texture downloads required.
const WORLD_W := 2200.0
const WORLD_H := 1450.0
const SCREEN := Vector2(1280.0, 720.0)
const PLAYER_SPEED := 290.0
const VENT := Vector2(1820, 1140)
const PLAYER_RADIUS := 19.0

var ship := Vector2(265, 744)
var torch := Vector2(423, 740)
var player := Vector2(265, 744)
var facing := Vector2.RIGHT
var checkpoint := Vector2(265, 744)
var camera_origin := Vector2.ZERO
var joy := Vector2.ZERO
var stick_down := false
var stick_touch_id := -99
var pickup_time := 0.0
var pickup_position := Vector2.ZERO
var launch_time := 0.0
var mode := "intro"
var collected := 0
var torch_found := false
var lives := 3
var clock := 0.0
var time_elapsed := 0.0
var scan_cooldown := 0.0
var scan_show := 0.0
var hurt_invincible := 0.0
var message := ""
var message_time := 0.0
var walls: Array[Rect2] = []
var craters: Array[Dictionary] = []
var dust: Array[Dictionary] = []
var map_landmarks: Array[Vector2] = []
var parts: Array[Dictionary] = [
	{"name": "POWER CELL", "pos": Vector2(695, 335), "hint": "Cross the flickering electric field!", "color": Color(0.97, 0.73, 0.23)},
	{"name": "ENGINE CORE", "pos": Vector2(1250, 285), "hint": "Dodge the roaming space meteors!", "color": Color(1.0, 0.43, 0.36)},
	{"name": "NAV CHIP", "pos": Vector2(1895, 448), "hint": "Find a path through the rock maze!", "color": Color(0.51, 0.82, 1.0)},
	{"name": "FUEL MODULE", "pos": Vector2(1870, 1205), "hint": "Watch the icy vent before crossing!", "color": Color(0.58, 1.0, 0.65)},
	{"name": "TRANSMITTER", "pos": Vector2(850, 1125), "hint": "Avoid the radio-wave beacon!", "color": Color(0.93, 0.53, 1.0)}
]
var fog
var hud
var sfx: AudioStreamPlayer

func _ready() -> void:
	_build_world()
	sfx = AudioStreamPlayer.new()
	sfx.volume_db = -7.0
	add_child(sfx)

	# A tiny fragment shader creates the flashlight cone without images.
	var fog_layer := CanvasLayer.new()
	fog_layer.layer = 1
	add_child(fog_layer)
	fog = ColorRect.new()
	fog.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fog.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var material := ShaderMaterial.new()
	material.shader = load("res://fog.gdshader")
	fog.material = material
	fog_layer.add_child(fog)

	var hud_layer := CanvasLayer.new()
	hud_layer.layer = 2
	add_child(hud_layer)
	hud = Control.new()
	hud.set_script(load("res://hud.gd"))
	hud_layer.add_child(hud)
	hud.game = self
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE

	show_message("Tap to start your mission.", 4.0)
	_update_camera()

func _build_world() -> void:
	# Large scattered stone formations and a simple walkable maze.
	walls = [
		Rect2(480, 470, 200, 52), Rect2(760, 550, 85, 240),
		Rect2(970, 570, 380, 52), Rect2(1130, 800, 52, 260),
		Rect2(1500, 220, 45, 420), Rect2(1600, 570, 270, 46),
		Rect2(1710, 160, 45, 230), Rect2(1810, 370, 260, 44),
		Rect2(2040, 540, 44, 260), Rect2(1440, 730, 365, 45),
		Rect2(1360, 1000, 48, 250), Rect2(1040, 1050, 220, 46),
		Rect2(500, 1020, 54, 250), Rect2(640, 910, 260, 45)
	]
	craters = [
		{"p": Vector2(1450, 1155), "r": 72.0},
		{"p": Vector2(1665, 1040), "r": 98.0},
		{"p": Vector2(1970, 965), "r": 75.0},
		{"p": Vector2(2100, 1195), "r": 65.0},
		{"p": Vector2(1720, 1305), "r": 62.0},
		{"p": Vector2(316, 1080), "r": 63.0},
		{"p": Vector2(955, 845), "r": 64.0}
	]
	var rng := RandomNumberGenerator.new()
	rng.seed = 26026
	for i in range(480):
		dust.append({"p": Vector2(rng.randf_range(12, WORLD_W-12), rng.randf_range(12, WORLD_H-12)), "r": rng.randf_range(1.0, 4.2), "alpha": rng.randf_range(0.07, 0.28)})
	for i in range(25):
		map_landmarks.append(Vector2(rng.randf_range(0, WORLD_W), rng.randf_range(0, WORLD_H)))

func _process(delta: float) -> void:
	delta = minf(delta, 0.05)
	clock += delta
	pickup_time = maxf(0, pickup_time - delta)
	if message_time > 0:
		message_time -= delta
	if scan_cooldown > 0:
		scan_cooldown = maxf(scan_cooldown - delta, 0.0)
	if scan_show > 0:
		scan_show -= delta
	if hurt_invincible > 0:
		hurt_invincible -= delta

	if mode == "launch":
		launch_time += delta
		if launch_time >= 2.5:
			mode = "win"

	if mode == "playing":
		time_elapsed += delta
		var direction := joy
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			direction.x -= 1
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			direction.x += 1
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
			direction.y -= 1
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			direction.y += 1
		direction = direction.limit_length(1.0)
		if direction.length_squared() > 0.01:
			facing = direction.normalized()
			var travel := direction * PLAYER_SPEED * delta
			if not _blocked(player + Vector2(travel.x, 0)):
				player.x += travel.x
			if not _blocked(player + Vector2(0, travel.y)):
				player.y += travel.y
		_check_collectibles()
		_check_hazards()

	_update_camera()
	if fog != null:
		fog.material.set_shader_parameter("facing", facing)
		fog.material.set_shader_parameter("has_torch", torch_found)
		var hero_uv := (player - camera_origin) / SCREEN
		fog.material.set_shader_parameter("hero_screen", hero_uv)
		fog.material.set_shader_parameter("torch_radius", 0.13 if not torch_found else (0.63 if scan_show > 0 else 0.42))
		fog.material.set_shader_parameter("darkness", 0.93 if not torch_found else 0.70)
		fog.material.set_shader_parameter("aspect", SCREEN.x / SCREEN.y)
	queue_redraw()
	if hud != null:
		hud.queue_redraw()

func _update_camera() -> void:
	camera_origin = player - SCREEN * 0.5
	if mode == "intro":
		camera_origin += Vector2(250, -170) * pow(maxf(0, 1 - clock / 2), 2)
	camera_origin.x = clampf(camera_origin.x, 0.0, WORLD_W - SCREEN.x)
	camera_origin.y = clampf(camera_origin.y, 0.0, WORLD_H - SCREEN.y)

func _blocked(p: Vector2) -> bool:
	if p.x < 26 or p.y < 26 or p.x > WORLD_W - 26 or p.y > WORLD_H - 26:
		return true
	for block in walls:
		if block.grow(PLAYER_RADIUS - 3).has_point(p):
			return true
	for crater in craters:
		if p.distance_to(crater["p"]) < float(crater["r"]) + PLAYER_RADIUS - 6:
			return true
	return false

func _check_collectibles() -> void:
	if not torch_found:
		if player.distance_to(torch) < 52.0:
			torch_found = true
			checkpoint = player
			scan_show = 2.0
			show_message("TORCH FOUND! Follow the gold marker on your mini-map.", 3.5)
			play_sound("collect")
		return
	if collected < parts.size():
		var current: Dictionary = parts[collected]
		if player.distance_to(current["pos"]) < 47.0:
			pickup_position = current["pos"]
			pickup_time = 0.6
			collected += 1
			checkpoint = pickup_position
			if collected == 2:
				checkpoint += Vector2(-60, 0) # Sheltered side of the meteor lane.
			hurt_invincible = 1.8
			play_sound("collect")
			if collected == parts.size():
				show_message("ALL PARTS RECOVERED! Return to the blue ship marker!", 4.0)
			else:
				show_message("%s RECOVERED! Next: %s" % [current["name"], parts[collected]["name"]], 3.3)
	elif player.distance_to(ship) < 86.0:
		mode = "launch"
		launch_time = 0.0
		show_message("HULL SEALED   /   Launch sequence engaged", 2.5)
		joy = Vector2.ZERO
		play_sound("win")

func _check_hazards() -> void:
	if hurt_invincible > 0:
		return
	# Challenge 1: time the flickering high-voltage barrier.
	if fmod(clock, 3.0) < 1.65:
		if Rect2(615, 388, 175, 20).grow(PLAYER_RADIUS).has_point(player):
			take_damage("Electric shock! Wait for the pulse to stop.")
			return
	# Challenge 2: moving meteors; two independent paths.
	for i in range(2):
		var hazard_pos := meteor_position(i)
		if player.distance_to(hazard_pos) < 39:
			take_damage("Meteor impact! Keep moving.")
			return
	if fmod(clock, 4.0) >= 3.0 and player.distance_to(VENT) < 70:
		take_damage("Cryovent eruption! Cross when the rim fades.")
		return
	# Challenge 5: a radio beacon sends out dangerous expanding rings.
	var ring_dist := fmod(clock, 4.5) * 85.0
	if player.distance_to(Vector2(850, 1125)) > 60.0 and ring_dist <= 225.0 and absf(player.distance_to(Vector2(850, 1125)) - ring_dist) < 13.0:
		if player.distance_to(Vector2(850, 1125)) < 225.0:
			take_damage("Signal pulse! Watch the expanding ring.")
			return

func meteor_position(index: int) -> Vector2:
	if index == 0:
		return Vector2(1050.0 + sin(clock * 1.6) * 160.0, 405.0)
	return Vector2(1260.0, 335.0 + cos(clock * 1.95) * 115.0)

func take_damage(reason: String) -> void:
	lives -= 1
	hurt_invincible = 2.0
	play_sound("hit")
	if lives <= 0:
		mode = "dead"
		joy = Vector2.ZERO
		stick_down = false
		stick_touch_id = -99
		show_message("Suit integrity lost!", 2.0)
	else:
		player = checkpoint
		show_message(reason + " Back to checkpoint!", 3.0)

func objective_text() -> String:
	if mode == "win":
		return "HOME BOUND - MISSION COMPLETE"
	if not torch_found:
		return "FIND THE TORCH (GOLD BEACON)"
	if collected < parts.size():
		return "FIND %s - %s" % [parts[collected]["name"], parts[collected]["hint"]]
	return "RETURN TO CRASHED SHIP FOR REPAIR"

func get_target_position() -> Vector2:
	if not torch_found:
		return torch
	if collected < parts.size():
		return parts[collected]["pos"]
	return ship

func show_message(s: String, duration: float) -> void:
	message = s
	message_time = duration

func activate_scan() -> void:
	if mode != "playing" or not torch_found or scan_cooldown > 0:
		return
	scan_cooldown = 5.0
	scan_show = 2.0
	show_message("ECHO SCAN: Follow the glowing signal!", 2.2)
	play_sound("scan")

func restart_game() -> void:
	mode = "playing"
	clock = 0.0
	pickup_time = 0.0
	stick_down = false
	stick_touch_id = -99
	player = ship
	checkpoint = ship
	collected = 0
	torch_found = false
	lives = 3
	time_elapsed = 0.0
	scan_cooldown = 0.0
	scan_show = 0.0
	hurt_invincible = 0.0
	joy = Vector2.ZERO
	show_message("Emergency landing. Find the torch to restore visibility!", 4.0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			if mode in ["intro", "dead", "win"]:
				restart_game()
		if event.keycode == KEY_SPACE:
			activate_scan()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_touch_start(hud.pointer_position(event.position), event.index)
		elif stick_touch_id == event.index:
			stick_down = false
			stick_touch_id = -99
			joy = Vector2.ZERO
	elif event is InputEventScreenDrag:
		if event.index == stick_touch_id:
			joy = (hud.pointer_position(event.position) - Vector2(118, 598)).limit_length(72.0) / 72.0
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if stick_touch_id >= 0:
			return
		if event.pressed:
			_touch_start(hud.pointer_position(event.position), -1)
		elif stick_touch_id == -1:
			stick_down = false
			stick_touch_id = -99
			joy = Vector2.ZERO
	elif event is InputEventMouseMotion and stick_touch_id == -1:
		joy = (hud.pointer_position(event.position) - Vector2(118, 598)).limit_length(72.0) / 72.0

func _touch_start(screen_position: Vector2, touch_id: int) -> void:
	if mode in ["intro", "dead", "win"]:
		restart_game()
		return
	if mode != "playing":
		return
	if not stick_down and screen_position.distance_to(Vector2(118, 598)) < 145:
		stick_down = true
		stick_touch_id = touch_id
		joy = (screen_position - Vector2(118, 598)).limit_length(72.0) / 72.0
	elif screen_position.distance_to(Vector2(1150, 608)) < 125:
		activate_scan()

func play_sound(which: String) -> void:
	var path := "res://audio/%s.wav" % which
	if ResourceLoader.exists(path):
		sfx.stream = load(path)
		sfx.play()

func _draw() -> void:
	# Camera-relative 2D world, with original geometry drawn in code.
	draw_set_transform(-camera_origin)
	draw_rect(Rect2(0, 0, WORLD_W, WORLD_H), Color(0.105, 0.12, 0.22))
	draw_circle(Vector2(440, 600), 580, Color(0.15, 0.16, 0.28, 0.30))
	draw_circle(Vector2(1700, 1000), 760, Color(0.18, 0.17, 0.28, 0.28))
	# Cull off-screen dust: saves draw calls on low-end Android phones.
	var visible_world := Rect2(camera_origin - Vector2(20, 20), SCREEN + Vector2(40, 40))
	for d in dust:
		if visible_world.has_point(d["p"]):
			draw_circle(d["p"], d["r"], Color(0.80, 0.89, 1.0, d["alpha"]))
	# Surface grid, landmarks and illuminated dust trails.
	for x in range(0, int(WORLD_W), 180):
		draw_line(Vector2(x, 0), Vector2(x, WORLD_H), Color(0.32, 0.38, 0.52, 0.11), 1.0)
	for y in range(0, int(WORLD_H), 180):
		draw_line(Vector2(0, y), Vector2(WORLD_W, y), Color(0.32, 0.38, 0.52, 0.11), 1.0)
	for crater in craters:
		var center: Vector2 = crater["p"]
		var r: float = crater["r"]
		draw_circle(center, r + 13, Color(0.34, 0.32, 0.46, 0.80))
		draw_circle(center, r, Color(0.045, 0.055, 0.11, 1.0))
		draw_arc(center, r + 6, 0, TAU, 38, Color(0.55, 0.52, 0.66, 0.45), 5)
	for wall in walls:
		draw_rect(wall.grow(6), Color(0.035, 0.052, 0.10))
		draw_rect(wall, Color(0.36, 0.35, 0.51))
		draw_rect(wall.grow(-5), Color(0.26, 0.29, 0.44), false, 3.0)

	# Broken spaceship: exactly where the player must return after collecting all parts.
	draw_circle(ship, 92, Color(0.12, 0.46, 0.64, 0.18))
	draw_arc(ship, 83, 0, TAU, 42, Color(0.36, 0.81, 1.0, 0.75), 3)
	var craft := ship + Vector2(0, -100 * launch_time * launch_time) if mode in ["launch", "win"] else ship
	if mode == "launch":
		draw_circle(craft + Vector2(0, 36), 15 + 5 * sin(clock * 40), Color.CORAL)
	var hull := PackedVector2Array([craft + Vector2(-58, 28), craft + Vector2(26, -46), craft + Vector2(79, 24), craft + Vector2(9, 57)])
	draw_colored_polygon(hull, Color(0.40, 0.58, 0.79))
	draw_circle(craft + Vector2(12, 3), 23, Color(0.08, 0.34, 0.52))
	draw_line(craft + Vector2(-26, -19), craft + Vector2(40, 40), Color(1.0, 0.44, 0.31), 6)
	_label_world("CRASH SITE", ship + Vector2(-62, 116), 18, Color(0.57, 0.85, 1.0))

	# First recovery item: flashlight.
	if not torch_found:
		_glow(torch, 29, Color(1.0, 0.91, 0.45))
		draw_rect(Rect2(torch - Vector2(10, 18), Vector2(20, 36)), Color(1.0, 0.90, 0.46))
		_label_world("TORCH", torch + Vector2(-29, -42), 18, Color(1.0, 0.90, 0.45))

	# All five unique ship parts, with the current target most prominent.
	for i in range(parts.size()):
		if i < collected:
			continue
		var item: Dictionary = parts[i]
		var p: Vector2 = item["pos"]
		var active := i == collected and torch_found
		var tint: Color = item["color"] if active else Color(0.55, 0.55, 0.65, 0.40)
		if active:
			_glow(p, 35.0, tint)
			draw_arc(p, 48 + sin(clock * 4.0) * 3.0, 0, TAU, 36, Color(tint.r, tint.g, tint.b, 0.76), 3.0)
		draw_colored_polygon(PackedVector2Array([p + Vector2(0, -24), p + Vector2(24, 0), p + Vector2(0, 24), p + Vector2(-24, 0)]), tint)
		if active:
			_label_world(item["name"], p + Vector2(-70, -61), 18, tint)

	if pickup_time > 0:
		draw_arc(pickup_position, 28 + (0.6 - pickup_time) * 105, 0, TAU, 40, Color(0.68, 1, 0.8, pickup_time / 0.6), 3)

	# Challenge 1: dangerous but periodic electrical current.
	var wire_color := Color(0.31, 0.82, 1.0, 0.90) if fmod(clock, 3.0) < 1.65 else Color(0.31, 0.82, 1.0, 0.20)
	draw_rect(Rect2(615, 388, 175, 20), wire_color)
	draw_circle(Vector2(615, 398), 15, Color(0.23, 0.68, 1.0))
	draw_circle(Vector2(790, 398), 15, Color(0.23, 0.68, 1.0))
	_label_world("PULSE FIELD", Vector2(616, 375), 16, Color(0.65, 0.87, 1.0))

	# Challenge 2: two patrolling meteors.
	for i in range(2):
		var m := meteor_position(i)
		draw_circle(m, 29, Color(0.95, 0.31, 0.32, 0.24))
		draw_circle(m, 23, Color(0.65, 0.35, 0.31))
		draw_circle(m + Vector2(-7, -6), 9, Color(0.87, 0.62, 0.44))
		draw_circle(m + Vector2(10, 8), 6, Color(0.39, 0.23, 0.27))

	var vent_phase := fmod(clock, 4.0)
	var vent_color := Color(0.52, 0.93, 1.0, 0.30 if vent_phase < 2.0 else 0.95)
	draw_arc(VENT, 70, 0, TAU, 42, vent_color, 3)
	if vent_phase >= 3.0:
		draw_circle(VENT, 70, Color(0.37, 0.82, 1, 0.52))
	elif vent_phase >= 2.0:
		draw_arc(VENT, 8 + 62 * (vent_phase - 2.0), 0, TAU, 34, vent_color, 3)
	# Challenge 5: expanding signal ring, best watched before crossing.
	var beacon := Vector2(850, 1125)
	var ring_radius := fmod(clock, 4.5) * 85.0
	if ring_radius <= 225.0:
		draw_arc(beacon, maxf(2.0, ring_radius), 0, TAU, 68, Color(0.95, 0.4, 0.86, 0.70), 6)
	draw_arc(beacon, 225, 0, TAU, 68, Color(0.67, 0.40, 0.85, 0.22), 2)

	# Scanner line appears briefly, intentionally showing direction, not auto-navigation.
	if scan_show > 0 and torch_found:
		var target := get_target_position()
		draw_line(player, target, Color(0.52, 1.0, 0.70, 0.63), 4)
		draw_arc(target, 60 + 7 * sin(clock * 7.0), 0, TAU, 44, Color(0.6, 1.0, 0.72, 0.73), 3)

	# Astronaut: tiny backpack, suit, helmet and facing visor.
	if mode != "launch" and (hurt_invincible <= 0 or fmod(clock * 10.0, 1.0) < 0.52):
		draw_circle(player + Vector2(2, 7), 24, Color(0.02, 0.05, 0.10, 0.54))
		draw_rect(Rect2(player + Vector2(-23, -15), Vector2(13, 30)), Color(0.94, 0.46, 0.25))
		draw_circle(player, 19.0, Color(0.92, 0.96, 1.0))
		draw_circle(player + facing * 5.0, 11.0, Color(0.19, 0.57, 0.73))
		draw_circle(player + facing * 8.0 + Vector2(-3, -4), 3, Color(0.78, 0.99, 1.0))
		draw_arc(player, 24, 0, TAU, 24, Color(0.44, 0.74, 1.0, 0.55), 2)
	draw_set_transform(Vector2.ZERO)

func _glow(center: Vector2, radius: float, tint: Color) -> void:
	draw_circle(center, radius * 1.8, Color(tint.r, tint.g, tint.b, 0.09))
	draw_circle(center, radius * 1.3, Color(tint.r, tint.g, tint.b, 0.15))
	draw_arc(center, radius, 0, TAU, 32, Color(tint.r, tint.g, tint.b, 0.70), 3)

func _label_world(s: String, p: Vector2, size: int, tint: Color) -> void:
	draw_string(ThemeDB.fallback_font, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, tint)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		stick_down = false
		stick_touch_id = -99
		joy = Vector2.ZERO
