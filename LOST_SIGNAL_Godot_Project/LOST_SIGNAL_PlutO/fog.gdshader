shader_type canvas_item;

uniform vec2 hero_screen = vec2(0.5, 0.5);
uniform float torch_radius = 0.08;
uniform float darkness = 0.88;
uniform float aspect = 1.777778;

void fragment() {
    vec2 diff = (UV - hero_screen) * vec2(aspect, 1.0);
    float distance_to_hero = length(diff);
    float outer = smoothstep(torch_radius * 0.48, torch_radius, distance_to_hero);
    COLOR = vec4(0.015, 0.025, 0.065, outer * darkness);
}
