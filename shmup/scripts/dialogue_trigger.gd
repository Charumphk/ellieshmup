extends Area2D

var dialogue_started = false
@export var dialogue: String = "null"
var player
var stored_speed = int(0)
var stored_speed_y = int(0)
func _ready():
	collision_mask = 0b11111111
	body_entered.connect(_on_body_entered)
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body):
	if body.is_in_group("camera_trigger") and not dialogue_started:
		player.dialogue = true
		dialogue_started = true
		stored_speed = global.scroll_speed
		stored_speed_y = global.scroll_speed_y
		print ("locked is ", player.dialogue)
		Dialogic.signal_event.connect(_on_dialogic_signal)
		start_dialogue()

func start_dialogue():
	global.scroll_speed = 0
	global.scroll_speed_y = 0
	Dialogic.start(dialogue)

func _on_dialogic_signal(argument:String):
	if argument == "end":
		global.scroll_speed = 300
		player.dialogue = false
		player.shot_timer = 0.3
		print("killing ", name)
		print ("locked is ", player.dialogue)
		Dialogic.signal_event.disconnect(_on_dialogic_signal)
		global.scroll_speed = stored_speed
		global.scroll_speed_y = stored_speed_y
		queue_free()
