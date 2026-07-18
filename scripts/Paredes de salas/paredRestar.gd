extends Area2D
#ESTO VA EN UN AREA2D CON UNA COLLISIONSHAPE COMO HIJO

var player = preload("res://scripts/characters/main_doctor/main_doctor.gd")

func _on_body_entered(body):
	if body.name == "main_doctor":
		SceneManager.actualScene = SceneManager.actualScene - 1
		SceneManager.leftRight = true
		change_scene()
	

func change_scene():
	var string1 = "res://scenes/areas/%s"
	var string2 = string1 % SceneManager.scenes[SceneManager.actualScene]
	get_tree().change_scene_to_file(string2)
	
	player.instantiate()
	player.global_position.x = SceneManager.pos_scenesLeft_x[SceneManager.actualScene]
	player.global_position.y = SceneManager.pos_scenesLeft_y[SceneManager.actualScene]
