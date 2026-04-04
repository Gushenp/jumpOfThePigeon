shader_type canvas_item;

uniform float  intensidade= 1.0;
uniform float velocidade = 1.5;
uniform float escala_onda = 1.5;

void vertex() {
    float onda = sin((VERTEX.y / 100.0) * escala_onda + TIME * velocidade);
    float influencia = pow(UV.y, 1.5);

    VERTEX.y += onda * intensidade * influencia;
}