extends Node2D

@onready var global_elements = $"."

#==================================
# ==== Desativar e ativar mapa ====
#==================================
func _desativar_realidade():
	global_elements.get_node("tileMap").hide() #visual - tilemap 
	global_elements.get_node("tileMap/solo").enabled = false

func _reativar_realidade():
	global_elements.get_node("tileMap").show() #visual - tilemap
	global_elements.get_node("tileMap/solo").enabled = true

#======================================
# ==== Desativar e ativar Áreas 2D ====
#======================================
func _desativar_areas():
	for child in global_elements.get_children():
		_desativar_areas_recursivo(child)
		

func _desativar_areas_recursivo(node):
	if node is Area2D:
		node.monitoring = false
		node.monitorable = false

	for child in node.get_children():
		_desativar_areas_recursivo(child)
		
func _reativar_areas():
	for child in global_elements.get_children():
		_reativar_areas_recursivo(child)


func _reativar_areas_recursivo(node):
	if node is Area2D:
		node.monitoring = true
		node.monitorable = true
		
	for child in node.get_children():
		_reativar_areas_recursivo(child)


#==================================
# ==== Desativar e ativar sons ====
#==================================
func _desativar_sons():
	for child in global_elements.get_children():
		_desativar_sons_recursivo(child)

func _desativar_sons_recursivo(node):
	if node is AudioStreamPlayer:
		node.volume_db = -200
		
	for child in node.get_children():
		_desativar_sons_recursivo(child)

func _reativar_sons():
	for child in global_elements.get_children():
		_reativar_sons_recursivo(child)


func _reativar_sons_recursivo(node):
	if node is AudioStreamPlayer:
		node.volume_db = 0
		
	for child in node.get_children():
		_reativar_sons_recursivo(child)
