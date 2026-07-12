extends Area2D
class_name HurtBox

signal hurted()
signal died()

#Por ejemplo, 7 puntos de vida, pa probar

@export var healthpoints:= 7


func get_damage(value: int):
	healthpoints -= value
	
	hurted.emit()
		
	if healthpoints <= 0:
		died.emit()
