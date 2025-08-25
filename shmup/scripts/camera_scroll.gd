extends Camera2D

func _ready():
	add_to_group("camera")

# Camera scroll script
func _process(delta: float) -> void:
	position.x += global.scroll_speed * delta
	position.y += global.scroll_speed_y * delta
