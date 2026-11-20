extends Control

# Pure HUD drawing: no imported artwork or fonts needed.
const SW := 1280.0
const SH := 720.0
var game

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func text_at(label: String, pos: Vector2, size: int = 18, color: Color = Color.WHITE) -> void:
    draw_string(ThemeDB.fallback_font, pos, label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func panel(rect: Rect2, tint: Color = Color(0.06, 0.09, 0.17, 0.91)) -> void:
    draw_rect(rect, tint, true)
    draw_rect(rect, Color(0.33, 0.50, 0.71, 0.60), false, 1.4)

func _draw() -> void:
    if game == null:
        return
    # Keep the goal and the mission statistics in separate panels.
    # This avoids text overlap on small landscape Android displays.
    panel(Rect2(18, 14, 680, 96))
    text_at("LOST SIGNAL", Vector2(39, 48), 27, Color(0.46, 0.86, 1.0))
    text_at("ESCAPE PLUTO", Vector2(257, 48), 17, Color(0.77, 0.83, 0.94))
    text_at(game.objective_text(), Vector2(39, 81), 16, Color(1, 0.86, 0.46))

    panel(Rect2(714, 14, 296, 96))
    text_at("PARTS  %d / 5" % game.collected, Vector2(738, 47), 20, Color(0.74, 1.0, 0.73))
    text_at("LIVES  %d / 3" % game.lives, Vector2(738, 80), 18, Color(1.0, 0.61, 0.66))
    var seconds: int = int(game.time_elapsed)
    text_at("%02d:%02d" % [int(seconds / 60), seconds % 60], Vector2(898, 80), 17, Color(0.78, 0.85, 1.0))
    draw_rect(Rect2(738, 96, 244, 5), Color(0.15, 0.25, 0.37))
    draw_rect(Rect2(738, 96, 244.0 * float(game.collected) / float(game.parts.size()), 5), Color(0.43, 0.95, 0.73))

    # Mini-map: all positions are based on actual world coordinates.
    var mm := Rect2(1034, 16, 226, 170)
    panel(mm)
    text_at("NAVIGATION", Vector2(1051, 39), 15, Color(0.70, 0.85, 1.0))
    var area := Rect2(1050, 49, 193, 119)
    draw_rect(area, Color(0.09, 0.13, 0.24))
    draw_rect(area, Color(0.3, 0.42, 0.57), false, 1.0)
    for zone in game.map_landmarks:
        var mp: Vector2 = zone
        var p := Vector2(area.position.x + mp.x / game.WORLD_W * area.size.x, area.position.y + mp.y / game.WORLD_H * area.size.y)
        draw_circle(p, 2.5, Color(0.45, 0.57, 0.76))
    var ship_pos := map_pos(game.ship, area)
    draw_circle(ship_pos, 4, Color(0.31, 0.77, 1.0))
    var objective := map_pos(game.get_target_position(), area)
    draw_circle(objective, 5.3, Color(1.0, 0.79, 0.27))
    draw_arc(objective, 7, 0, TAU, 24, Color(1.0, 0.80, 0.25, 0.80), 1.3)
    var player_pos := map_pos(game.player, area)
    draw_circle(player_pos, 6.4, Color(0.47, 1.0, 0.57))
    draw_circle(player_pos, 2.5, Color(0.04, 0.12, 0.10))
    draw_line(player_pos, objective, Color(1, 0.83, 0.4, 0.38), 1.1)

    # Readable target arrow and distance even when the scanner is cooling down.
    var compass_center := Vector2(860, 156)
    var diff: Vector2 = game.get_target_position() - game.player
    var angle: float = diff.angle()
    draw_circle(compass_center, 31, Color(0.05, 0.12, 0.22, 0.85))
    draw_arc(compass_center, 29, 0, TAU, 48, Color(0.41, 0.84, 1.0, 0.75), 2.0)
    draw_colored_polygon(PackedVector2Array([
        compass_center + Vector2(23, 0).rotated(angle),
        compass_center + Vector2(-11, -11).rotated(angle),
        compass_center + Vector2(-11, 11).rotated(angle)
    ]), Color(1.0, 0.83, 0.38))
    text_at("TARGET %d m" % int(diff.length() / 10.0), Vector2(906, 160), 16, Color(0.84, 0.94, 1.0))

    # Virtual thumbstick. Also works with mouse when touch emulation is on.
    var jc := Vector2(118, 598)
    draw_circle(jc, 83, Color(0.12, 0.23, 0.37, 0.41))
    draw_arc(jc, 83, 0, TAU, 48, Color(0.41, 0.72, 0.91, 0.75), 3)
    draw_circle(jc + game.joy * 51, 33, Color(0.33, 0.73, 1.0, 0.82))
    text_at("MOVE", Vector2(91, 697), 15, Color(0.74, 0.84, 0.96))

    var sc := Vector2(1150, 608)
    var available: float = clampf(1.0 - game.scan_cooldown / 5.0, 0.0, 1.0)
    draw_circle(sc, 61, Color(0.12, 0.24, 0.31, 0.79))
    draw_arc(sc, 61, -PI / 2.0, -PI / 2.0 + TAU * available, 48, Color(0.34, 1.0, 0.78), 6)
    text_at("SCAN", Vector2(1124, 614), 20, Color(0.76, 1.0, 0.88))
    var scanner_status: String = "FIND TORCH" if not game.torch_found else ("READY" if game.scan_cooldown <= 0 else "%.1fs" % game.scan_cooldown)
    text_at(scanner_status, Vector2(1090, 698), 15, Color(0.73, 0.94, 0.92))
    text_at("EXPLORE  •  RECOVER  •  ESCAPE", Vector2(444, 688), 15, Color(0.66, 0.78, 0.92))

    # Short visible story/hint above bottom controls.
    if game.message_time > 0:
        panel(Rect2(288, 595, 702, 48), Color(0.03, 0.12, 0.19, 0.93))
        text_at(game.message, Vector2(303, 625), 17, Color(0.95, 0.95, 0.82))

    if game.mode == "intro":
        modal("LOST ON PLUTO", ["Your ship crashed. Five parts are missing.", "Find your TORCH, follow the mini-map, survive five trials.", "Recover every part and return to the ship.", "TAP ANYWHERE / PRESS ENTER TO START"])
    elif game.mode == "dead":
        modal("SIGNAL LOST", ["Your suit ran out of lives.", "Collected: %d / 5 components" % game.collected, "TAP ANYWHERE / PRESS ENTER TO RETRY"])
    elif game.mode == "win":
        modal("MISSION COMPLETE!", ["The engines are back online.", "Navigation confirmed: EARTH -- HOME.", "You escaped Pluto with all five components!", "TAP ANYWHERE / PRESS ENTER TO PLAY AGAIN"])

func map_pos(world: Vector2, area: Rect2) -> Vector2:
    return Vector2(area.position.x + world.x / game.WORLD_W * area.size.x, area.position.y + world.y / game.WORLD_H * area.size.y)

func modal(heading: String, lines: Array) -> void:
    draw_rect(Rect2(0, 0, SW, SH), Color(0.015, 0.025, 0.065, 0.83))
    panel(Rect2(246, 169, 788, 378), Color(0.055, 0.09, 0.20, 0.98))
    draw_rect(Rect2(267, 190, 746, 7), Color(0.34, 0.82, 1.0))
    text_at(heading, Vector2(312, 257), 38, Color(0.44, 0.91, 1.0))
    for i in range(lines.size()):
        text_at(str(lines[i]), Vector2(314, 326 + 46 * i), 21 if i != lines.size() - 1 else 18, Color(0.94, 0.95, 0.98) if i != lines.size() - 1 else Color(1, 0.82, 0.34))
