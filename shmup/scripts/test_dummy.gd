extends Sprite2D

@onready var projectile = load("res://scenes/enemy_projectile.tscn")
@onready var main = get_tree().get_root().get_node("main")

@export var cooldownShoot1 = .2
var timeSinceAttack = .0

#shoots projectile in the direction this node is facing
func shoot():
	var instance = projectile.instantiate()
	instance.dir = deg_to_rad(-90)
	instance.spawnPos = global_position
	instance.spawnRot = deg_to_rad(-90)
	main.add_child.call_deferred(instance)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cooldownShoot1 < timeSinceAttack:
		shoot()
		timeSinceAttack = 0
	
	timeSinceAttack += delta
