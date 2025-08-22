extends CharacterBody2D

@onready var player = $"../player"
@onready var projectile = load("res://scenes/enemy_projectile.tscn")
@onready var main = get_tree().get_root().get_node("Stage")

@export var rotSpeed = 5.0
@export var speed = 220.0
@export var range = 800.0
@export var attackCooldown = 2.0
@export var health = 60.0

var type = "enemy"

var cooldown = .0
var iframes = .0

var playerPos 
var distanceToPlayer


func shoot(dir, angle):
	var instance = projectile.instantiate()
	var final_angle = dir + deg_to_rad(angle)
	instance.dir = final_angle
	instance.spawnPos = global_position
	instance.spawnRot = final_angle
	main.add_child.call_deferred(instance)

func take_damage(dmg):
	print("dmg")
	health -= dmg
	iframes = 2.0

func handle_rotation(delta):
	
	var direction = global_position.angle_to_point(playerPos)
	
	rotation = lerp_angle(rotation, direction, rotSpeed * delta)

func handle_movement():
	velocity = transform.x * speed
	
func handle_attack():

	if distanceToPlayer < range:
		if cooldown >= attackCooldown:
			shoot(rotation, 135)
			shoot(rotation, 90)
			shoot(rotation, 45)
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
