extends Area2D

@export var new_mode: int = 0 #0 = gradius, 1 = miami
@export var slow_time: float = 2.0 #for easing into mode swap
@export var swap_timer: float = 0.0
var original_speed: float
var swapping = false
var center: Vector2
var start: Vector2


func _ready():
	collision_layer = 7
	body_entered.connect(_on_body_entered)
	center = global_position
	

func _on_body_entered(body):
	if body.name == "CameraTrigger" or body.is_in_group("camera_trigger") and not swapping: #checks body
		swapping = true
		start = body.global_position
		original_speed = global.scroll_speed
		swap_timer = 0.0
		global.scroll_speed = 0
		
func _process(delta: float) -> void:
	print(global.scroll_speed)
	if swapping:
		swap_timer += delta
		var progress = swap_timer / slow_time
		
		if progress >= 1.0:
			var camera = get_tree().get_first_node_in_group("camera")
			if camera:
				camera.global_position = center
				
			global.scroll_speed = 0 if new_mode == 1 else 200
			swap_mode()
			swapping = false
		else:
			var distance = center - start
			var current = start + distance * ease_out_cubic(progress)
			
			var camera = get_tree().get_first_node_in_group("camera")
			if camera:
				camera.global_position = current
			
			global.scroll_speed = original_speed * (1.0 - ease_out_cubic(progress))

func ease_out_cubic(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)  # Smooth deceleration curve

func swap_mode():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.style = new_mode
		print ("Swapped to ", new_mode)
