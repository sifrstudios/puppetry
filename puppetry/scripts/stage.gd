extends Node2D

@onready var puppet: CharacterBody2D = $Puppet
@onready var outlines: Node2D = $Outlines

var pos_chosen
var outline_chosen
var cutscene_on_down = false
var cutscene_on_up = false
var cutscene_speed = 250
@onready var one_up: Marker2D = $Positions/one_up
@onready var one_down: Marker2D = $Positions/one_down
@onready var two_up: Marker2D = $Positions/two_up
@onready var two_down: Marker2D = $Positions/two_down
@onready var action_menu: ItemList = $ControlHub/ActionMenu

func _ready() -> void:
	Puppet.move_puppet.connect(_on_move_puppet)
	for button in outlines.get_children():
		print("CONNECTED")
		button.pressed.connect(_outline_chosen.bind(button.pos))
	print(Puppet.outline_appear)
	outlines.visible = false

func _process(delta: float) -> void:
	puppet_cutscene(delta, pos_chosen)
	if Puppet.outline_appear:
		outlines.visible = true

func _outline_chosen(position):
	print("outline selected position ", position)
	
	# hide outlines that aren't selected
	pos_chosen = position
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
	# display action menu
	action_menu.visible = true

func _on_move_puppet():
	Puppet.outline_appear = false
	outlines.visible = false
	cutscene_on_down = true

func puppet_cutscene(delta: float, pos_chosen) -> void:
	if cutscene_on_down:
		# move sideways (UPDATE IF ITS RIGHT OR LEFT)
		match pos_chosen:
			1:
				puppet.global_position = puppet.global_position.move_toward(one_down.global_position, delta * cutscene_speed)
				if puppet.global_position == one_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
			2:
				puppet.global_position = puppet.global_position.move_toward(two_down.global_position, delta * cutscene_speed)
				if puppet.global_position == two_down.global_position:
					cutscene_on_up = true
					cutscene_on_down = false
		
	if cutscene_on_up:
		# move up
		match pos_chosen:
			1:
				puppet.global_position = puppet.global_position.move_toward(one_up.global_position, delta * cutscene_speed)
				if puppet.global_position == one_up.global_position:
					cutscene_on_up = false
			2:
				puppet.global_position = puppet.global_position.move_toward(two_up.global_position, delta * cutscene_speed)
				if puppet.global_position == two_up.global_position:
					cutscene_on_up = false
	# action animation plays
	# action timer starts
