extends Area2D

func _on_mouse_entered() -> void:
	print("HOVER")
	# outline highlighted

func _on_mouse_exited() -> void:
	print("NOT HOVER")
	# outline not hightlighted

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		Outline.emit_signal("outline_chosen")
