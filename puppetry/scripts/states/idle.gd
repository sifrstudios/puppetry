extends State
class_name Idle

@export var rogue_timer: Timer
@export var puppet: CharacterBody2D
@export var timer_bar: Control
var start_time = rogueTime()
func Enter():
	puppet.add_to_group("puppets")
	rogue_timer.start(rogueTime())
	rogue_timer.connect("timeout", Callable(self, "_on_turn_rogue_timeout"))
	puppet.EnterAction.connect(on_enter_action)
	puppet.current_animation_state = Puppet.animation_state.Idle
	puppet.ResetTimers.connect(_on_reset_timers)
	
func Exit():
	puppet.remove_from_group("puppets")
	rogue_timer.stop()
	
func _on_turn_rogue_timeout():
	Transitioned.emit(self, "rogue")

func Physics_Update(delta: float):
	timer_bar.set_value(rogue_timer, start_time)

func on_enter_action():
	Transitioned.emit(self, "acting")
	
func _on_reset_timers():
	start_time = rogueTime()
	rogue_timer.start(start_time)
	
func rogueTime():
	return randi_range(15,30) * (3/Globals.scene_counter if Globals.scene_counter != 0 else 1)
