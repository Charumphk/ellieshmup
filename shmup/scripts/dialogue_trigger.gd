extends Area2D

var dialogue_started = false
@export var dialogue: String = "null"
var player
func _ready():
	collision_mask = 64
	body_entered.connect(_on_body_entered)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body):
	if body.is_in_group("camera_trigger") and not dialogue_started:
		player.dialogue = true
		dialogue_started = true
		start_dialogue()

func start_dialogue():
	global.scroll_speed = 0
	Dialogic.start(dialogue)

func _on_dialogic_signal(argument:String):
	if argument == "end":
		global.scroll_speed = 300
		player.dialogue = false
		player.shot_timer = 0.3
		queue_free()
