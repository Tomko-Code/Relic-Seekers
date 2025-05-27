shader_type canvas_item;

uniform float radius_0 = 0.0;
uniform float radius_1 = 0.0;
uniform float radius_2 = 0.0;

const vec2 start_0 = vec2(0.6325, 0.5);
const vec2 start_1 = vec2(0.92, 0.83);
const vec2 start_2 = vec2(0.92, 0.158);

uniform sampler2D noise:repeat_enable;
uniform vec4 color:source_color;

void fragment() {
	vec2 scale = vec2(480.f,480.f) / 2.;
	vec2 pixel_pos = (UV * scale) ;
	vec2 pixel_cord = floor(pixel_pos) / scale;
	
	//vec2 pixel_cord = floor(pixel_pos) / scale;
	//
	pixel_pos.x += TIME;
	vec2 pixel_noise_cord = floor(pixel_pos) / scale;
	
	float mask_0 = 1.0 - smoothstep(radius_0-0.1, radius_0, length(UV.xy - start_0));
	float mask_1 = 1.0 - smoothstep(radius_1-0.1, radius_1, length(UV.xy - start_1));
	float mask_2 = 1.0 - smoothstep(radius_2-0.1, radius_2, length(UV.xy - start_2));
	
	float noise_mag = texture(noise, pixel_cord).r * 20.;
	
	if(COLOR.r == 1. && COLOR.a == 1.)
	{
		COLOR = color + (0.3 * abs(sin(TIME + noise_mag)));
		COLOR *= mask_0;
	}
	
	if(COLOR.r == 1.0  && COLOR.a < 1. && COLOR.a > .66)
	{
		COLOR = color + (0.3 * abs(sin(TIME + noise_mag)));	
		COLOR *= mask_1;
	}
	
	if(COLOR.r == 1.0  && COLOR.a < .66 && COLOR.a > .33)
	{
		COLOR = color + (0.3 * abs(sin(TIME + noise_mag)));	
		COLOR *= mask_2;
	}
}