extends Area2D

func _on_body_entered(body):
	if body.name == "main_doctor":
		change_scene()

func change_scene():
	get_tree().change_scene_to_file("res://scenes/areas/test_scenario.tscn")
