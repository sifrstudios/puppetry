extends Node2D

signal display_scene

var current_actions: Array[String] = ["", "", ""]
var current_positions: Array[int] = [0,0,0]
var current_colours: Array[String] = ["", "", ""]

var act1 = ["raise_right", "idle", "cross"]
var col1 = ["red", "red", "blue"]

var act2 = ["cross", "raise_left", "idle"]
var col2 = ["blue", "red", "yellow"]

var act3 = ["idle", "cross", "raise_right"]
var col3 = ["yellow", "blue", "red"]

var act4 = ["cross", "idle", "cross"]
var col4 = ["blue", "yellow", "yellow"]

var act5 = ["raise_left", "cross", "raise_right"]
var col5 = ["yellow", "blue", "blue"]

var correct = false

func _ready() -> void:
	Globals.evaluate.connect(evaluation)
	Globals.choosing_slot.connect(_on_choosing_slot)
	
	
func _on_choosing_slot(action, pos, colour):
	current_actions[pos - 1] = action
	current_colours[pos - 1] = colour

func evaluation():
	match Globals.current_scene:
		1:
			# check colours
			for col in col1:
				for current in current_colours:
					if current != col:
						correct = false
			# check actions
			for act in act1:
				for current in current_actions:
					if current != act:
						correct = false
		2:
			# check colours
			for col in col2:
				for current in current_colours:
					if current != col:
						correct = false
			# check actions
			for act in act2:
				for current in current_actions:
					if current != act:
						correct = false
		3:
			# check colours
			for col in col3:
				for current in current_colours:
					if current != col:
						correct = false
			# check actions
			for act in act3:
				for current in current_actions:
					if current != act:
						correct = false
		4:
			# check colours
			for col in col4:
				for current in current_colours:
					if current != col:
						correct = false
			# check actions
			for act in act4:
				for current in current_actions:
					if current != act:
						correct = false
		5:
			# check colours
			for col in col5:
				for current in current_colours:
					if current != col:
						correct = false
			# check actions
			for act in act5:
				for current in current_actions:
					if current != act:
						correct = false
	if correct:
		# hightlight green
		# increase score
		print("CORRECT, END, RESET")
		# reset
	else:
		# hightlight red
		# decrease score
		print("WRONG, END, RESET")
		# reset
