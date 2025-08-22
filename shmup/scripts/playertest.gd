extends CharacterBody2D

#speed
@export var speed: float = 400.0
@export var focus_speed: float = 150.0

#bullet shoot fast speed go?
@export var fire_rate: float = 0.2
var shot_timer: float = 0.2
#style mechanic setup
enum style_type {grad, miami}
@onready var style = style_type.grad

#references to other nodes
@onready var focus_sprite = $focusSprite
@onready var fire_point = $firePoint
@onready var beam = $beamArea
@onready var bullet_scene: PackedScene = preload("res://scenes/projectile.tscn")
@onready var sprite = $playerSprite

#focus
var focused: bool = false
var type = "player" #for interaction with world objects

#beamshoot
var beamCharge: float = .0

func _ready():
	focus_sprite.visible = false
	beam.visible = false
	pass

func _physics_process(delta:float) -> void:
	handle_movement(delta)
	#swap controls based on game style
	match style:
		style_type.miami:
			handle_rotation()
			handle_beam(delta)
		style_type.grad:
			handle_shots(delta)
	handle_focus_mode()
	move_and_slide()
	
	#increment timers
	
	

func handle_focus_mode():
	focused = Input.is_action_pressed("ability")
	focus_sprite.visible = focused

func handle_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down") #get input direction as a vector2
	var current_speed = focus_speed if focused else speed
	velocity = Vector2(global.scroll_speed, 0) + input_direction * current_speed
	

func handle_rotation():
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	
	rotation = direction.angle()
		# Flip sprite vertically when aiming left
	if rotation > PI/2 or rotation < -PI/2:
		sprite.flip_v = true
	else:
		sprite.flip_v = false

func handle_beam(delta):
	if Input.is_action_pressed("shoot"):
		if beamCharge < .5:
			beamCharge += delta
		else:
			beam.visible = true
	if Input.is_action_just_released("shoot"):
		beam.visible = false
		beamCharge = 0
		("Done shooting.")
		
func handle_shots(delta):
	shot_timer -= delta
	if Input.is_action_pressed("shoot") and shot_timer <= 0.0:
		shoot_bullet()
		shot_timer = fire_rate
		
func shoot_bullet():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = fire_point.global_position
	bullet.velocity = Vector2(1, 0) * bullet.speed
