extends Area2D

@onready var camera = get_parent().get_node("Camera2D")

func _ready():
	collision_layer = 7
	collision_mask = 0
	add_to_group("camera_trigger")

func _physics_process(delta: float) -> void:
	if camera:
		global_position = camera.global_position
