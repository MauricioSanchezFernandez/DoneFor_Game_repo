extends Node

var scenes = ["test_scenario.tscn","test_scenario2.tscn","test_scenario3.tscn"]
var actualScene = 0
#true = left, false = right
var leftRight = true

var pos_scenesRight_x = [-500, -500, -500, -500]
var pos_scenesRight_y = [80, 80, 80, 80]

var pos_scenesLeft_x = [600, 600, 600, 600]
var pos_scenesLeft_y = [80, 80, 80, 80]

func _ready() -> void:
	print(scenes[actualScene])
