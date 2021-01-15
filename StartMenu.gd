extends Node2D

func _on_TextureButton_pressed():
	var error_code = get_tree().change_scene("res://board.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)

