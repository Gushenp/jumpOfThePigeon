shader_type canvas_item;

uniform float intensidade = 1.6;
uniform float velocidade = 2.2;
uniform float frequencia = 4.0;

uniform vec2 tile_size = vec2(32.0, 32.0);

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex() {
    float peso = UV.y;

    vec2 pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;

    vec2 tile_id = floor(pos / tile_size);

    float variacao = random(tile_id);

    float tempo = TIME * velocidade * (0.5 + variacao);
    float fase = variacao * 10.0;

    float onda = sin(tempo + UV.y * frequencia + fase);

    VERTEX.x += onda * intensidade * peso;
}