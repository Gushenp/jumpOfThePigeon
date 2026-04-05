shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 30.0) = 8.0;
uniform float speed     : hint_range(0.0, 5.0)  = 1.2;
uniform float stiffness : hint_range(0.0, 1.0)  = 0.6;

// Pré-calcule tile_phase e freq_variation via GDScript e passe como uniform
// OU use o truque abaixo com VERTEX local (muito mais barato)

void vertex() {
    float sway_factor = UV.y * UV.y * (1.0 - stiffness);

    // Usa VERTEX local em vez de multiplicar pela MODEL_MATRIX
    // O tile seed é baseado na posição local do tile — rápido e único por tile
    float tile_seed = dot(floor(VERTEX / 16.0 + 0.5), vec2(127.1, 311.7));

    // fract(sin()) é caro — substitua por uma hash mais barata
    float h1 = fract(tile_seed * 0.1031);
    float h2 = fract((tile_seed + 7.0) * 0.1031 + h1);

    float tile_phase     = h1 * TAU;
    float freq_variation = 0.7 + h2 * 0.6;

    float t = TIME * speed * freq_variation;

    // sin() chamado só 2x por vértice (era 3x antes)
    float wave  = sin(t + tile_phase);
    float wave2 = sin(t * 1.7 + tile_phase + 1.2) * 0.3;

    VERTEX.x += (wave + wave2) * amplitude * sway_factor;
    VERTEX.y += abs(wave)      * amplitude * sway_factor * 0.05;
}