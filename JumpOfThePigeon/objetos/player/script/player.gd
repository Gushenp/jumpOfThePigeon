extends CharacterBody2D

#Variáveis fundamentais
@onready var player = $"."

#arquivos externos
@onready var animacaoPlayer = $AnimatedSprite2D
@onready var jump_sound = $Audio/Jump
@onready var aterrisar_sound = $Audio/Aterrisar
@onready var aterrisar_ambiente = $Audio/AterrisarAmbiente
@onready var walking_sound = $Audio/Walking

#variáveis de controle
@export var SPEED = 120
@export var JUMP_VELOCITY_PRIMARY = -300
@export var JUMP_VELOCITY_SECONDARY = -250
@export var posicao_inicial : Vector2
var GRAVITY = 986.0

# ====== Processos iniciais ========
func _ready() -> void:
	posicao_inicial = player.global_position

# ===== Processo de Quadros ======
func _physics_process(delta: float) -> void:
	_gravity(delta)
	_player_jump()
	_player_direction(delta)
	_player_change_reality()
	_animacao_player()
	_audio_player()
	move_and_slide()

# ===== Adicionar Gravidade =====
func _gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

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
		animacaoPlayer.stop()
	
	if Input.is_action_pressed("right"):
		animacaoPlayer.flip_h = 0
		animacaoPlayer.play("walk")
	elif  Input.is_action_pressed("left"):
		animacaoPlayer.flip_h = 1
		animacaoPlayer.play("walk")
	else: 
		animacaoPlayer.play("stay")

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

# ====== alterar flash entre mundos =====
