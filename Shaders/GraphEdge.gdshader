shader_type canvas_item;

uniform float speed = 1;
uniform vec4 color : source_color;

void fragment(){
    vec2 newuv = UV;
    newuv.x -= TIME * speed;
    vec4 c = texture(TEXTURE, newuv);
	c *= color;
    COLOR = c;
}