extends Node2D

@export var destino = "res://escenas/laberinto.tscn"
signal transportar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	#print(area.name)
	if area.name == "areaBatalla":
		transportar.emit(destino)
		pass
	pass # Replace with function body.
