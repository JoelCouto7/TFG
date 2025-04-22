extends Node2D

@onready var jugador = $TileMap/Jugador
@onready var jefe = $TileMap/slime_boss
@onready var llave = $TileMap/Llave1
#@export var zona = "Castle"
#@onready var interfaz = $CanvasLayer/interfazUsuario
#@onready var portal = $TileMap/portal

var escena

# Called when the node enters the scene tree for the first time.
func _ready():
	#enemies.playerDetected.connect(interfaz.printInfo)
	#portal.transportar.connect(self.iraotromapa)
	jefe.dead.connect(aparece_llave)
	llave.transportar.connect(self.iraotromapa)
	llave.visible = false
	llave.process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.

func aparece_llave():
	llave.visible = true
	llave.process_mode = Node.PROCESS_MODE_INHERIT
	pass

func iraotromapa(otro_mapa: String):
	get_tree().change_scene_to_file(otro_mapa)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
