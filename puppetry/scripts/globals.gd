extends Node

var action_selected
var position_selected
var colour_selected
var current_scene = 1
var scene_counter=0
var scene_key=0

var slots_taken: Array[int] = [0,0,0]
var slots_full = false

var in_action = false

signal choosing_slot(action, position, colour)
signal evaluate

func action_manager():
	pass
