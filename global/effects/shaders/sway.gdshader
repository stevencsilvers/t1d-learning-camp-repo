shader_type canvas_item;

uniform float speed = 1.0;
uniform float magnitude = 16.0;
uniform float offset = 0.0;

void vertex() {
	float time = TIME * speed + offset;

	VERTEX.x += sin((1.0 - UV.y) * time) * magnitude;

}
