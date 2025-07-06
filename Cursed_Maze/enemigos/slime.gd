extends CharacterBody2D

var speed: int = 16
#var limit = 0.5
@export var hp = 1

@onready var animations = $AnimatedSprite2D
@onready var campoVision = $vision_area
signal playerDetected
signal enemyHited
signal dead
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
	if hp>0:
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

func perish():
	#hp = 0
	visible = false
	#set_collision_layer_value(2, false)
	#set_collision_mask_value(2, false)
	dead.emit()
	queue_free()
	process_mode = Node.PROCESS_MODE_DISABLED
	#_exit_tree()
	pass

func _on_hit_box_area_entered(area):
	#print(area.name)
	if area.name == "espada":
		hp = hp-1
		if(hp==0):
			perish()
	pass # Replace with function body.
