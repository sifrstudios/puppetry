extends CharacterBody2D

@onready var turn_rogue: Timer = $Turn_Rogue
@onready var turn_back: Timer = $Turn_back
@onready var action: Timer = $action

var in_action = false;
var is_rogue = false;
var rogue_forever = false;
var beside_rogue = false;
var in_npc_area = false;
var gain_control = false;

func _ready() -> void:
	add_to_group("puppets")

func _process(delta: float) -> void:
	if is_rogue:
		if rogue_forever:
			Rogue()
		else:
			turn_back.start()
			if gain_control:
				is_rogue = false
				
	else:
		if beside_rogue:
			turn_rogue.start()
		else:
			if in_action:
				action_system()
			else:
				turn_rogue.start()
	
func Rogue():
	if in_npc_area:
		corrupt()
	else:
		move()
	
func action_system():
	pass
	
func _on_turn_rogue_timeout() -> void:
	is_rogue = true
	
func move():
	pass
	
func corrupt():
	pass


func _on_turn_back_timeout() -> void:
	rogue_forever = true
