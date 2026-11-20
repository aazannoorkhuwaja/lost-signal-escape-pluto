extends Node2D

const ICE := Color("#9fe4e6")
const GOLD := Color("#ffd37d")
const PLATFORMS := [Rect2(-480,420,1120,140), Rect2(704,400,334,160), Rect2(1090,352,225,208), Rect2(1360,298,245,262), Rect2(1650,356,260,204), Rect2(1960,414,670,146)]
const PARTS := [Vector2(520,378),Vector2(1490,255),Vector2(2430,370)]
const NAMES := ["Power cell","Antenna","Thruster"]
var player := CharacterBody2D.new()
var collected := [false,false,false]
var scan_time := 0.0
var clock := 0.0
var launch := -1.0
var checkpoint := Vector2(160,380)
var status := Label.new()
var panel := Label.new()
var rock := Vector2.ZERO
var signal_target := Vector2.ZERO

func collider(parent: CollisionObject2D, size: Vector2) -> void:
	var box := RectangleShape2D.new()
	box.size = size
	var shape := CollisionShape2D.new()
	shape.shape = box
	parent.add_child(shape)

func _ready() -> void:
	for rect: Rect2 in PLATFORMS:
		var ground := StaticBody2D.new()
		ground.position = rect.get_center()
		collider(ground,rect.size)
		add_child(ground)
	add_child(player)
	player.position = checkpoint
	collider(player,Vector2(24,42))
	var camera := Camera2D.new()
	player.add_child(camera)
	camera.limit_left = -100
	camera.limit_right = 2630
	camera.limit_top = 0
	camera.limit_bottom = 540
	for i in PARTS.size():
		var area := Area2D.new()
		area.position = PARTS[i]
		collider(area,Vector2(46,54))
		add_child(area)
		area.body_entered.connect(func(body): 
			if body == player:
				collected[i] = true
				checkpoint = PARTS[i]
				scan_time = 0
				update_status()
		)
	var hud := CanvasLayer.new()
	add_child(hud)
	status.position = Vector2(24,16)
	status.add_theme_font_size_override("font_size",22)
	hud.add_child(status)
	panel.position = Vector2(295,116)
	panel.add_theme_font_size_override("font_size",32)
	hud.add_child(panel)
	for spec in [["left","A",38],["right","D",134],["scan","SCAN",735],["jump","JUMP",845]]:
		var action := String(spec[0])
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		var button := TouchScreenButton.new()
		button.action = action
		button.position = Vector2(spec[2],448)
		var tile := GradientTexture2D.new()
		tile.width = 84
		tile.height = 76
		tile.gradient = Gradient.new()
		tile.gradient.colors = PackedColorArray([Color("#35506a"),Color("#26304e")])
		button.texture_normal = tile
		hud.add_child(button)
		var label := Label.new()
		label.text = {"left":"◀","right":"▶"}.get(action,spec[1])
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.size = Vector2(84,76)
		button.add_child(label)
	update_status()


func update_status() -> void:
	status.text = "LOST SIGNAL    /    PLUTO     •     %d/3\n%s" % [collected.count(true),"Return to the ship" if collected.count(true)==3 else "Recover the ship parts   ·   Scan for a bearing"]

func _physics_process(dt: float) -> void:
	clock += dt
	if launch >= 0:
		launch += dt
		if launch > 1.8:
			panel.text = "YOU SURVIVED!\nEarthbound   ·   Jump to replay"
			if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept"):
				get_tree().reload_current_scene()
		queue_redraw()
		return
	var direction := Input.get_axis("left","right")+Input.get_axis("ui_left","ui_right")
	player.velocity.x = clampf(direction,-1,1)*240
	player.velocity.y += 540*dt
	if player.is_on_floor() and (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")):
		player.velocity.y = -340
	player.move_and_slide()
	rock = Vector2(2200,-80+fmod(clock,2.5)*255)
	if player.position.y > 600 or player.position.distance_to(rock)<30:
		player.position = checkpoint
		player.velocity = Vector2.ZERO
	if Input.is_action_just_pressed("scan") or Input.is_action_just_pressed("ui_focus_next"):
		scan_time = 1.25
		signal_target = Vector2(100,380)
		var nearest := INF
		for i in PARTS.size():
			var distance := player.position.distance_to(PARTS[i])
			if not collected[i] and distance < nearest:
				nearest = distance
				signal_target = PARTS[i]
	scan_time -= dt
	if collected.count(true)==3 and player.position.distance_to(Vector2(100,390))<56:
		launch = 0
		status.text = "ALL SYSTEMS ONLINE    /    LIFTOFF"
	queue_redraw()

func _draw() -> void:
	for i in 185:
		draw_circle(Vector2(posmod(i*179,3190)-480,posmod(i*i*37,325)),1+i%2,Color("#a2a8cf"))
	draw_circle(Vector2(1030,105),47,Color("#bb9fcb"))
	for i in 17:
		var x := i*211-520
		draw_colored_polygon(PackedVector2Array([Vector2(x,510),Vector2(x+155,190+posmod(i*69,105)),Vector2(x+350,510)]),Color("#383857"))
	for rect: Rect2 in PLATFORMS:
		draw_rect(rect,Color("#4b486d"))
		draw_line(rect.position,rect.position+Vector2(rect.size.x,0),ICE,6)
		for j in int(rect.size.x/35):
			var p := rect.position+Vector2(j*35,4)
			draw_line(p,p+Vector2(12,10+j%4*4),Color("#777498"),2)
	var ship := Vector2(100,415-maxf(launch,0)*maxf(launch,0)*140)
	draw_colored_polygon(PackedVector2Array([ship+Vector2(-39,0),ship+Vector2(0,-68),ship+Vector2(39,0)]),Color("#e7c9ab"))
	draw_circle(ship+Vector2(0,-28),10,Color("#416777"))
	for i in PARTS.size():
		if not collected[i]:
			var p: Vector2 = PARTS[i]+Vector2(0,sin(clock*3)*3)
			draw_circle(p,19,Color("#695b57"))
			draw_arc(p,20,0,TAU,32,GOLD,2)
			draw_string(ThemeDB.fallback_font,p+Vector2(-6,7),str(i+1),HORIZONTAL_ALIGNMENT_LEFT,-1,21,GOLD)
			draw_string(ThemeDB.fallback_font,p+Vector2(-42,-30),NAMES[i],HORIZONTAL_ALIGNMENT_LEFT,-1,16,GOLD)
	draw_line(Vector2(2182,411),Vector2(2218,411),Color("#ff927e"),4)
	draw_circle(rock,14,Color("#cf826f"))
	if launch < 0:
		var p := player.position
		draw_rect(Rect2(p+Vector2(-10,0),Vector2(20,20)),Color("#deb985"))
		draw_circle(p+Vector2(0,-10),14,Color("#f4e3cc"))
		draw_rect(Rect2(p+Vector2(-8,-16),Vector2(19,10)),Color("#476077"))
		if scan_time>0:
			var d := p.direction_to(signal_target)
			var tip := p+d*68
			draw_line(p+d*25,tip,ICE,4)
			draw_line(tip,tip-d.rotated(0.6)*15,ICE,4)
			draw_line(tip,tip-d.rotated(-0.6)*15,ICE,4)
