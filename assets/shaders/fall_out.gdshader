shader_type canvas_item;

uniform sampler2D fall_texture;
uniform vec4 bg_color : source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if(color.a < 1.0){
		color = bg_color;
	}
	
	vec4 fall_color = texture(fall_texture, UV);
	color.a = fall_color.b;
	
	COLOR = color;
}
