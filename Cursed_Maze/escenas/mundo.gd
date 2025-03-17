extends Node2D

@onready var jugador = $TileMap/Jugador
@onready var enemies = $TileMap/slime
@export var zona = "Castle"
@onready var interfaz = $CanvasLayer/interfazUsuario

# Called when the node enters the scene tree for the first time.
func _ready():
	var datos_jugador: String = " Status\n  Zone: "+zona
	datos_jugador += "\n    L: "+str(jugador.level)+"    H: "+str(jugador.currentHealth)+"/"+str(jugador.maxHealth)
	datos_jugador += "\n    A: "+str(jugador.power)+"    D: "+str(jugador.armor)
	interfaz.printPlayerStatus(datos_jugador)
	enemies.playerDetected.connect(interfaz.printInfo)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
