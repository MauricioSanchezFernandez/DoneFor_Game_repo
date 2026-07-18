extends Node

var scenes = ["test_scenario.tscn","test_scenario2.tscn","test_scenario3.tscn"]
var actualScene = 0
#true = left, false = right
var leftRight = true
var scenesLeft = []
var scenesRight = []

func _ready() -> void:
	print(scenes[actualScene])
