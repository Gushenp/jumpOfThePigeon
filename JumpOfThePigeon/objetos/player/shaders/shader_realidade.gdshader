shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// controle geral
uniform float intensidade : hint_range(0.0, 1.0) = 0.0;

// controles finos (pra você ajustar depois)
uniform float forca_onda = 0.003;
uniform float velocidade_onda = 8.0;

uniform float forca_rgb = 0.005;
uniform float forca_glitch = 0.01;

uniform float ghost_intensidade = 0.1;

void fragment() {
	vec2 uv = UV;

	// 🌊 distorção suave
	float onda = sin(uv.y * 15.0 + TIME * velocidade_onda) * forca_onda * intensidade;
	uv.x += onda;

	// 🎲 glitch raro (mais controlado)
	float glitch = step(0.95, sin(TIME * 10.0)) * intensidade;

	// 🎨 separação RGB (suave)
	vec2 offset = vec2(forca_rgb * intensidade + glitch * forca_glitch, 0.0);

	float r = texture(SCREEN_TEXTURE, uv + offset).r;
	float g = texture(SCREEN_TEXTURE, uv).g;
	float b = texture(SCREEN_TEXTURE, uv - offset).b;

	vec4 cor = vec4(r, g, b, 1.0);

	// 👻 duplicação leve (ghost)
	vec4 ghost = texture(SCREEN_TEXTURE, uv + offset * 2.0);
	cor.rgb = mix(cor.rgb, ghost.rgb, ghost_intensidade * intensidade);

	// 📺 linhas glitch suaves
	if (fract(uv.y * 8.0 + TIME * 3.0) < 0.03 * intensidade) {
		cor.rgb *= 0.85;
	}

	// ⚫ flash preto (suave e elegante)
	float flash_preto = sin(intensidade * 3.1415);
	flash_preto = pow(flash_preto, 4.0);
	cor.rgb *= (1.0 - flash_preto * 0.8);

	COLOR = cor;
}