extends Camera2D

@export var tilemap: TileMap
@export var debug = false
var margenIU = 0
var mapRect
var tileSize = 16
var worldSizeInPixels
var mapCenter
# Called when the node enters the scene tree for the first time.
func _ready():
	if (debug):
		pass
	else:
		tilemap = $"../../.."
		margenIU = 0 #64
		mapRect = tilemap.get_used_rect()
		tileSize = tilemap.cell_quadrant_size
		worldSizeInPixels = mapRect.size * tileSize
		mapCenter = mapRect.position
		#print_debug(mapCenter)
		offset.y = margenIU
		limit_top = mapCenter.y * tileSize - margenIU
		limit_left = mapCenter.x * tileSize
		limit_right = worldSizeInPixels.x - abs(mapCenter.x * tileSize)
		limit_bottom = worldSizeInPixels.y - abs(mapCenter.y * tileSize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_tile_map_changed():
	mapRect = tilemap.get_used_rect()
	worldSizeInPixels = mapRect.size * tileSize
	mapCenter = mapRect.position
	limit_top = mapCenter.y * tileSize - margenIU
	limit_left = mapCenter.x * tileSize
	limit_right = worldSizeInPixels.x - abs(mapCenter.x * tileSize)
	limit_bottom = worldSizeInPixels.y - abs(mapCenter.y * tileSize)
	pass # Replace with function body.
