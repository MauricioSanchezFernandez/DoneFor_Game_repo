extends Node2D
@onready var hitbox_pivot = $"."

#hacemos un nodo intermedio entre el main y la hitbox para poder girarla a nuestro gusto
#cuando el personaje se gire.
#TODO: parece que se gira demasiado poco a la izquierda.

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		hitbox_pivot.scale.x = 1 
	elif direction < 0:
		hitbox_pivot.scale.x = -1 
