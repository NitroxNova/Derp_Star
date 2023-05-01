shader_type canvas_item;

uniform sampler2D gradient : hint_default_black;
uniform sampler2D overlay;

vec4 color_burn(vec4 base, vec4 blend){
	vec4 burn = 1.0 - (1.0 - base) / blend;
	burn = clamp(burn, vec4(0.0,0.0,0.0,0.0), vec4(1.0,1.0,1.0,1.0));
	burn = mix(base,burn,blend.a);
	return burn;
}

vec4 color_dodge(vec4 base, vec4 blend){
	vec4 dodge = base / (1.0 - blend);
	dodge = clamp(dodge, vec4(0.0,0.0,0.0,0.0), vec4(1.0,1.0,1.0,1.0));
	dodge = mix(base,dodge,blend.a);
	return dodge;
}

void fragment() {
	vec4 bg_mask = texture(TEXTURE,UV);
	vec4 bg_color = texture(gradient,vec2(bg_mask.r,0.0));
	vec4 overlay_color = texture(overlay,UV);
	vec4 blended_color = color_burn(bg_color,overlay_color);
	blended_color = color_dodge(blended_color,overlay_color);
	blended_color.a = bg_mask.a;
	COLOR = blended_color;
}