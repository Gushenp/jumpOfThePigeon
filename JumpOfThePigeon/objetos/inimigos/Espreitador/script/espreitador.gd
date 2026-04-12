extends CharacterBody2D

# externo
@onready var animacao = $AnimatedSprite2D

# funções 
var direcao = 1
@export var speed = 40
@export var max_direito = 100.0
@export var max_esquerdo = -100.0
var posicao_inicial : float
@export var GRAVITY = 986.0
var is_moving = false

func _ready() -> void:
	posicao_inicial = position.x
	animacao.play("andar")
	animacao.flip_h = true

func _process(delta: float) -> void:
	_gravity(delta)
	_caminhar()

func _caminhar():
	velocity.x = direcao * speed
	move_and_slide()
	
	if is_on_wall():
		direcao *= -1
		await $Timer.timeout
	
	if position.x >= posicao_inicial + max_direito:
		if is_moving:
			return
		is_moving = true
		direcao = 0
		animacao.play("ficar")
		$Timer.start(3)
		await $Timer.timeout
		animacao.play("andar")
		direcao = -1
		animacao.flip_h = false
		is_moving = false
	elif position.x <= posicao_inicial + max_esquerdo:
		if is_moving:
			return
		is_moving = true
		direcao = 0
		animacao.play("ficar")
		$Timer.start(3)
		await $Timer.timeout
		animacao.play("andar")
		direcao = 1
		animacao.flip_h = true
		is_moving = false
	
func _gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

signal kill
func _on_kill_body_shape_entered(body: CharacterBody2D) -> void:
	emit_signal("kill")
	pass # Replace with function body.
