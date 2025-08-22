extends Area2D

@export var new_mode: int = 0 #0 = gradius, 1 = miami
@export var slow_time: float = 2.0 #for easing into mode swap
@export var swap_timer: float = 0.0
@export var ambush_delay: float = 1.5
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
		global.scroll_speed = 0
		
func _process(delta: float) -> void:
	if swapping:
		swap_timer += delta
		var progress = swap_timer / slow_time
		
		if progress >= 1.0: 
			var camera = get_tree().get_first_node_in_group("camera")
			if camera:
				camera.global_position = center
				
			global.scroll_speed = 0 if new_mode == 1 else 200
			swap_mode()
			start_ambush()
			swapping = false
		else: #smoothly slide in
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
		print("Enemy spawned. Current children count: ", get_tree().current_scene.get_child_count())
		
		# Check if enemy still exists after a moment
		await get_tree().process_frame
		if is_instance_valid(enemy):
			print("Enemy still exists at: ", enemy.global_position)
			print("Enemy health: ", enemy.health)
			print("Enemy player reference: ", enemy.player)
		else:
			print("Enemy disappeared immediately!")
