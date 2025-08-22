extends Marker2D


@onready var baddie = load("res://scenes/enemy_basic.tscn")

var camera: Camera2D
var touchin_tips: bool = false
@export var edge_limit: float = 10.0 #pixels from edge to trigger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_2d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera:
		#get viewport bounds
		var viewport_size = get_viewport().get_visible_rect().size
		var camera_pos = camera.global_position
		var zoom = camera.zoom
		
		#calc what the viewport actually sees
		var half_viewport_world = Vector2(
			viewport_size.x / (2.0 * zoom.x),
			viewport_size.y / (2.0 * zoom.y)
		)
		
		#all four edges
		var leftie = camera_pos.x - half_viewport_world.x
		var rightie = camera_pos.x + half_viewport_world.x
		var toppie = camera_pos.y - half_viewport_world.y
		var bottomie = camera_pos.y + half_viewport_world.y
		
		#check dist to edge
		var dist_left = abs(global_position.x - leftie)
		var dist_right = abs(rightie - global_position.x)
		var dist_top = abs(global_position.y - toppie)
		var dist_bottom = abs(bottomie - global_position.y)
		
		#find min
		var min_distance = min(dist_left, dist_right, dist_top, dist_bottom)
		
		#check if close enough
		if min_distance <= edge_limit and not touchin_tips:
			touchin_tips = true
			edging()
			queue_free()

			
func edging():
	var instance = baddie.instantiate()
	instance.spawn_pos = global_position
	get_parent().add_child.call_deferred(instance)
