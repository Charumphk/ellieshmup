extends Area2D

@onready var sprite = $beam

var bodies_inside = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if not body in bodies_inside:
		bodies_inside.append(body)
		
func _on_body_exited(body):
	bodies_inside.erase(body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in bodies_inside:
		if sprite.visible:
			if body.is_in_group("enemies"):
				if body.has_method("take_damage") and "iframes" in body and body.iframes == 0.0:
					body.take_damage(10, "continuous")
