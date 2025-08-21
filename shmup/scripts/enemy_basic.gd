extends CharacterBody2D

@onready var player = $"../shippy/player"

@export var rotSpeed = 5.0
@export var speed = 40.0

func handle_rotation(delta):
	
	var direction = global_position.angle_to_point(player.global_position)
	
	rotation = lerp_angle(rotation, direction, rotSpeed * delta)

func handle_movement():
	velocity = transform.x * speed
	
func _physics_process(delta: float) -> void:
	
	handle_rotation(delta)
	handle_movement()
	

	var collisionInfo = move_and_collide(velocity * delta)
