extends Camera2D

func _process(delta):
	position.x += global.scroll_speed * delta
