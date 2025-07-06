extends Node2D

@export var destino = "res://escenas/laberinto.tscn"
signal transportar

func _ready():
	var animations = $AnimatedSprite2D
	animations.play("default")

func _on_portal_2_area_entered(area):
	if area.name == "areaBatalla":
		transportar.emit(destino)
		pass
