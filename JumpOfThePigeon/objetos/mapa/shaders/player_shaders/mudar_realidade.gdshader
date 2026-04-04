shader_type canvas_item;

// 👇 substitui o SCREEN_TEXTURE
uniform sampler2D screen_texture : hint_screen_texture;

uniform float intensidade_flash : hint_range(0.0, 1.0) = 0.0;
uniform float distorcao : hint_range(0.0, 1.0) = 0.0;
uniform float tempo = 0.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    // 🌊 DISTORÇÃO
    float onda = sin((uv.y + tempo * 2.0) * 20.0) * 0.02 * distorcao;
    uv.x += onda;

    float onda2 = cos((uv.x + tempo * 2.0) * 15.0) * 0.02 * distorcao;
    uv.y += onda2;

    // 👇 pega a tela corretamente agora
    vec4 cor = texture(screen_texture, uv);

    // ⚡ FLASH
    cor.rgb += intensidade_flash;

    COLOR = cor;
}