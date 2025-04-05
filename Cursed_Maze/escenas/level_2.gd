extends Node2D

func _on_button_pressed():
	get_tree().change_scene_to_file("res://escenas/level_1.tscn")
	


func _on_boton_laberinto_pressed():
	print("Hola")
	get_tree().change_scene_to_file("res://escenas/laberinto.tscn")
	pass # Replace with function body.
