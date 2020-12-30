extends Control

var cards = ["a", "b", "c", "d"]

func init(card: String):
	var row: int = cards.find(card[0])
	var col: int = len(card)
	$Sprite.frame_coords = Vector2(0, row)
	$Sprite2.frame_coords = Vector2(col, row)



func _on_Area2D_mouse_entered():
	$Hover.show()


func _on_Area2D_mouse_exited():
	$Hover.hide()
