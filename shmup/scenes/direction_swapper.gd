extends Area2D

@export var slow_time: float = 2.0 #for easing into mode swap
@export var swap_timer: float = 0.0
@export var post_dir: String = "null"
@export var post_spd : float = -300.0
@export var dialogue: String = "null"
@export var onstart = true
var original_speed: float
var swapping = false
var center: Vector2
var start: Vector2

func _ready() -> void:
	collision_mask = 64
	body_entered.connect(_on_body_entered)
	center = global_position
	if onstart == false:
		monitoring = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body):
	if body.name == "CameraTrigger" or body.is_in_group("camera_trigger"): #checks area
		start = body.global_position
		original_speed = global.scroll_speed
		swap_timer = 0.0
		var camera = get_tree().get_first_node_in_group("camera")
		if camera:
			await smooth_camera_move(start, center, slow_time, Vector2.ZERO)
		post_cam()


func ease_out_cubic(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)  # Smooth deceleration curve

func ease_in_cubic(t: float) -> float:
	return t * t * t

func smooth_camera_move(start_pos: Vector2, end_pos: Vector2, duration: float, new_scroll: Vector2, ease_out := true) -> void:
	var camera = get_tree().get_first_node_in_group("camera")
	var t := 0.0
	var start_scroll = Vector2(global.scroll_speed, global.scroll_speed_y)
	
	while t < duration:
		t += get_process_delta_time()
		var progress = clamp(t / duration, 0, 1)
		var eased: float
		if ease_out:
			eased = ease_out_cubic(progress)
		else:
			eased = ease_in_cubic(progress)
		
		if camera:
			camera.global_position = start_pos.lerp(end_pos, eased)
		var blended = start_scroll.lerp(new_scroll, eased)
		global.scroll_speed_y = blended.y
		global.scroll_speed = blended.x
		await get_tree().process_frame
	global.scroll_speed = new_scroll.x
	global.scroll_speed_y = new_scroll.y

func post_cam():
	var dir := Vector2.ZERO
	var player = get_tree().get_first_node_in_group("player")
	#slider assigner
	match post_dir:
		"right": dir = Vector2(1, 0)
		"left":  dir = Vector2(-1, 0)
		"up":    dir = Vector2(0, -1)
		"down":  dir = Vector2(0, 1)
	if player:
		match post_dir:
			"right": player.rotate_grad(0)
			"left":  player.rotate_grad(PI)
			"up":    player.rotate_grad(deg_to_rad(-90))
			"down":  player.rotate_grad(deg_to_rad(90))
		print ("Rotation = ", player.rotation)
	
	#slide camera
	if dir != Vector2.ZERO:
		var camera = get_tree().get_first_node_in_group("camera")
		if camera:
			await smooth_camera_move(camera.global_position, camera.global_position + dir * 200, slow_time, dir * post_spd, false)
