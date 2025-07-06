extends Node2D

@onready var jugador = $TileMap/Jugador
@onready var enemies = $TileMap/slime
@export var zona = "Castle"
#@onready var interfaz = $TileMap/Jugador/CanvasLayer/interfazUsuario
@onready var portal = $TileMap/portal

var escena

# Called when the node enters the scene tree for the first time.
func _ready():
	#var datos_jugador: String = " Status\n  Zone: "+zona
	#datos_jugador += "\n    L: "+str(jugador.level)+"    H: "+str(jugador.currentHealth)+"/"+str(jugador.maxHealth)
	#datos_jugador += "\n    A: "+str(jugador.power)+"    D: "+str(jugador.armor)
	#interfaz.printPlayerStatus(datos_jugador)
	#enemies.playerDetected.connect(interfaz.printInfo)
	portal.transportar.connect(self.iraotromapa)
	escena = preload("res://escenas/laberinto.tscn").instantiate()
	pass # Replace with function body.

func iraotromapa(otro_mapa: String):
	##cargar otro mapa
	#print(otro_mapa)
	#var escena: PackedScene = otro_mapa
	
	#escena.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	#escena.resource_path = otro_mapa
	
	#get_tree().change_scene_to_packed(escena)
	#get_tree().unload_current_scene()
	#print("¿cambiado?")
	
	#print(get_tree().change_scene_to_packed())
	get_tree().change_scene_to_file(otro_mapa)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
