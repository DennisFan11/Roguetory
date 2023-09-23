shader_type canvas_item;
uniform sampler2D ALPHA:filter_nearest;
void fragment() {
	vec4 text = texture(TEXTURE,UV);
	float alpha = texture(ALPHA,UV).r;
	COLOR = vec4(texture(TEXTURE,UV).rgb,alpha);
}