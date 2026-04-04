shader_type canvas_item;

uniform float intensidade = 2.5;
uniform float velocidade = 1.5;
uniform float escala_onda = 1.0;

void vertex() {
    float onda = sin((VERTEX.x / 100.0) * escala_onda + TIME * velocidade);
    float influencia = pow(UV.x, 1.5);

    VERTEX.x += onda * intensidade * influencia;
}