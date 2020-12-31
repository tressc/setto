extends Control


signal enter_hover(pos)
signal leave_hover(pos)
signal make_move(pos)


var cards: Array = ["a", "b", "c", "d"]
var my_pos: int = 0
var legal: bool = true
var occupied: bool = false


func init(card: String, pos: int):
	var row: int = cards.find(card[0])
	var col: int = len(card)
	my_pos = pos
	$Sprite.frame_coords = Vector2(0, row)
	$Sprite2.frame_coords = Vector2(col, row)


func start_highlight() -> void:
	$Highlight.show()


func end_highlight() -> void:
	$Highlight.hide()


func become_illegal() -> void:
	if not occupied:
		legal = false
		modulate.a = 0.5
		$Hover.hide()


func become_legal() -> void:
	legal = true
	modulate.a = 1


func _on_Area2D_mouse_entered() -> void:
	if legal:
		emit_signal("enter_hover", my_pos)
		$Hover.show()


func _on_Area2D_mouse_exited():
	emit_signal("leave_hover", my_pos)
	$Hover.hide()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if legal:
		if (event is InputEventMouseButton && event.pressed):
			modulate.a = 0
			occupied = true
			emit_signal("make_move", my_pos)
