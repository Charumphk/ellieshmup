extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://scenes/projectile.tscn")
@onready var bomb = load("res://scenes/bomb.tscn")

#for collision with bullets/powerups/etc
var type = "player"

var bombInstance = null

#for cooldown
@export var cooldownShoot1 = .2
var timeSinceAttack = .0

#for exploding
var exploding = false
@export var explodeRange = 5.0


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func shoot():
	#create an instance of the projectile
	var bulletInstance = projectile.instantiate()
	#set all the properties of the projectile
	bulletInstance.dir = deg_to_rad(90)
	bulletInstance.spawnPos = global_position
	bulletInstance.spawnRot = deg_to_rad(90)
	#add the instance as a child of main, but do it at the end of the frame (as to avoid issues)
	main.add_child.call_deferred(bulletInstance)
	
func explode():
	#instantiate bomb object
	bombInstance = bomb.instantiate()
	main.add_child.call_deferred(bombInstance)
	exploding = true

func _input(event):
	if event.is_action_pressed("bomb"):
		explode()
func _physics_process(delta: float) -> void:
	#if the cooldown is done, shoot. then start cooldown again.
	if Input.is_action_pressed("shoot") and cooldownShoot1 < timeSinceAttack:
		shoot()
		timeSinceAttack = 0
	
	if exploding and bombInstance != null:
		bombInstance.scale += Vector2(20.0, 20.0) * delta
		
		if bombInstance.scale.x > 50.0:
			exploding = false
			bombInstance.queue_free()
			bombInstance = null
		
		
	#get axes from user input for motion
	var directionVertical := Input.get_axis("up", "down")
	var directionHorizontal := Input.get_axis("left", "right")
	
	#convert these axes into actual velocity
	if directionHorizontal:
		velocity.x = directionHorizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if directionVertical:
		velocity.y = directionVertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	#move for the frame, then get collision information
	var collisionInfo = move_and_collide(velocity * delta)
	if collisionInfo:
		var collision_point = collisionInfo.get_position()
		var obj = collisionInfo.get_collider()
		if collisionInfo:
			if obj.type == "eProj":
				print("Ouch!")
				obj.queue_free()
	
	#increment cooldown
	timeSinceAttack += delta
	
	
