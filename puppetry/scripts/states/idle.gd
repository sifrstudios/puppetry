extends State
class_name Idle

@export var rogue_timer: Timer
@export var puppet: CharacterBody2D

func Enter():
	rogue_timer.start(puppet.rogue_timer_start)
