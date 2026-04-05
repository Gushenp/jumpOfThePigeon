extends Node2D

@onready var camera = $"."

func _on_move_1_body_entered(body: Node2D) -> void:
	_zoom_camera(1.5, 1.5)

func _on_move_1_body_exited(body: Node2D) -> void:
	_zoom_camera(1.5, 1.5)
	

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


func _on_move_2_body_entered(body: Node2D) -> void:
	_move_camera_x(0)
	pass # Replace with function body.


func _on_move_2_body_exited(body: Node2D) -> void:
	_move_camera_x(100)
	pass # Replace with function body.


func _on_move_3_body_entered(body: Node2D) -> void:
	_move_camera_x(0)
	pass # Replace with function body.


func _on_move_3_body_exited(body: Node2D) -> void:
	_move_camera_x(0)
	_zoom_camera(2.0, 2.0)
	pass # Replace with function body.
