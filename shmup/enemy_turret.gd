extends Area2D

@onready var barrel = $turret_barrel
@onready var raycast = $turret_barrel/RayCast2D
@onready var player = get_tree().get_first_node_in_group("player")

var iframes = .0

@export var health = 40.0
@export var range = 400
@export var attackCooldown = 1.3

var type = "enemy"
var rotSpeed = 100.0
var cooldown = .0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func take_damage(dmg, type):
	if type == "continuous":
		print("dmg")
		health -= dmg
		iframes = 1.0
	else:
		print("dmg")
		health -= dmg
		

func handle_attack():

	if global_position.distance_to(player.global_position) < range:
		if cooldown >= attackCooldown:
			pass
			cooldown = 0
	
func handle_rotation(delta):
	var direction = global_position.angle_to_point(player.global_position)
	
	rotation = lerp_angle(rotation, direction, rotSpeed * delta)
	
func handle_movement():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	handle_rotation(delta)
	handle_movement()
	if health <= 0:
		print("bleh")
		queue_free()
	
	cooldown += delta
	if iframes != 0:
		iframes = clamp(iframes - delta, 0, 20)
