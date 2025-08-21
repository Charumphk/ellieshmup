extends CharacterBody2D

#speed
@export var speed: float = 400.0
@export var focus_speed: float = 150.0

#references to other nodes
@onready var focus_sprite = $focusSprite
@onready var fire_point = $firePoint

#focus
var focused: bool = false
var type = "player" #for interaction with world objects

func _ready():
	focus_sprite.visible = false
	pass

func _physics_process(delta:float) -> void:
	handle_movement(delta)
	handle_rotation()
	handle_focus_mode()
	
	move_and_slide()

func handle_focus_mode():
	focused = Input.is_action_pressed("ability")
	focus_sprite.visible = focused

func handle_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down") #get input direction as a vector2
	var current_speed = focus_speed if focused else speed
	velocity = input_direction * current_speed
	

func handle_rotation():
	var mouse_pos = get_global_mouse_position()
	
	var direction = mouse_pos - global_position
	rotation = direction.angle()
