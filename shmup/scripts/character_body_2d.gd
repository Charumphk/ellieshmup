extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://scenes/projectile.tscn")

#for collision with bullets/powerups/etc
var type = "player"

#for cooldown
var can_shoot = true

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func shoot():
	var instance = projectile.instantiate()
	instance.dir = deg_to_rad(90)
	instance.spawnPos = global_position
	instance.spawnRot = deg_to_rad(90)
	main.add_child.call_deferred(instance)
	
func _input(event):
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

	var directionVertical := Input.get_axis("up", "down")
	var directionHorizontal := Input.get_axis("left", "right")
	if directionHorizontal:
		velocity.x = directionHorizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if directionVertical:
		velocity.y = directionVertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		var collision_point = collisionInfo.get_position()
		var obj = collisionInfo.get_collider()
		
	
	
