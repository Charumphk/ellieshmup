extends CharacterBody2D

@onready var player = $"../player"
@onready var projectile = load("res://scenes/enemy_projectile.tscn")

@export var rotSpeed = 10.0
@export var speed = 220.0
@export var range = 300.0
@export var attackCooldown = 1.5
@export var health = 40.0

var smoothing = 5.0
var spawn_pos : Vector2 
var targeting : bool = false


var cooldown = .0
var iframes = .0

var playerPos 
var distanceToPlayer
var distance_horiz


func _ready():
	position = spawn_pos
	rotation = deg_to_rad(-90)
	add_to_group("enemies")

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
	if targeting:
		rotation = lerp_angle(rotation, direction, rotSpeed * delta)

func handle_movement(delta):
	if not targeting:
		velocity = Vector2.ZERO
	else:
		velocity.x = lerp(velocity.x, player.velocity.x, smoothing * delta)
		
	
func handle_attack():
	if targeting:
		if cooldown >= attackCooldown:
			shoot(rotation, 110)
			shoot(rotation, 90)
			shoot(rotation, 70)
			cooldown = 0.0
		
	
func _physics_process(delta: float) -> void:
	playerPos = player.global_position
	distanceToPlayer = global_position.distance_to(playerPos)
	distance_horiz = abs(playerPos.x - global_position.x)
	handle_rotation(delta)
	handle_movement(delta)
	handle_attack()
	
	if health <= 0:
		print("bleh")
		queue_free()
		
	if distance_horiz <= range and not targeting:
		targeting = true

	
	cooldown += delta
	if iframes != 0:
		iframes = clamp(iframes - delta, 0, 20)
	move_and_slide()
