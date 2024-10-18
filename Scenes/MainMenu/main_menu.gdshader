shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec2 scroll = vec2(0.03, 0);

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 noise_col = texture(noise, UV + scroll * TIME);
	COLOR = noise_col;
}