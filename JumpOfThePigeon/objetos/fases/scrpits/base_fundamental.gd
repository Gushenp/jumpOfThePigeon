extends Node2D

# ==== Adição de nós =====
@onready var player = $player
@onready var elements = $map/elementos_globais
@onready var normal_map = $map/normal_map
@onready var other_map = $map/other_map
@onready var camera = $player/camera
@onready var sound_nature = $audios/Nature
@onready var sound_Oficial2 = $audios/Oficial2
@onready var transicao = $"transições/Transições/ColorRect"
@onready var transicao_animation = $"transições/Transições/ColorRect/AnimationPlayer"

# ===== Variáveis de controle ======
var is_in_normal_map = true

# ===== Funções de iniciação
func _ready() -> void:
	_start_game()
	pass 

# ==== Funções por frame =====
func _process(delta: float) -> void:
	pass

func _start_game():
	_desativar_areas(elements)
	_desativar_sons(elements)
	_desativar_sons(player)
	transicao_animation.play("fade_in")
	await get_tree().create_timer(2.0).timeout
	_reativar_areas(elements)
	_reativar_sons(elements)
	_reativar_sons(player)
	$player.change_reality.connect(_change_reality)
	sound_nature.play()
	sound_Oficial2.play()

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
	
func _reativar_realidade(node):
	node.get_node("tileMap").show() #visual - tilemap
	node.get_node("tileMap/solo").enabled = true

# == Controle colisoes ==
func _desativar_collisoes(node):
	if node == normal_map:
		pass

func _reativar_collisoes(node):
	if node == normal_map:
		pass
		

# == Controle areas 2d ==
func _desativar_areas(node):
	for child in node.get_children():
		_desativar_areas_recursivo(child)
		

func _desativar_areas_recursivo(node):
	if node is Area2D:
		node.monitoring = false
		node.monitorable = false
		
	for child in node.get_children():
		_desativar_areas_recursivo(child)
		
func _reativar_areas(node):
	for child in node.get_children():
		_reativar_areas_recursivo(child)
		

func _reativar_areas_recursivo(node):
	if node is Area2D:
		node.monitoring = true
		node.monitorable = true
		
	for child in node.get_children():
		_reativar_areas_recursivo(child)
		
#== Controle de sons ==
func _desativar_sons(node):
	for child in node.get_children():
		_desativar_sons_recursivo(child)
		

func _desativar_sons_recursivo(node):
	if node is AudioStreamPlayer:
		node.volume_db = -200
		
	for child in node.get_children():
		_desativar_sons_recursivo(child)
		
func _reativar_sons(node):
	for child in node.get_children():
		_reativar_sons_recursivo(child)
		

func _reativar_sons_recursivo(node):
	if node is AudioStreamPlayer:
		node.volume_db = 0
		
	for child in node.get_children():
		_reativar_sons_recursivo(child)
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

# == Saida ===
func _on_saída_body_entered(body: CharacterBody2D) -> void:
	transicao_animation.play("fade_out")
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://JumpOfThePigeon/Worlds/World1/Levels/level_2.tscn")
	pass 
