extends Node2D

# ==== Adição de nós =====
@onready var normal_map = $map/normal_map
@onready var other_map = $map/other_map
@onready var normal_map_elementos = $map/normal_map/elementos
@onready var camera = $player/camera
@onready var sound_nature = $audios/Nature
@onready var sound_Oficial2 = $audios/Oficial2

# ===== Variáveis de controle ======
var is_in_normal_map = true

# ===== Funções de iniciação
func _ready() -> void:
	$player.change_reality.connect(_change_reality)
	sound_nature.play()
	sound_Oficial2.play()
	pass 

# ==== Funções por frame =====
func _process(delta: float) -> void:
	pass

# ==== Mudar realidade =====
func _change_reality():
	if is_in_normal_map:
		_desativar_realidade(normal_map)
		_reativar_realidade(other_map)
		is_in_normal_map = false
	else: 
		is_in_normal_map = true
		_desativar_realidade(other_map)
		_reativar_realidade(normal_map)

# ==== Alterar realidades - Geral ===== 
func _desativar_realidade(node):
	node.get_node("tileMap").hide() #visual - tilemap 
	node.get_node("tileMap/solo").enabled = false
	_desativar_objetos(node)
	
func _reativar_realidade(node):
	node.get_node("tileMap").show() #visual - tilemap
	node.get_node("tileMap/solo").enabled = true
	_reativar_objetos(node)
	
func _desativar_objetos(node):
	if node == normal_map:
		pass

func _reativar_objetos(node):
	if node == normal_map:
		pass
		
#=== Funções da camera ====

func _on_zoom_1_body_entered(body: CharacterBody2D) -> void:
	_zoom_camera(1.3, 1.3)

func _on_zoom_1_body_exited(body: Node2D) -> void:
	_zoom_camera(1.3, 1.3)
	_move_camera_x(60)
	pass 

func _on_zoom_2_body_entered(body: Node2D) -> void:
	_zoom_camera(1.6, 1.6)
	_move_camera_x(0)
	pass 

var move_tween

func _move_camera_x(alvo_x):
	if move_tween:
		move_tween.kill()
	
	move_tween = create_tween()
	move_tween.tween_property(camera, "offset:x", alvo_x, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		

func _zoom_camera(alvo1, alvo2):
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(alvo1, alvo2), 0.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
