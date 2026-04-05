shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 20.0) = 5.0;
uniform float speed     : hint_range(0.0, 5.0)  = 1.5;
uniform float stiffness : hint_range(0.0, 1.0)  = 0.5;

void vertex() {
    // Para grama na parede vertical, o movimento é no eixo Y
    // UV.x = 0 é a borda colada na parede (imóvel), UV.x = 1 é a ponta livre
    float sway_factor = UV.x * UV.x * (1.0 - stiffness);

    // Hash barata por tile
    float tile_seed  = dot(floor(VERTEX / 16.0 + 0.5), vec2(127.1, 311.7));
    float h1 = fract(tile_seed * 0.1031);
    float h2 = fract((tile_seed + 7.0) * 0.1031 + h1);

    float tile_phase     = h1 * TAU;
    float freq_variation = 0.7 + h2 * 0.6;

    float t = TIME * speed * freq_variation;

    float wave  = sin(t + tile_phase);
    float wave2 = sin(t * 1.6 + tile_phase + 0.9) * 0.25;

    // Movimento no eixo Y (pra cima e pra baixo) em vez de X
    VERTEX.y += (wave + wave2) * amplitude * sway_factor;
    // Leve compressão no X nas pontas
    VERTEX.x += abs(wave) * amplitude * sway_factor * 0.04;
}