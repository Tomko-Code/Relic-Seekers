shader_type canvas_item;

uniform float cutoff : hint_range(0.0, 1.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if( color.a >= 0.0 )
	{
		if( color.r > cutoff )
		{
			float disc = distance(UV, vec2(0.5, 0.5))*0.4;
			float norm_disc = abs(disc)*10.0;
			color = normalize(color) * vec4(norm_disc, 0.0, 0.0, 1.0);
		}
		else
		{
			color.a = 0.0;
		}
		
	}
	COLOR = color;
}
