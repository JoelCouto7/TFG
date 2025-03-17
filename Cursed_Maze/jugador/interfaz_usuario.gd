extends Control

@onready var playerStatus = $Panel/player_status
@onready var infoPanel = $Panel/info

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func printPlayerStatus(status: String):
	playerStatus.text = status
	pass

func printInfo(info: String):
	var aux = "Info:\n    "+ info
	infoPanel.text = aux
	pass
