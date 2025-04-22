extends Node2D

var destino = "res://escenas/creditos.tscn"
signal transportar

func _on_area_2d_area_entered(area):
	#print(area.name)
	if area.name == "areaBatalla":
		transportar.emit(destino)
		pass
	pass # Replace with function body.

