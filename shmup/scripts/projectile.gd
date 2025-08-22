extends Area2D

@export var speed = 800
@export var lifetime = 2.0

var velocity: Vector2

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	position += velocity * delta
