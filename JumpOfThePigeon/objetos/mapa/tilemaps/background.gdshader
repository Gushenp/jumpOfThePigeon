shader_type canvas_item;

uniform float intensidade = 0.4; // 1 = normal, 0 = preto total

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    tex.rgb *= intensidade;
    COLOR = tex;
}