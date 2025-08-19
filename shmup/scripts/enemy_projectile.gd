extends CharacterBody2D

@export var SPEED = 100

#for player collision:
var type = "eProj"

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		var collision_point = collisionInfo.get_position()
		var obj = collisionInfo.get_collider()
		if collisionInfo:
			if obj.type == "player":
				print("Ouch!")
				queue_free()
			if obj.type == "bomb":
				print("Cleared!")
				queue_free()
