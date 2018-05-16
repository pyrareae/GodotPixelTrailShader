shader_type canvas_item;

uniform float blend = 0.5;
uniform int circle_count = 100;
uniform int circle_thickness = 1; //in px
uniform float circle_radius = 0.01;
uniform float radius_range = 5;
uniform bool box = false;

float auto_rand(inout float seed, vec2 uv){
	vec2 co = uv * seed;
    float num = fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	seed *= num;
	return num;
}
float fixed_rand(float seed, vec2 uv){
	vec2 co = uv * seed;
    float num = fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	return num;
}

void fragment() {
	float seed_outer = TIME;
	vec2 co = SCREEN_UV;
    vec4 scr = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	vec4 last = texture(TEXTURE, UV);
	vec4 color = last;
	
	
	for (int i = 0; i < circle_count; i++) {
		float seed = float(i) * 123.4 * fract(TIME);
		vec2 center = vec2(fixed_rand(seed, vec2(0.5, 0.5)), fixed_rand(seed*123.45, vec2(0.5, 0.5)));
		float pct = distance(UV, center);
		float radius = mix(circle_radius-(circle_radius*radius_range/2.0), circle_radius+(circle_radius*radius_range/2.0), fixed_rand(seed*123.45, center));
		float thickness = length(SCREEN_PIXEL_SIZE)*float(circle_thickness);
		if (box){
			if (abs(center.x - UV.x) < radius + thickness && abs(center.y - UV.y) < radius + thickness &&
				!(abs(center.x - UV.x) < radius && abs(center.y - UV.y) < radius) &&
				 auto_rand(seed_outer, UV) < blend) {
//				color = vec4(1.0, 0.0,0.0,0.4);
				color = scr;
			}
		} else {
			if (pct < radius+ length(SCREEN_PIXEL_SIZE)*float(circle_thickness) && pct > radius && auto_rand(seed_outer, UV) < blend) {
				color = scr;
//				color = vec4(1.0, 0.0,0.0,0.4);
				
			}
		}
	}
	
//	if (scr.a > 0.1) 
//		color = scr;
		
	
	
	COLOR = color;
}
