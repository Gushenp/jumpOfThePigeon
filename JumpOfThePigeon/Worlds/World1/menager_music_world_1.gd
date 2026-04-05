extends Node2D

func _saida_musica():
	$JumpOfThePigeon/AnimationPlayer.play("fade_out")

func _entrada_musica():
	$JumpOfThePigeon/AnimationPlayer.play("fade_in")
