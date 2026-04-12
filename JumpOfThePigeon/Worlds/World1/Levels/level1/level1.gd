extends Node2D

# ==== Adição de nós =====
@onready var player = $player
@onready var elementos_globais = $map/elementos_globais
@onready var normal_map = $map/normal_map
@onready var other_map = $map/other_map
@onready var camera = $player/camera
@onready var transicao = $"transições"

# ===== Variáveis de controle ======
var is_in_normal_map = true

# ===== Funções de iniciação
func _ready() -> void:
	_start()
	$player.change_reality.connect(_change_reality)
	pass 

func _start():
	$map/normal_map/audios/nature.play()
	elementos_globais._desativar_areas()
	elementos_globais._desativar_sons()
	player._desativar_sons()
	transicao._animacao_fade_in()
	await get_tree().create_timer(1.5).timeout
	menager_music_world1.get_node("JumpOfThePigeon").play()
	MenagerBackgroundtransition.hide()
	elementos_globais._reativar_areas()
	elementos_globais._reativar_sons()
	player._reativar_sons()

# ==== Mudar realidade =====
func _change_reality():
	if is_in_normal_map:
		normal_map._desativar_realidade()
		other_map._reativar_realidade()
		is_in_normal_map = false
	else: 
		is_in_normal_map = true
		other_map._reativar_realidade()
		normal_map._reativar_realidade()

func _on_saída_body_entered(body: Node2D) -> void:
	if body == player:
		transicao._animacao_fade_out()
		menager_music_world1._saida_musica()
		await get_tree().create_timer(2.3).timeout
		MenagerBackgroundtransition.show()
		get_tree().change_scene_to_file("res://JumpOfThePigeon/Worlds/World1/Levels/level2/level2.tscn")
	pass 
