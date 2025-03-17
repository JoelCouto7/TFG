extends CharacterBody2D

var speed: int = 64
var maxHealth: int = 50
var currentHealth = maxHealth
var power: int = 2
var armor: int = 0
var exp: int = 0
var nextLevel: int = 10
@export var level: int = 1
@onready var animations = $AnimationPlayer

var isAttacking: bool = false

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed
	if Input.is_action_just_pressed("atacar"):
		animations.play("atacar")
		isAttacking = true
		await animations.animation_finished
		isAttacking = false

func updateAnimation():
	if (isAttacking): return
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Abajo"
		if velocity.x < 0: direction = "Izquierda"
		elif velocity.x > 0: direction = "Derecha"
		elif velocity.y < 0: direction = "Arriba"
		
		animations.play("andar" + direction)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func _physics_process(_delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()

func atacar():
	pass

func defender():
	pass

func _on_area_batalla_area_entered(area):
	if area.name == "playerCollision":
		#atacar() #ahora hay combate de verdad
		#defender() #ya no es necesario
		pass
