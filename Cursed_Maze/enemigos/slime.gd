extends CharacterBody2D

var speed: int = 16
#var limit = 0.5

@onready var animations = $AnimatedSprite2D
@onready var campoVision = $vision_area
signal playerDetected
#@onready var interfaz = "res://jugador/interfaz_usuario.gd"

var startPosition
var endPosition

var playerArea: Area2D
var playerPosition

func _ready():
	startPosition = position
	endPosition = startPosition
	animations.play("andar")
	
func changeDirection():
	var tempEnd = endPosition
	if playerArea != null:
		playerPosition = playerArea.global_position
		endPosition = playerPosition
	else:
		endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	changeDirection()
	#if moveDirection.length() < limit:
		#changeDirection()
	velocity = speed * moveDirection.normalized()

func _physics_process(_delta):
	updateVelocity()
	move_and_slide()


func _on_vision_area_area_entered(area):
	if area.name == "areaBatalla":
		playerArea = area
		playerPosition = area.global_position
		#print_debug(area.global_position)
		#interfaz.printInfo("The Slime sees you")
		playerDetected.emit("The Slime sees you")


func _on_vision_area_area_exited(area):
	if area.name == "areaBatalla":
		playerArea = null
		playerPosition = position
		playerDetected.emit("")


func _on_hit_box_area_entered(area):
	
	pass # Replace with function body.
