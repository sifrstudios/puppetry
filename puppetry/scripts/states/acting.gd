extends State
class_name Acting

@export var puppet: CharacterBody2D

func Enter():
	puppet.ExitAction.connect(_on_exit_action)
	print("acting")

func _on_exit_action():
	Transitioned.emit(self, "idle")
	
func Physics_Update(delta: float):
	if Globals.puppet_key == puppet.key:
		if Globals.previous_action == "idle":
			puppet.current_animation_state = Puppet.animation_state.Idle
		elif Globals.previous_action == "kungfu":
			puppet.current_animation_state = Puppet.animation_state.Dance4
		elif Globals.previous_action == "wave_arms":
			puppet.current_animation_state = Puppet.animation_state.Dance1
		elif Globals.previous_action == "cross_wave":
			puppet.current_animation_state = Puppet.animation_state.Dance3
		elif Globals.previous_action == "shuffle":
			puppet.current_animation_state = Puppet.animation_state.Dance2
