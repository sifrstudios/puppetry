extends State
class_name Idle

@export var rogue_timer: Timer
@export var puppet: CharacterBody2D
@export var timer_bar: Control
func Enter():
	puppet.add_to_group("puppets")
	rogue_timer.start(puppet.rogue_timer_start)
	rogue_timer.connect("timeout", Callable(self, "_on_turn_rogue_timeout"))
	print(rogue_timer.time_left)
	puppet.EnterAction.connect(on_enter_action)
	puppet.current_animation_state = Puppet.animation_state.Idle
	print("idle")
	
func Exit():
	puppet.remove_from_group("puppets")
	rogue_timer.stop()
	
func _on_turn_rogue_timeout():
	Transitioned.emit(self, "rogue")

func Physics_Update(delta: float):
	timer_bar.set_value(rogue_timer, puppet.rogue_timer_start)

func on_enter_action():
	Transitioned.emit(self, "acting")
