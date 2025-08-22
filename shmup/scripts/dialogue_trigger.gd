extends Area2D

@export var dialogue_data: Array[Dictionary] = [
	{
		"name": "Ellie",
		"text": "ZZ Cube pilot, you're approaching a few enemies.",
		"portrait": "res://img/codec/elliecodec.png"
	},
	{
		"name": "Ellie",
		"text": "Take them out. Shouldn't be a problem for you.",
		"portrait": "res://img/codec/elliecodec.png"
	}
]

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
	
	var dialogue_system = get_tree().get_first_node_in_group("dialogue")
	if dialogue_system:
		dialogue_system.start_dialogue(dialogue_data)
		dialogue_system.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	global.scroll_speed = 200
	queue_free()
