shader_type spatial;

uniform float scale = 1.0;
uniform vec3 glow_color = vec3(0,0,1);

vec2 rand2(vec2 coord) {
	return fract(sin(vec2(dot(coord, vec2(127.1, 311.7)), dot(coord, vec2(269.5, 183.3)))) * 43758.5453);
}

float voronoi_noise(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float min_dist = 999999.0;
	for(float x = -1.0; x <= 1.0; ++x) {
		for(float y = -1.0; y <= 1.0; ++y) {
			vec2 node = rand2(i + vec2(x,y)) + vec2(x,y);
			
			float dist = sqrt((f-node).x * (f-node).x + (f-node).y * (f-node).y);
			min_dist = min(min_dist, dist);
		}
	}
	
	return min_dist;
}

void fragment() {
	const float PI = 3.14159265358979323846;
	vec2 coord = UV;
	coord *= scale;
	coord.x = sin(coord.x*PI);
	coord.x += 1.1*TIME;
	coord.y += 2.0*TIME;
	float value = voronoi_noise(coord);
	value = value*value*value;
	ALBEDO = vec3(0,0,0);//value*value);
	EMISSION = value * glow_color;
	//NORMALMAP = vec3(0,0,10.0*value);
}