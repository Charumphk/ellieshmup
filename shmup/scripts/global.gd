extends Node

#camera and player scroll speed for gradius style
@export var scroll_speed: float = 300
@export var scroll_speed_y: float = 0
var active_dialogue_trigger = null
#player health
@export var health = 100

#
var cam_dir = Vector2.ZERO
