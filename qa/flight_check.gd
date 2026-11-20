extends SceneTree

# Run with --headless --path <Godot project> --script <absolute path to this file>.
var failed := false
var game
var grid := AStarGrid2D.new()

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, detail: String) -> void:
	if not ok:
		failed = true
		printerr(detail)
		quit(1)

func run() -> void:
	game = load("res://main.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	grid.region = Rect2i(0, 0, 111, 73)
	grid.cell_size = Vector2(20, 20)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()
	for x in range(111):
		for y in range(73):
			var point := Vector2(x, y) * 20
			var live_wire := Rect2(615, 388, 175, 20).grow(19).has_point(point)
			var meteor_lane := (absf(point.y - 405) < 46 and absf(point.x - 1050) < 205) or (absf(point.x - 1260) < 40 and absf(point.y - 335) < 160)
			# Approach the engine from its sheltered west side.
			grid.set_point_solid(Vector2i(x, y), game._blocked(point) or live_wire or meteor_lane)
	game.restart_game()
	for leg in range(7):
		var target: Vector2 = game.get_target_position()
		if leg == 2:
			target += Vector2(-42, 0)
		var path := grid.get_point_path(Vector2i((game.player / 20).round()), Vector2i((target / 20).round()))
		if path.is_empty():
			printerr("No walking route for leg ", leg)
			quit(1)
			return
		# Wait at recovered parts to time the next crossing.
		var wait_frames := [0, 0, 468, 0, 42, 78, 0]
		game.joy = Vector2.ZERO
		for frame in range(wait_frames[leg]):
			game._process(1.0 / 60.0)
		path.append(target)
		var passed := false
		for point in path:
			for step in range(16):
				var offset: Vector2 = point - game.player
				if offset.length() < 1: break
				game.joy = offset.limit_length(game.PLAYER_SPEED / 60.0) / (game.PLAYER_SPEED / 60.0)
				game._process(1.0 / 60.0)
				passed = game.torch_found if leg == 0 else (game.collected >= leg if leg <= 5 else game.mode == "launch")
				if passed or game.lives < 3: break
			if passed or game.lives < 3: break
		if not passed:
			printerr("Walk failed on leg ", leg)
			quit(1)
			return
		print("Walked leg ", leg, " to ", target)
	for frame in range(160): game._process(1.0/60.0)
	check(game.lives == 3, "Route took damage")
	check(game.mode == "win", "Launch did not finish")
	game.restart_game()
	game._touch_start(Vector2(158,598), 2)
	game._touch_start(Vector2(118,598), 3)
	check(game.stick_touch_id == 2, "Second finger stole joystick")
	game.torch_found = true
	game._touch_start(Vector2(1150,608), 3)
	check(game.scan_cooldown == 5 and game.joy.x > 0, "Multitouch scan failed")
	game.player = Vector2(690,398)
	game._check_hazards()
	check(game.lives == 2 and game.player == game.checkpoint, "Checkpoint failed")
	for hazard in ["meteor", "vent", "wave"]:
		game.restart_game()
		game.clock = 3.2 if hazard == "vent" else 1.0
		match hazard:
			"meteor": game.player = game.meteor_position(0)
			"vent": game.player = game.VENT
			"wave": game.player = Vector2(935, 1125)
		game._check_hazards()
		check(game.lives == 2 and game.player == game.ship, hazard + " damage failed")
	game.take_damage("test")
	game.take_damage("test")
	check(game.mode == "dead", "Death failed")
	game.restart_game()
	check(game.lives == 3 and not game.torch_found and game.collected == 0, "Restart failed")
	if not failed: quit(0)
