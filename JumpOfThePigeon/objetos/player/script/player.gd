extends CharacterBody2D

#Variáveis fundamentais
@onready var player = $"."

#arquivos externos
@onready var animacaoPlayerFrame = $AnimatedSprite2D
@onready var jump_sound = $Audio/Jump
@onready var aterrisar_sound = $Audio/Aterrisar
@onready var aterrisar_ambiente = $Audio/AterrisarAmbiente
@onready var walking_sound = $Audio/Walking
@onready var flying_sound = $Audio/Flying

#variáveis de controle
@export var SPEED = 120
@export var JUMP_VELOCITY_PRIMARY = -300
@export var JUMP_VELOCITY_SECONDARY = -300
@export var posicao_inicial : Vector2
var isDeath = false
var gravidade = 986.0
var gravidade_planando = 200.0
# ====== Processos iniciais ========
func _ready() -> void:
	posicao_inicial = player.global_position

# ===== Processo de Quadros ======
func _physics_process(delta: float) -> void:
	_player_jump()
	_gravity(delta)
	_player_direction(delta)
	_animacao_player()
	_player_change_reality()
	_audio_player()
	move_and_slide()

# ===== Adicionar Gravidade =====
func _gravity(delta):
	if not is_on_floor():
		if Input.is_action_pressed("jump") and velocity.y > 0 and pulos_restantes == 0:
			velocity.y += gravidade_planando * delta
		else: 
			velocity.y += gravidade * delta

# ===== Funções de Pulo ======
@export var pulos_restantes = 0
func _player_jump():
	if is_on_floor():
		pulos_restantes = 2
	if Input.is_action_just_pressed("jump") and pulos_restantes > 0:
		if pulos_restantes == 2:
			_random_pitch_audio()
			jump_sound.play(3.21)
			velocity.y = JUMP_VELOCITY_PRIMARY
		elif pulos_restantes <= 1:
			_random_pitch_audio()
			jump_sound.play()
			velocity.y = JUMP_VELOCITY_SECONDARY
		pulos_restantes -= 1

# ====== Movimentação Player =======
func _player_direction(delta):
	var direction = Input.get_axis("left", "right")
	if isDeath == false: 
		if direction != 0:
			velocity.x = direction * SPEED
		else: 
			velocity.x = move_toward(velocity.x, 0, SPEED)

# ======= Mudar de Realidade =======
signal change_reality
func _player_change_reality():
	if Input.is_action_just_pressed("change"):
		emit_signal("change_reality")

# ======= animações ==========
func _animacao_player():
	if not player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			animacaoPlayerFrame.play("pular")
	
	if not player.is_on_floor() and Input.is_action_pressed("jump") and pulos_restantes == 0:
		animacaoPlayerFrame.play("fly")
			
	if player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			animacaoPlayerFrame.play("pular")
		else: 
			if Input.is_action_pressed("right"):
				animacaoPlayerFrame.flip_h = 0
				animacaoPlayerFrame.play("walk")
			elif  Input.is_action_pressed("left"):
				animacaoPlayerFrame.flip_h = 1
				animacaoPlayerFrame.play("walk")
			else: 
				animacaoPlayerFrame.play("stay")
	else:
		if Input.is_action_pressed("right"):
			animacaoPlayerFrame.flip_h = 0
		elif  Input.is_action_pressed("left"):
			animacaoPlayerFrame.flip_h = 1

# ====== audios player ============
var estava_no_chao = false
func _audio_player():
	#aterrisagem no chão
	var no_chao_agora = is_on_floor()
	if not estava_no_chao and no_chao_agora:
		aterrisar_sound.play(0.21)
		aterrisar_ambiente.play(0.10)
	estava_no_chao = no_chao_agora
	
# ======= coloar pitch aleatório dos efeitos ======
func _random_pitch_audio():
	jump_sound.pitch_scale = randf_range(0.8, 1.8)
	aterrisar_sound.pitch_scale = randf_range(0.8, 1.1)
	aterrisar_ambiente.pitch_scale = randf_range(0.9, 1.1)

# ======= eliminar player =======
func _eliminar_player():
	_apply_knockback()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
	
func _apply_knockback():
	player.rotation_degrees = 180
	var direction_player = (global_position).normalized()
	var direction = Input.get_axis("left", "right")
	
	isDeath = true
	_desativar_colisoes()
	
	velocity.y = -400
	if direction == 1.0:
		velocity.x = direction_player.x * -100
	elif direction == -1.0:
		velocity.x = direction_player.x * 100

#==================================
# ==== Desativar e ativar funcionalidades player ====
#==================================
func _desativar_player():
	player.get_node("AnimatedSprite2D").hide()
	player.get_node("CollisionShape2D").disabled = true
	player._desativar_sons()

func _reativar_realidade():
	player.get_node("AnimatedSprite2D").hide()
	player.get_node("CollisionShape2D").disabled = false
	player._reativar_sons()
	
func _desativar_colisoes():
	$CollisionShape2D.queue_free()
#==================================
# ==== Desativar e ativar sons ====
#==================================
func _desativar_sons():
	for child in player.get_children():
		_desativar_sons_recursivo(child)

func _desativar_sons_recursivo(node):
	if node is AudioStreamPlayer:
		node.volume_db = -200
		
	for child in node.get_children():
		_desativar_sons_recursivo(child)

func _reativar_sons():
	for child in player.get_children():
		_reativar_sons_recursivo(child)

func _reativar_sons_recursivo(node):
	if node is AudioStreamPlayer:
		node.volume_db = 0
		
	for child in node.get_children():
		_reativar_sons_recursivo(child)
