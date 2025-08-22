extends Camera2D

# Camera scroll script
func _process(delta: float) -> void:
	position.x += global.scroll_speed * delta
