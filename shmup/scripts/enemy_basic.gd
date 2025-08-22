extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var projectile = load("res://scenes/enemy_projectile.tscn")

@export var rotSpeed = 10.0
@export var speed = 220.0
@export var range = 800.0
@export var attackCooldown = 1.3
@export var health = 60.0

var spawn_pos : Vector2 

var type = "enemy"

var cooldown = .0
var iframes = .0

var playerPos 
var distanceToPlayer

func _ready():
	position = spawn_pos


func shoot(dir, angle):
	var instance = projectile.instantiate()
	var final_angle = dir + deg_to_rad(angle)
	instance.dir = final_angle
	instance.spawnPos = global_position
	instance.spawnRot = final_angle
	get_parent().add_child.call_deferred(instance)

func take_damage(dmg, type):
	if type == "continuous":
		print("dmg")
		health -= dmg
		iframes = 1.0
	else:
		print("dmg")
		health -= dmg

func handle_rotation(delta):
	
	var direction = global_position.angle_to_point(playerPos)
	
	rotation = lerp_angle(rotation, direction, rotSpeed * delta)

func handle_movement():
	velocity = transform.x * speed
	
func handle_attack():

	if distanceToPlayer < range:
		if cooldown >= attackCooldown:
			shoot(rotation, 110)
			shoot(rotation, 90)
			shoot(rotation, 70)
			cooldown = 0
		
	
func _physics_process(delta: float) -> void:
	playerPos = player.global_position
	distanceToPlayer = global_position.distance_to(playerPos)
	handle_rotation(delta)
	handle_movement()
	handle_attack()
	
	if health <= 0:
		print("bleh")
		queue_free()
	
	cooldown += delta
	if iframes != 0:
		iframes = clamp(iframes - delta, 0, 20)
	var collisionInfo = move_and_collide(velocity * delta)
