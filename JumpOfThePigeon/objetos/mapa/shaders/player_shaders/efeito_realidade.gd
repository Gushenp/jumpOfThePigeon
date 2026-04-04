extends ColorRect

@onready var mat := material

var tempo := 0.0
var ativo := false

func _process(delta):
	if ativo:
		tempo += delta
		mat.set_shader_parameter("tempo", tempo)

func trocar_realidade():
	ativo = true

	var tween = create_tween()

	# ⚡ FLASH rápido
	tween.tween_property(mat, "shader_parameter/intensidade_flash", 1.0, 0.1)
	tween.tween_property(mat, "shader_parameter/intensidade_flash", 0.0, 0.2)

	# 🌊 DISTORÇÃO
	tween.tween_property(mat, "shader_parameter/distorcao", 1.0, 0.15)
	tween.tween_property(mat, "shader_parameter/distorcao", 0.0, 0.3)

	await tween.finished

	ativo = false
