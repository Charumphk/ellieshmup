# ThreeBoxDialogueLayer.gd
@tool
extends DialogicLayoutLayer

# Main panel settings
@export_group("Main Panel")
@export var main_panel_color: Color = Color(0.1, 0.1, 0.1, 0.9)
@export var main_panel_border_width: int = 2
@export var main_panel_border_color: Color = Color.WHITE
@export var main_panel_size: Vector2 = Vector2(900, 220)
@export var main_panel_position: Vector2 = Vector2(0, -240) # Offset from bottom center

# Name box settings
@export_group("Name Box")
@export var name_box_color: Color = Color(0.2, 0.2, 0.8, 1.0)
@export var name_box_size: Vector2 = Vector2(180, 35)
@export var name_text_color: Color = Color.WHITE
@export var name_font_size: int = 16

# Text box settings  
@export_group("Text Box")
@export var text_box_color: Color = Color(0.05, 0.05, 0.05, 1.0)
@export var text_color: Color = Color.WHITE
@export var text_font_size: int = 18
@export_file("*.ttf", "*.tres") var text_font: String = ""

# Portrait box settings
@export_group("Portrait Box")
@export var portrait_box_color: Color = Color(0.15, 0.15, 0.15, 1.0)
@export var portrait_box_size: Vector2 = Vector2(180, 160)
@export var portrait_scale: Vector2 = Vector2(1.0, 1.0)

# Animation settings
@export_group("Animations")
@export var slide_in_duration: float = 0.3
@export var box_appear_delay: float = 0.1 # Delay between each box appearing

func _ready():
	print("ThreeBoxDialogue: _ready() called")
	# Connect to Dialogic signals to handle character changes
	if not Engine.is_editor_hint():
		Dialogic.Portraits.character_joined.connect(_on_character_joined)
		Dialogic.Portraits.character_left.connect(_on_character_left)
	
	# Force apply settings on ready
	call_deferred("_apply_export_overrides")

func _apply_export_overrides():
	print("ThreeBoxDialogue: _apply_export_overrides() called")
	_setup_main_panel()
	_setup_name_box()
	_setup_text_box()
	_setup_portrait_box()
	_animate_boxes_in()

func _setup_main_panel():
	print("Setting up main panel...")
	var main_panel = %MainPanel as PanelContainer
	if main_panel:
		# Create main panel style
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = main_panel_color
		style_box.border_width_left = main_panel_border_width
		style_box.border_width_right = main_panel_border_width
		style_box.border_width_top = main_panel_border_width  
		style_box.border_width_bottom = main_panel_border_width
		style_box.border_color = main_panel_border_color
		style_box.corner_radius_top_left = 8
		style_box.corner_radius_top_right = 8
		style_box.corner_radius_bottom_left = 8
		style_box.corner_radius_bottom_right = 8
		
		main_panel.add_theme_stylebox_override("panel", style_box)
		
		# Position and size the main panel
		main_panel.custom_minimum_size = main_panel_size
		main_panel.anchor_left = 0.5
		main_panel.anchor_right = 0.5
		main_panel.anchor_top = 1.0  
		main_panel.anchor_bottom = 1.0
		main_panel.offset_left = -main_panel_size.x / 2
		main_panel.offset_right = main_panel_size.x / 2
		main_panel.offset_top = main_panel_position.y
		main_panel.offset_bottom = main_panel_position.y + main_panel_size.y

func _setup_name_box():
	print("Setting up name box...")
	var name_panel = %NamePanel as PanelContainer
	var name_label = %DialogicNode_NameLabel as DialogicNode_NameLabel
	
	if name_panel:
		# Style the name box
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = name_box_color
		style_box.corner_radius_top_left = 5
		style_box.corner_radius_top_right = 5
		style_box.corner_radius_bottom_left = 5
		style_box.corner_radius_bottom_right = 5
		
		name_panel.add_theme_stylebox_override("panel", style_box)
		name_panel.custom_minimum_size = name_box_size
	
	if name_label:
		name_label.add_theme_color_override("font_color", name_text_color)
		name_label.add_theme_font_size_override("font_size", name_font_size)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _setup_text_box():
	var text_panel = %TextPanel as PanelContainer
	var dialog_text = %DialogText as DialogicNode_DialogText
	
	if text_panel:
		# Style the text box
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = text_box_color
		style_box.corner_radius_top_left = 5
		style_box.corner_radius_top_right = 5
		style_box.corner_radius_bottom_left = 5
		style_box.corner_radius_bottom_right = 5
		style_box.content_margin_left = 15
		style_box.content_margin_right = 15
		style_box.content_margin_top = 10
		style_box.content_margin_bottom = 10
		
		text_panel.add_theme_stylebox_override("panel", style_box)
	
	if dialog_text:
		dialog_text.add_theme_color_override("default_color", text_color)
		dialog_text.add_theme_font_size_override("normal_font_size", text_font_size)
		
		if not text_font.is_empty() and ResourceLoader.exists(text_font):
			dialog_text.add_theme_font_override("normal_font", load(text_font))

func _setup_portrait_box():
	print("Setting up portrait box...")
	var portrait_panel = %PortraitPanel as PanelContainer
	var portrait_container = %DialogicNode_PortraitContainer as DialogicNode_PortraitContainer
	
	if portrait_panel:
		# Style the portrait box
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = portrait_box_color
		style_box.corner_radius_top_left = 5
		style_box.corner_radius_top_right = 5
		style_box.corner_radius_bottom_left = 5
		style_box.corner_radius_bottom_right = 5
		
		portrait_panel.add_theme_stylebox_override("panel", style_box)
		portrait_panel.custom_minimum_size = portrait_box_size
	
	if portrait_container:
		portrait_container.scale = portrait_scale

func _animate_boxes_in():
	if slide_in_duration <= 0:
		return
		
	# Start with boxes invisible
	var boxes = [%NamePanel, %TextPanel, %PortraitPanel]
	for box in boxes:
		if box:
			box.modulate.a = 0.0
	
	# Animate each box in with a delay
	for i in range(boxes.size()):
		if boxes[i]:
			var tween = create_tween()
			tween.tween_interval(box_appear_delay * i)
			tween.tween_property(boxes[i], "modulate:a", 1.0, slide_in_duration)

func _on_character_joined(character: DialogicCharacter):
	# Handle character joining - maybe play a special animation
	if %PortraitPanel:
		var tween = create_tween()
		tween.tween_property(%PortraitPanel, "scale", Vector2(1.1, 1.1), 0.1)
		tween.tween_property(%PortraitPanel, "scale", Vector2(1.0, 1.0), 0.1)

func _on_character_left(character: DialogicCharacter):
	# Handle character leaving
	if %PortraitPanel:
		var tween = create_tween()
		tween.tween_property(%PortraitPanel, "modulate:a", 0.5, 0.2)
