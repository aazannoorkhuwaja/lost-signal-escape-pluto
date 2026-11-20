shader_type canvas_item;

uniform vec2 hero_screen = vec2(0.5, 0.5);
uniform float torch_radius = 0.08;
uniform float darkness = 0.88;
uniform float aspect = 1.777778;

uniform vec2 facing = vec2(1.0, 0.0);
uniform vec2 beacon_screen;
uniform bool has_torch = false;

void fragment() {
    vec2 diff = (UV - hero_screen) * vec2(aspect, 1.0);
    float distance_to_hero = length(diff);
    float beam = smoothstep(0.50, 0.94, dot(diff / max(distance_to_hero, 0.0001), facing));
    float radius = torch_radius * (has_torch ? mix(0.6, 1.35, beam) : 1.0);
    float outer = smoothstep(radius * 0.48, radius, distance_to_hero);
    if (!has_torch) {
        float beacon_distance = length((UV - beacon_screen) * vec2(aspect, 1.0));
        outer *= mix(0.12, 1.0, smoothstep(0.035, 0.13, beacon_distance));
    }
    COLOR = vec4(0.015, 0.025, 0.065, outer * darkness);
}
