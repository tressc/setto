extends Control

export var scene_path: String = ""
export var button_text: String = ""

func _ready():
	$ColorRect/CenterContainer/Label.text = button_text

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_tree().change_scene(scene_path)
