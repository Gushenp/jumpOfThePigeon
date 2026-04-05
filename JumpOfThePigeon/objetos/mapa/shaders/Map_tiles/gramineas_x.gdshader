shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 20.0) = 5.0;
uniform float speed     : hint_range(0.0, 5.0)  = 1.5;
uniform float stiffness : hint_range(0.0, 1.0)  = 0.5;

void vertex() {
    // UV.y = 0 no topo do tile (pontas da grama), 1 na base (raiz — imóvel)
    // Inverte a lógica: agora a BASE fica parada e o TOPO se mexe
    float sway_factor = (1.0 - UV.y);
    sway_factor = sway_factor * sway_factor * (1.0 - stiffness);

    // Hash barata por tile (mesma técnica otimizada de antes)
    float tile_seed  = dot(floor(VERTEX / 16.0 + 0.5), vec2(127.1, 311.7));
    float h1 = fract(tile_seed * 0.1031);
    float h2 = fract((tile_seed + 7.0) * 0.1031 + h1);

    float tile_phase     = h1 * TAU;
    float freq_variation = 0.7 + h2 * 0.6;

    float t = TIME * speed * freq_variation;

    // Movimento principal + harmônico suave
    float wave  = sin(t + tile_phase);
    float wave2 = sin(t * 1.6 + tile_phase + 0.9) * 0.25;

    // Grama se move mais no eixo X, com leve achatamento no Y
    VERTEX.x += (wave + wave2) * amplitude * sway_factor;
    VERTEX.y += abs(wave) * amplitude * sway_factor * 0.04;
}