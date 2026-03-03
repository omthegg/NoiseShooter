shader_type spatial;
render_mode unshaded;

uniform sampler2D noise_texture: filter_nearest;

void vertex() {
	// Billboard Mode: Y-Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}


vec2 rotateVec2(vec2 v, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	v -= pivot;
	return vec2(
		cosa * v.x - sina * v.y,
		cosa * v.y + sina * v.x 
	) + pivot;
}

void fragment() {
	//rotateVec2(UV, vec2(0.5, 0.5), TIME/5.0)
	vec2 coords = UV + vec2(-TIME/5.0, TIME/5.0);
	vec4 n = texture(noise_texture, coords);
	float distance_to_center = sqrt(pow(UV.x - 0.5, 2) + pow(UV.y - 0.5, 2));
	ALPHA = (0.5 - distance_to_center) * 4.0;
	ALBEDO = n.xyz * vec3(1.0, sin(TIME * 2.0), cos(TIME * 2.0));
	/*
	if (ALBEDO.x < 0.85)
	{
		ALBEDO = vec3(0.0, 0.0, 0.0);
	}
	*/
}
