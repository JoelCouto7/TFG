extends Node2D

@onready var portal_oeste = $TileMap/portal2
@onready var portal_este = $TileMap/portal3

# Called when the node enters the scene tree for the first time.
func _ready():
	portal_oeste.transportar.connect(self.iraotromapa)
	portal_este.transportar.connect(self.iraotromapa)
	pass # Replace with function body.

func iraotromapa(otro_mapa: String):
	get_tree().change_scene_to_file(otro_mapa)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
