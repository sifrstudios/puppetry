extends Node2D

signal display_scene
var current_actions: Array[String] = ["", "", ""]
var current_positions: Array[int] = [0,0,0]
var current_colours: Array[String] = ["", "", ""]

var act1 = ["kungfu", "idle", "cross_wave"]
var col1 = ["red", "red", "blue"]

var act2 = ["cross_wave", "wave_arms", "idle"]
var col2 = ["blue", "red", "yellow"]

var act3 = ["shuffle", "cross_wave", "kungfu"]
var col3 = ["yellow", "blue", "red"]

var act4 = ["cross_wave", "idle", "shuffle"]
var col4 = ["blue", "yellow", "yellow"]

var act5 = ["wave_arms", "idle", "shuffle"]
var col5 = ["yellow", "blue", "blue"]

var correct = true

func _ready() -> void:
	Globals.evaluate.connect(evaluation)
	Globals.choosing_slot.connect(_on_choosing_slot)
	
	
func _on_choosing_slot(action, pos, colour):
	current_actions[pos - 1] = action
	current_colours[pos - 1] = colour

func evaluation():
	print("evaluate")
	match Globals.current_scene:
		1:
			# check colours
			if current_colours != col1:
				correct = false
			# check actions
			if current_actions != act1:
				correct = false
		2:
			# check colours
			if current_colours != col2:
				correct = false
			# check actions
			if current_actions != act2:
				correct = false
		3:
			# check colours
			if current_colours != col3:
				correct = false
			# check actions
			if current_actions != act3:
				correct = false
		4:
			# check colours
			if current_colours != col4:
				correct = false
			# check actions
			if current_actions != act4:
				correct = false
		5:
			# check colours
			if current_colours != col5:
				correct = false
			# check actions
			if current_actions != act5:
				correct = false
	if correct:
		print("CORRECT, RESET")
		Globals.scene_counter += 1
		# reset
	else:
		print("WRONG, RESET")
		# reset
