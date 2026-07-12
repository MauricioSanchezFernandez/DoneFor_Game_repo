extends CharacterBody2D

#@onready var animatedsprite2d: AnimatedSprite2D = $AnimatedSprite2D
#Todo esto es basicamente una plantilla. Cada personaje tendrá sus propias animaciones y deben ser sustituidas. 

func _on_hurt_box_died() -> void:
	queue_free()
	
	
func _on_hurt_box_hurted() -> void:
	print("ouch")
