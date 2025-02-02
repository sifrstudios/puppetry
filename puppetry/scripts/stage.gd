extends Node2D

@onready var outlines: Node2D = $Outlines
@onready var puppets: Node2D = $Puppets
@onready var turn_rogue: Timer = $Turn_Rogue


var pos_chosen
var outline_chosen
var cutscene_on_down = false
var cutscene_on_up = false
var cutscene_speed = 250
var chosen_puppet
var colour_chosen


var direction: String

var original_pos1
var original_pos2
var original_pos3
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
	Scenes.display_scene.emit()
	for puppet in puppets.get_children():
		print(puppet)
		puppet.get_child(0).pressed.connect(_on_puppet_clicked.bind(puppet.colour, puppet.key))
	Puppet.move_puppet.connect(_on_move_puppet)
	for button in outlines.get_children():
		button.pressed.connect(_outline_chosen.bind(button.pos))
		print(button, button.pos)
	for outline in outlines.get_children():
		outline.visible = false

func _process(delta: float) -> void:
	puppet_cutscene(delta, pos_chosen)
	label.text = str("Correct Scenes: ", Globals.scene_counter)
	lose()

func _outline_chosen(pos):
	# hide outlines that aren't selected
	pos_chosen = pos
	Globals.slots_taken[pos_chosen - 1] = 1
	
	chosen_puppet.EnterAction.emit()
	
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
			outline.queue_free()
	
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
	
func puppet_cutscene(delta: float, pos_chosen) -> void:
	if cutscene_on_down:
		# disable puppets while puppet reaches action spot
		if direction == "left":
			chosen_puppet.current_animation_state = Puppet.animation_state.RunLeft
		elif direction == "right":
			chosen_puppet.current_animation_state = Puppet.animation_state.RunRight
			
		for puppet in puppets.get_children():
			puppet.get_child(0).disabled = true

		# move sideways (UPDATE IF ITS RIGHT OR LEFT)
		match pos_chosen:
			1:
				original_pos1=chosen_puppet.global_position
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(one_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position <= one_down.global_position:
					direction = "right"
				elif chosen_puppet.global_position > one_down.global_position:
					direction = "left"
				if chosen_puppet.global_position == one_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
			2:
				original_pos2=chosen_puppet.global_position
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(two_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position <= two_down.global_position:
					direction = "right"
				elif chosen_puppet.global_position > two_down.global_position:
					direction = "left"
				if chosen_puppet.global_position == two_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
			3:
				original_pos3=chosen_puppet.global_position
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
		print("execute")
		await get_tree().create_timer(3).timeout
		reset()
func reset():
	for puppet in puppets.get_children():
		if puppet.global_position==one_up.global_position:
			puppet.global_position.move_toward(one_down.global_position, cutscene_speed)
			
		if puppet.global_position==two_up.global_position:
			puppet.global_position.move_toward(two_down.global_position,  cutscene_speed)
			
		if puppet.global_position==three_up.global_position:
			puppet.global_position.move_toward(three_down.global_position,  cutscene_speed)
			return_to_original=true
			
		if return_to_original:
			if puppet.global_position==one_down.global_position:
				puppet.global_position.move_toward(original_pos1,  cutscene_speed)
				
			if puppet.global_position==two_down.global_position:
				puppet.global_position.move_toward(original_pos2, cutscene_speed)
				
			if puppet.global_position==three_down.global_position:
				puppet.global_position.move_toward(original_pos3, cutscene_speed)
				return_to_original=false
		puppet.ExitAction.emit()
		print("reset")
		animation_player.play("scene_down")
		score.visible=false
		Globals.scene_key +=1
		Scenes.display_scene_again.emit()
		Scenes.display_scene_again.connect(_on_display_scene)
		for slot in Globals.slots_taken:
				slot=0
				Globals.slots_full = false
func lose():
	if get_tree().get_nodes_in_group("puppets").is_empty():
		get_tree().change_scene_to_file("res://scenes/lose.tscn")

func _on_display_scene():
	print(Globals.current_scene)
	match Globals.current_scene:
		1:
			displayed_scene = scene_1
			scene_1.visible = true
		2:
			displayed_scene = scene_2
			scene_2.visible = true
		3:
			displayed_scene = scene_3
			scene_3.visible = true
		4:
			displayed_scene = scene_4
			scene_4.visible = true
		5:
			displayed_scene = scene_5
			scene_5.visible = true
	print(displayed_scene)
	for scene in scenes.get_children():
		if scene != displayed_scene:
			scene.visible = false
			
	animation_player.play("scene_up")
