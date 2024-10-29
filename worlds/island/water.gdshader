shader_type canvas_item;

uniform sampler2D oceanGradient;
uniform sampler2D noise: repeat_enable;
uniform float vScroll = 0.0;
uniform float hScroll = 0.0;

void fragment() {
	float noiseValue = texture(noise, vec2(UV.x, UV.y - TIME * vScroll)).x + texture(noise, vec2(UV.x + TIME * hScroll, UV.y - TIME * vScroll)).x;
	COLOR = vec4(texture(oceanGradient, vec2(noiseValue)));
}
