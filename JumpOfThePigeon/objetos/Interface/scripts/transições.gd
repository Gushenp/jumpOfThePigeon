extends Node2D

@onready var animacoes = $"Transições/ColorRect/AnimationPlayer"

func _animacao_fade_in():
	animacoes.play("fade_in")
	
func _animacao_fade_out():
	animacoes.play("fade_out")
