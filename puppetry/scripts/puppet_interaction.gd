extends Area2D

# HOVER
func _on_mouse_entered() -> void:
	print("HOVER")
	# puppet highlighted

func _on_mouse_exited() -> void:
	print("NOT HOVER")
	# puppet not highlighted

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		print("CLICK")
		Puppet.outline_appear = true
