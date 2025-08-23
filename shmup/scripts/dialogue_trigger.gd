extends Area2D

var dialogue_started = false

func _ready():
	collision_mask = 64
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("camera_trigger") and not dialogue_started:
		dialogue_started = true
		start_dialogue()

func start_dialogue():
	global.scroll_speed = 0
	Dialogic.start("test1")

func _on_dialogue_finished():
	global.scroll_speed = 300
	queue_free()
