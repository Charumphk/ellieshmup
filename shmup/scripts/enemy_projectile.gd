extends Area2D
@export var SPEED = 400
#for player collision:
var type = "eProj"
var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
	# Connect Area2D signals for collision detection
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	# Manual movement (no velocity needed)
	var movement = Vector2(0, -SPEED).rotated(dir)
	global_position += movement * delta

# Handle collisions with bodies (CharacterBody2D, RigidBody2D, etc.)
func _on_body_entered(body):
	if body.has_method("get") and body.get("type"):
		handle_collision(body)

# Handle collisions with other areas
func _on_area_entered(area):
	if area.has_method("get") and area.get("type"):
		handle_collision(area)

func handle_collision(obj):
	if obj.type == "player":
		print("Ouch!")
		queue_free()
	if obj.type == "bomb":
		print("Cleared!")
		queue_free()
