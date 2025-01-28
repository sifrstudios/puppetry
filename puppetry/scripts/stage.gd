extends Node2D

@onready var puppet: CharacterBody2D = $Puppet
@onready var outlines: Node2D = $Outlines
@onready var puppets: Node2D = $Puppets

var pos_chosen
var outline_chosen
var cutscene_on_down = false
var cutscene_on_up = false
var cutscene_speed = 250
var chosen_puppet
var colour_chosen

@onready var one_up: Marker2D = $Positions/one_up
@onready var one_down: Marker2D = $Positions/one_down
@onready var two_up: Marker2D = $Positions/two_up
@onready var two_down: Marker2D = $Positions/two_down
@onready var three_up: Marker2D = $Positions/three_up
@onready var three_down: Marker2D = $Positions/three_down
@onready var action_menu: ItemList = $ControlHub/ActionMenu

func _ready() -> void:
	for puppet in puppets.get_children():
		print(puppet)
		puppet.get_child(0).pressed.connect(_on_puppet_clicked.bind(puppet.colour, puppet.key))
	Puppet.move_puppet.connect(_on_move_puppet)
	for button in outlines.get_children():
		print("CONNECTED")
		button.pressed.connect(_outline_chosen.bind(button.pos))
	for outline in outlines.get_children():
		outline.visible = false

func _process(delta: float) -> void:
	puppet_cutscene(delta, pos_chosen)

func _outline_chosen(position):
	print("outline selected position ", position)
	
	# hide outlines that aren't selected
	pos_chosen = position
	Globals.slots_taken[pos_chosen - 1] = 1
	
	##
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
		i = i + 1
	
func puppet_cutscene(delta: float, pos_chosen) -> void:
	if cutscene_on_down:
		# disable puppets while puppet reaches action spot
		for puppet in puppets.get_children():
			puppet.get_child(0).disabled = true

		# move sideways (UPDATE IF ITS RIGHT OR LEFT)
		match pos_chosen:
			1:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(one_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == one_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
			2:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(two_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == two_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
			3:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(three_down.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == three_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
		
	if cutscene_on_up:
		# move up
		match pos_chosen:
			1:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(one_up.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == one_up.global_position:
					cutscene_on_up = false
			2:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(two_up.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == two_up.global_position:
					cutscene_on_up = false
			3:
				chosen_puppet.global_position = chosen_puppet.global_position.move_toward(three_up.global_position, delta * cutscene_speed)
				if chosen_puppet.global_position == three_up.global_position:
					cutscene_on_up = false
		# enable puppets again
		for puppet in puppets.get_children():
			puppet.get_child(0).disabled = false
		
		Globals.in_action = false

	# action animation plays
	# action timer starts
