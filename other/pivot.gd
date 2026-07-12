extends Node2D
@onready var hitbox_pivot = $"."

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		hitbox_pivot.scale.x = 1 
	elif direction < 0:
		hitbox_pivot.scale.x = -1 
