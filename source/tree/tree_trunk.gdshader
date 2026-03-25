shader_type spatial;

uniform sampler2D noise_texture;
uniform vec4 color:source_color;

void vertex() {
	float height = NODE_POSITION_WORLD.y + VERTEX.y;
	VERTEX.x += sin(height * 50.0)/5.0;
	VERTEX.z += sin(height * 50.0)/5.0;
}

void fragment() {
	vec4 trunk_texture = texture(noise_texture, UV);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
