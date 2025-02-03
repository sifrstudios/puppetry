extends Node2D

@onready var outlines: Node2D = $Outlines
@onready var puppets: Node2D = $Puppets

var pos_chosen
var outline_chosen
var cutscene_on_down = false
var cutscene_on_up = false
var cutscene_speed = 250
var chosen_puppet
var colour_chosen
var hidden_outlines = [0,0,0]
var direction: String
var delta_Var

@onready var op1: Marker2D = $op1
@onready var op2: Marker2D = $op2
@onready var op3: Marker2D = $op3
@onready var op4: Marker2D = $op4
@onready var op5: Marker2D = $op5
@onready var op6: Marker2D = $op6



var return_to_original = false
var displayed_scene
@onready var animation_player: AnimationPlayer = $SceneRollup/AnimationPlayer
@onready var one_up: Marker2D = $Positions/one_up
@onready var one_down: Marker2D = $Positions/one_down
@onready var two_up: Marker2D = $Positions/two_up
@onready var two_down: Marker2D = $Positions/two_down
@onready var three_up: Marker2D = $Positions/three_up
@onready var three_down: Marker2D = $Positions/three_down
@onready var action_menu: ItemList = $ControlHub/ActionMenu
@onready var score: Label = $SceneRollup/Score
@onready var label: Label = $Label
@onready var scene_1: Node2D = $SceneRollup/Scenes/Scene1
@onready var scene_2: Node2D = $SceneRollup/Scenes/Scene2
@onready var scene_3: Node2D = $SceneRollup/Scenes/Scene3
@onready var scene_4: Node2D = $SceneRollup/Scenes/Scene4
@onready var scene_5: Node2D = $SceneRollup/Scenes/Scene5

@onready var scenes: Node2D = $SceneRollup/Scenes

func _ready() -> void:
	# emit signal to display current scene
	Scenes.display_scene.emit()
	
	# pass puppet info to puppet when clicked
	for puppet in puppets.get_children():
		puppet.get_child(0).pressed.connect(_on_puppet_clicked.bind(puppet.colour, puppet.key))
	
	Puppet.move_puppet.connect(_on_move_puppet)
	
	# pass outline position when clicked
	for button in outlines.get_children():
		button.pressed.connect(_outline_chosen.bind(button.pos))
	
	# hide all outlines on ready
	for outline in outlines.get_children():
		outline.visible = false

func _process(delta: float) -> void:
	delta_Var=delta
	puppet_cutscene(delta, pos_chosen)
	
	# display score
	label.text = str("Correct Scenes: ", Globals.scene_counter)
	
	# disable rogue puppets
	for puppet in puppets.get_children():
		if puppet.is_in_group("rogue_puppets"):
			puppet.get_child(0).disabled = true

	# hide chosen outlines
	for pos in hidden_outlines:
		for outline in outlines.get_children():
			if outline.pos == pos:
				outline.visible = false
	
	lose()

func _outline_chosen(pos):
	# hide outlines that aren't selected
	pos_chosen = pos
	Globals.slots_taken[pos_chosen - 1] = 1
	
	print(Globals.slots_taken[pos_chosen - 1])
	for slot in Globals.slots_taken:
		print(str(slot) + " ")
	##
	match pos_chosen:
		1:
			for outline in outlines.get_children():
				if outline.pos != 1:
					outline.visible = false
				else:
					outline_chosen = outline
		2:
			for outline in outlines.get_children():
				if outline.pos != 2:
					outline.visible = false
				else:
					outline_chosen = outline
		3:
			for outline in outlines.get_children():
				if outline.pos != 3:
					outline.visible = false
				else:
					outline_chosen = outline
	# display action menu
	action_menu.visible = true

func _on_move_puppet():
	# action selected, puppet should start moving into position
	Globals.choosing_slot.emit(Globals.action_selected, pos_chosen, colour_chosen)
	
	# remove outline of taken position
	for outline in outlines.get_children():
		if outline.pos == pos_chosen:
			hidden_outlines[pos_chosen - 1] = outline.pos
	
	# hide all outlines
	outlines.visible = false
	
	# start animation
	cutscene_on_down = true
		
		

func _on_puppet_clicked(colour, key):
	print("Colour: " + str(colour) + ", Key: " + str(key))
	
	# identify which puppet was clicked on
	for puppet in puppets.get_children():
		if puppet.key == key:
			chosen_puppet = puppet
	chosen_puppet.EnterAction.emit()

	print(chosen_puppet.name)
	colour_chosen = chosen_puppet.colour
	
	Globals.in_action = true
	outline_appears()
	
func outline_appears():
	outlines.visible = true
	print("OUTLINE APPEARS")
	var i = 0
	for slot in Globals.slots_taken:
		print("value of i " + str(i))
		if slot == 0:
			for outline in outlines.get_children():
				if outline.pos == i+1:
					print("Outline name " + outline.name)
					outline.visible = true
					print(outline.visible)
		i += 1
	
func puppet_cutscene(delta: float, pos_chosen) -> void: # this has to be the stupidest way to move anything ever its almost impressive
	if cutscene_on_down:
		# set direction of puppets
		if direction == "left":
			chosen_puppet.current_animation_state = Puppet.animation_state.RunLeft
		elif direction == "right":
			chosen_puppet.current_animation_state = Puppet.animation_state.RunRight
	
		# disable puppets while puppet reaches action spot
		for puppet in puppets.get_children():
			puppet.get_child(0).disabled = true

		# move sideways
		match pos_chosen:
			1:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(one_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position <= one_down.global_position:
					direction = "right"
				elif chosen_puppet.global_position > one_down.global_position:
					direction = "left"
				if chosen_puppet.global_position == one_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
			2:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(two_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position <= two_down.global_position:
					direction = "right"
				elif chosen_puppet.global_position > two_down.global_position:
					direction = "left"
				if chosen_puppet.global_position == two_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
			3:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(three_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position <= three_down.global_position:
					direction = "right"
				elif chosen_puppet.global_position > three_down.global_position:
					direction = "left"
				if chosen_puppet.global_position == three_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
		
	if cutscene_on_up:
		# move up
		chosen_puppet.current_animation_state = Puppet.animation_state.Stairs
		match pos_chosen:
			1:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(one_up.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == one_up.global_position:
					print("should")
					slot_filled()
					cutscene_on_up = false
			2:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(two_up.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == two_up.global_position:
					print("should")
					slot_filled()
					cutscene_on_up = false
			3:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(three_up.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == three_up.global_position:
					slot_filled()
					cutscene_on_up = false

func slot_filled():
	# enable puppets again
	Globals.puppet_key = chosen_puppet.key
	Globals.previous_action = Globals.action_selected
	for puppet in puppets.get_children():
		puppet.get_child(0).disabled = false
	# action manager function?
	Globals.in_action = false
	# check if scene ended for evaluation
	
	for slot in Globals.slots_taken:
		if slot == 1:
			Globals.slots_full = true
		else:
			Globals.slots_full = false
			break
	if Globals.slots_full:
		# disable puppets
		#for puppet in puppets.get_children():
			#puppet.get_tree().paused = true
		Globals.evaluate.emit()
		if Scenes.correct:
			score.text = "+1 Scenes!"
		else:
			score.text = "Wrong Scene!"
		score.visible = true
		await get_tree().create_timer(2).timeout
		reset()

func reset():
	# resetting global variables
	Globals.action_selected = ""
	Globals.position_selected = 0
	Globals.colour_selected = ""
	Globals.puppet_key = 0
	Globals.previous_action = ""
	Globals.slots_taken = [0,0,0]
	Globals.slots_full = false
	Globals.in_action = false
	hidden_outlines = [0,0,0]
	
	for puppet in puppets.get_children():
		#if puppet.global_position==one_up.global_position:
			#puppet.global_position=puppet.global_position.move_toward(one_down.global_position, delta_Var*cutscene_speed)
			#
		#if puppet.global_position==two_up.global_position:
			#puppet.global_position=puppet.global_position.move_toward(two_down.global_position,  delta_Var*cutscene_speed)
			#
		#if puppet.global_position==three_up.global_position:
			#puppet.global_position=puppet.global_position.move_toward(three_down.global_position, delta_Var*cutscene_speed)
			#return_to_original=true
		if puppet.global_position==one_up.global_position:
			return_to_original = true
			
		elif puppet.global_position==two_up.global_position:
			return_to_original = true
			
		elif puppet.global_position==three_up.global_position:
			return_to_original = true
			
		if return_to_original:
			match puppet.key:
				1:
					print(puppet.global_position)
					puppet.global_position = op1.global_position
					print(puppet.global_position)
				2:
					puppet.global_position = op2.global_position
				3:
					puppet.global_position = op3.global_position
				4:
					puppet.global_position = op4.global_position
				5:
					puppet.global_position = op5.global_position
				6:
					puppet.global_position = op6.global_position
			return_to_original = false
		
		puppet.ExitAction.emit() # no idea what this does bas khayfa ashelo
		puppet.ResetTimers.emit()
		# scene change

		animation_player.play("scene_down")
		score.visible = false
		Globals.scene_key = Globals.scene_key + 1
		Scenes.display_scene.emit()

func lose():
	if get_tree().get_nodes_in_group("puppets").is_empty():
		get_tree().change_scene_to_file("res://scenes/lose.tscn")
