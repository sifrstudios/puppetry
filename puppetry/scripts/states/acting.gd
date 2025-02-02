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
		elif Globals.previous_action == "raise_right":
			puppet.current_animation_state = Puppet.animation_state.Wave
		elif Globals.previous_action == "raise_left":
			puppet.current_animation_state = Puppet.animation_state.Dance4
		elif Globals.previous_action == "cross":
			puppet.current_animation_state = Puppet.animation_state.Dance3
