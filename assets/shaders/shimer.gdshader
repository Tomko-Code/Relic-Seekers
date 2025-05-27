shader_type canvas_item;

uniform sampler2D noise:repeat_enable;
uniform vec4 color:source_color;
uniform vec2 scale;

void fragment() {
	vec2 pixel_pos = (UV * scale) ;
	vec2 pixel_cord = floor(pixel_pos) / scale;
	float noise_mag = texture(noise, pixel_cord).r * 20.;
	
	if(COLOR.r == 1. && COLOR.a == 1.)
	{
		COLOR = color + (0.3 * abs(sin(TIME + noise_mag)));
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
