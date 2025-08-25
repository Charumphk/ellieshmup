extends Area2D

@export var new_mode: int = 0 #0 = gradius, 1 = miami
@export var slow_time: float = 2.0 #for easing into mode swap
@export var swap_timer: float = 0.0
@export var ambush_delay: float = 1.5
@export var post_dir: String = "null"
@export var post_spd : float = 300.0
var original_speed: float
var swapping = false
var center: Vector2
var start: Vector2
var spawn_markers: Array[Marker2D] = [] # to store enemy spawners

func _ready():
	collision_mask = 64
	body_entered.connect(_on_body_entered)
	center = global_position
	
	find_spawn_markers(self)
	print(spawn_markers)
	
func find_spawn_markers(node: Node):
	for child in node.get_children():
		if child is Marker2D and child.is_in_group("enemy_spawn"):
			spawn_markers.append(child)
		find_spawn_markers(child)  # Check children recursively

func _on_body_entered(body):
	if body.name == "CameraTrigger" or body.is_in_group("camera_trigger") and not swapping: #checks area
		swapping = true
		start = body.global_position
		original_speed = global.scroll_speed
		swap_timer = 0.0
		var camera = get_tree().get_first_node_in_group("camera")
		if camera:
			await smooth_camera_move(start, center, slow_time, Vector2.ZERO)
		swap_mode()
		await start_ambush()
		swapping = false
		


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

func swap_mode():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.style = new_mode
		print ("Swapped to ", new_mode)

func start_ambush():
	await get_tree().create_timer(ambush_delay).timeout
	print("started ambush")
	spawn_enemies()

func spawn_enemies():
	for marker in spawn_markers:
		print("attempting spawns")
		var enemy = load("res://scenes/enemy_basic.tscn").instantiate()
		enemy.spawn_pos = marker.global_position
		enemy.global_position = marker.global_position
		get_tree().current_scene.add_child(enemy)
		enemy.add_to_group("current_wave_enemies")
		print("Enemy spawned. Current children count: ", get_tree().current_scene.get_child_count())
	check_enemies_defeated()

func check_enemies_defeated():
	while get_tree().get_nodes_in_group("current_wave_enemies").size() > 0:
		await get_tree().process_frame
	post_fight()

func post_fight():
	var dir := Vector2.ZERO
	#slider
	match post_dir:
		"right": dir = Vector2(1, 0)
		"left":  dir = Vector2(-1, 0)
		"up":    dir = Vector2(0, -1)
		"down":  dir = Vector2(0, 1)
	
	if dir != Vector2.ZERO:
		var camera = get_tree().get_first_node_in_group("camera")
		if camera:
			await smooth_camera_move(camera.global_position, camera.global_position + dir * 200, slow_time, dir * post_spd, false)
