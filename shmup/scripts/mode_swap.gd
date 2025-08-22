extends Area2D

@export var new_mode: int = 0 #0 = gradius, 1 = miami

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "CameraTrigger" or body.is_in_group("camera_trigger"): #checks body 
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.style = new_mode
			if new_mode == 1:
				global.scroll_speed = 0
			if new_mode == 0:
				global.scroll_speed = 200
			print("Swapped to ", new_mode)
