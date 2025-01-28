extends Node

var action_selected
var position_selected
var colour_selected

var slots_taken: Array[int] = [0,0,0]
var slots_full = false

var in_action = false

signal choosing_slot(action, position, colour)

func action_manager():
	pass

func _process(delta: float) -> void:
	for slot in slots_taken:
		if slot == 1:
			slots_full = true
		else:
			slots_full = false
			break
	if slots_full:
		# emit signal for checking scene & ending and getting a new one
