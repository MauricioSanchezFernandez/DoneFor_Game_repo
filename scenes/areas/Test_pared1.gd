extends Area2D

var scenes = ["test_scenario.tscn","test_scenario2.tscn","test_scenario3.tscn"]

func _on_body_entered(body):
	if body.name == "main_doctor":
		change_scene()

func change_scene():
	get_tree().change_scene_to_file("res://scenes/areas/Test_sur_2.tscn")
