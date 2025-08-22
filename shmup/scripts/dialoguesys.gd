extends Control

@onready var dialogue_box = $DialogueBox
@onready var profile_pic = $DialogueBox/ProfilePicture
@onready var name_label = $DialogueBox/NameLabel
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var continue_indicator = $DialogueBox/ContinueIndicator

var current_dialogue: Array = [] 
var current_line: int = 0
var is_typing: bool = false
var typing_speed: float = 0.05
var typing_timer: Timer
var is_dialogue_active: bool = false

signal dialogue_finished

func _ready():
	name_label.add_theme_color_override("font_color", Color.CYAN)
	print("DialogueSystem ready. DialogueBox position: ", dialogue_box.position)
	print("DialogueBox size: ", dialogue_box.size)
	
	# Create a timer for typing animation
	typing_timer = Timer.new()
	add_child(typing_timer)
	typing_timer.wait_time = typing_speed
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	
	# Start hidden
	dialogue_box.visible = false

func start_dialogue(dialogue_data: Array):
	current_dialogue = dialogue_data
	current_line = 0
	is_dialogue_active = true
	dialogue_box.visible = true
	show_current_line()

func show_current_line():
	if current_line >= current_dialogue.size():
		end_dialogue()
		return
	
	var line_data = current_dialogue[current_line]
	
	# Set character info
	name_label.text = line_data.get("name", "")
	if line_data.has("portrait"):
		profile_pic.texture = load(line_data.portrait)
	
	# Start typing animation
	dialogue_text.text = ""
	continue_indicator.visible = false
	is_typing = true
	type_text(line_data.get("text", ""))

var current_text_to_type: String = ""
var current_char_index: int = 0

func type_text(text: String):
	current_text_to_type = text
	current_char_index = 0
	dialogue_text.text = ""
	typing_timer.start()

func _on_typing_timer_timeout():
	if current_char_index < current_text_to_type.length():
		dialogue_text.text += current_text_to_type[current_char_index]
		current_char_index += 1
	else:
		# Finished typing
		typing_timer.stop()
		is_typing = false
		continue_indicator.visible = true

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("shoot"):
		if is_typing:
			# Skip typing animation
			typing_timer.stop()
			is_typing = false
			dialogue_text.text = current_text_to_type
			continue_indicator.visible = true
		elif continue_indicator.visible:
			# Advance to next line
			current_line += 1
			show_current_line()
	get_viewport().set_input_as_handled()

func end_dialogue():
	dialogue_box.visible = false
	is_dialogue_active = false
	if typing_timer:
		typing_timer.stop()
	is_typing = false
	dialogue_finished.emit()
